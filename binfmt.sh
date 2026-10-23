#!/bin/sh
set -eu
d=$1 p=$2
t=$(mktemp -d)
curl -fsS -o "$t/conf.sh" https://raw.githubusercontent.com/qemu/qemu/v11.1.2/scripts/qemu-binfmt-conf.sh
echo "5e12ef484b8364e1ba7bae4acda837d2e6320ffbeb7fab341034124553cdb137  $t/conf.sh" | sha256sum -c -
sh "$t/conf.sh" --systemd ALL --exportdir "$t" --qemu-path "$d" --qemu-suffix -static --persistent "$p" --preserve-argv0 yes > /dev/null
for f in "$t"/qemu-${3:-*}.conf; do [ ! -f "$f" ] || sudo sh -c "cat '$f' > /proc/sys/fs/binfmt_misc/register"; done
rm -rf "$t"
