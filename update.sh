#!/bin/bash
set -xeo pipefail

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

while getopts "a:c:s:q:u:d:o:m:v:z:" opt; do
    case "$opt" in
    a)  ARCH=$OPTARG
        ;;
    c)  CONTAINER_ARCH=$OPTARG
        ;;
    s)  SUITE=$OPTARG
        ;;
    q)  QEMU_ARCH=$OPTARG
        ;;
    u)  QEMU_VER=$OPTARG
        ;;
    d)  DOCKER_REPO=$OPTARG
        ;;
    o)  UNAME_ARCH=$OPTARG
        ;;
    m)  MIRROR=$OPTARG
        ;;
    v)  BOOTSTRAP_VERSION=$OPTARG
        ;;
    z)  OS=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

CONTAINER_PLATFORM="${OS}/${CONTAINER_ARCH}"
echo "Building Debian $ARCH/$SUITE for Docker $CONTAINER_PLATFORM with qemu $QEMU_ARCH $QEMU_VER"

EXTRA_PACKAGES="adduser apt apt-transport-https autoconf bash build-essential ca-certificates curl debian-ports-archive-keyring git libcap2-bin libnetfilter-queue-dev libnfnetlink-dev libsodium-dev libssl-dev lsb-release nftables python3 python3-build python3-dev python3-venv python3-virtualenv sudo joe wget"

dir="$SUITE-$ARCH"
VARIANT="minbase"
VERSION_ALT="sid"
args=( -d "$dir" debootstrap --verbose --no-check-gpg --variant="$VARIANT" --include="$EXTRA_PACKAGES" --arch="$ARCH" "$VERSION_ALT" "$MIRROR")

mkdir -p mkimage $dir
curl https://raw.githubusercontent.com/moby/moby/6f78b438b88511732ba4ac7c7c9097d148ae3568/contrib/mkimage.sh > mkimage.sh
curl https://raw.githubusercontent.com/moby/moby/6f78b438b88511732ba4ac7c7c9097d148ae3568/contrib/mkimage/debootstrap > mkimage/debootstrap
chmod +x mkimage.sh mkimage/debootstrap

mkimage="$(readlink -f "${MKIMAGE:-"mkimage.sh"}")"
{
    echo "$(basename "$mkimage") ${args[*]/"$dir"/.}"
    echo
    echo 'https://github.com/moby/moby/blob/6f78b438b88511732ba4ac7c7c9097d148ae3568/contrib/mkimage.sh'
} > "$dir/build-command.txt"

sudo DEBOOTSTRAP="debootstrap" nice ionice -c 2 "$mkimage" "${args[@]}" 2>&1 | tee "$dir/build.log"
cat "$dir/build.log"

sudo chown -R "$(id -u):$(id -g)" "$dir"

xz -d < $dir/rootfs.tar.xz | gzip -c > $dir/rootfs.tar.gz
sed -i /^ENV/d "${dir}/Dockerfile"
echo "ENV ARCH=${UNAME_ARCH} UBUNTU_SUITE=${SUITE} DOCKER_REPO=${DOCKER_REPO}" >> "${dir}/Dockerfile"

if [ "$DOCKER_REPO" ]; then
  docker buildx build --provenance false --platform $CONTAINER_PLATFORM -t "${DOCKER_REPO}:slim" "${dir}"
  mkdir -p "${dir}/full"
  (
  cd "${dir}/full"
  if [ ! -f x86_64_qemu-${QEMU_ARCH}-static.tar.gz ]; then
      wget -N https://github.com/ioerror/qemu-user-static/releases/download/${QEMU_VER}/x86_64_qemu-${QEMU_ARCH}-static.tar.gz
  fi
  tar -vxf x86_64_qemu-${QEMU_ARCH}-static.tar.gz 
  )
  cat > "${dir}/full/Dockerfile" <<EOF
FROM ${DOCKER_REPO}:slim
ADD qemu-* /usr/bin/
EOF
  docker buildx build --provenance false --platform $CONTAINER_PLATFORM -t "${DOCKER_REPO}:${BOOTSTRAP_VERSION}-${OS}-${ARCH}" "${dir}/full"
  docker image tag "${DOCKER_REPO}:${BOOTSTRAP_VERSION}-${OS}-${ARCH}" "${DOCKER_REPO}:latest-${OS}-${ARCH}"
  docker rmi "${DOCKER_REPO}:slim"
fi
