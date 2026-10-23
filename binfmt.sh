#!/bin/sh
# binfmt.sh DIR PERSISTENT ARCH...: register DIR/qemu-ARCH-static for each
# foreign ARCH with binfmt_misc, using the lines of qemu v11.1.2
# scripts/qemu-binfmt-conf.sh (pinned by sha256). PERSISTENT yes loads the
# interpreter now (F flag); no makes the kernel open DIR/qemu-ARCH-static
# inside each container, so the image's own qemu runs.
set -eu
d=$1 p=$2
shift 2
t=$(mktemp -d)
curl -fsS -o "$t/conf.sh" https://raw.githubusercontent.com/qemu/qemu/v11.1.2/scripts/qemu-binfmt-conf.sh
echo "5e12ef484b8364e1ba7bae4acda837d2e6320ffbeb7fab341034124553cdb137  $t/conf.sh" | sha256sum -c -
sh "$t/conf.sh" --systemd ALL --exportdir "$t" --qemu-path "$d" --qemu-suffix -static --persistent "$p" --preserve-argv0 yes > /dev/null
for a in "$@"; do
  [ ! -f "$t/qemu-$a.conf" ] || sudo sh -c "cat '$t/qemu-$a.conf' > /proc/sys/fs/binfmt_misc/register"
done
rm -rf "$t"
