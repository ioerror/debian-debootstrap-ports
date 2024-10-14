# debian-debootstrap-ports

[![actions](https://github.com/ioerror/debian-debootstrap-ports/actions/workflows/actions.yml/badge.svg?branch=main)](https://github.com/ioerror/debian-debootstrap-ports/actions/workflows/actions.yml)
 [![Docker Pulls](https://img.shields.io/docker/pulls/polyarch/debian-debootstrap-ports)](https://hub.docker.com/r/polyarch/debian-debootstrap-ports)
[![CI](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/ioerror/debian-debootstrap-ports/blob/main/LICENSE)
 
 `debian-debootstrap-ports` Docker image for multiple architectures (ports)

## Usage

Before using this Docker image, you need to configure binfmt-support on your Docker host. This works both locally and remotely (e.g., using boot2docker or swarm).

```console
$ docker run --rm --privileged polyarch/qemu-user-static --reset -p yes
```

Once configured, you can run a `loong64` image from your `x86_64` Docker host.

```console
$ docker run -it --rm polyarch/debian-debootstrap-ports:loong64-trixie-sid-qemu-v9.0.2-2 uname -m
loongarch64
```

## Supported ports

Port            | Architecture          | Description
| ------------- | --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
alpha           | Alpha	                | Port to the 64-bit RISC Alpha architecture.                                                                                                                                        |
hppa            | HP PA-RISC            | Port to Hewlett-Packard's PA-RISC architecture.                                                                                                                                    |
m68k            | Motorola 68k          | Port to the Motorola 68k series of processors — in particular, the Sun3 range of workstations, the Apple Macintosh personal computers, and the Atari and Amiga personal computers. |
powerpc/ppc64   | Motorola/IBM PowerPC  | Port for many of the Apple Macintosh PowerMac models, and CHRP and PReP open architecture machines.                                                                                |
sh4             | SuperH                | Port to Hitachi SuperH processors. Also supports the open source J-Core processor.                                                                                                 |

In addition this project produces builds for `loong64`, `powerpc`, `ppc64`, and `sparc64`.
The `alpha` architecture is currently non-functional due to a debootstrap issue.

## Source of Images

The images provided in this repository are sourced from [Debian other ports](https://www.debian.org/ports/#portlist-other).

## Original Project

This project is based on [multiarch/debian-debootstrap](https://github.com/multiarch/debian-debootstrap), which supports a wide range of other architectures.
This project was forked from [urbanogilson/debian-debootstrap-ports](https://github.com/urbanogilson/debian-debootstrap-ports).

## License

This project is licensed under the [MIT License](LICENSE).
