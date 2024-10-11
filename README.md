# debian-ports

[![actions](https://github.com/ioerror/debian-debootstrap-ports/actions/workflows/actions.yml/badge.svg?branch=main)](https://github.com/ioerror/debian-debootstrap-ports/actions/workflows/actions.yml)
 [![Docker Pulls](https://img.shields.io/docker/pulls/polyarch/debian-debootstrap-ports)](https://hub.docker.com/r/polyarch/debian-debootstrap-ports)
[![CI](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/ioerror/debian-debootstrap-ports/blob/main/LICENSE)
 
`polyarch/debian-ports` Docker images of Debian GNU/Linux `sid`

## Usage

If your Operating System provides a modern `qemu-user-static` package and the
`binfmt-support` package then it should be sufficient to use those packages.
For example configure the docker host on Ubuntu Noble (24.10) by installing the
following packages:
```console
$ apt install qemu-user-static binfmt-support
```

Alternatively, before using any of these Docker images, you need to configure binfmt
support on your Docker host. This works both locally and remotely (e.g., using
`boot2docker` or `swarm`).

```console
$ docker run --rm --privileged polyarch/qemu-user-static --reset -p yes
```

Once configured, you can run an image from your Docker host by selected a CPU
architecture and setting it as part of the platform string:
```console
$ docker run --platform linux/loong64 -it --rm polyarch/debian-ports uname -m
loongarch64
```

## Supported ports

```
ARCH_LIST="alpha amd64 arm32v5 arm32v7 arm64v8 hppa i386 \
            loong64 m68k mips64le ppc ppc64 ppc64le riscv64 \
            s390x sh4 sparc64"
for ARCH in $ARCH_LIST;
do
docker run --platform linux/${ARCH} --rm -t \
            polyarch/debian-ports:latest uname -a
done
```

## Source of Images

All images are generated from the respective architecture specific Debian
GNU/Linux Operating System package repositories. Docker images are generated
with the included `update.sh` script and the GitHub Action that runs it.

## Notes

Only `x86_64` has been tested as a host architecture.

## Original Project

This project is based on [multiarch/debian-debootstrap](https://github.com/multiarch/debian-debootstrap), which supports a wide range of other architectures.
This project was forked from [urbanogilson/debian-debootstrap-ports](https://github.com/urbanogilson/debian-debootstrap-ports).

## License

This project is licensed under the [MIT License](LICENSE).
