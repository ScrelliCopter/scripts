!/usr/bin/env bash
set -e

VERSION="5.3.7"
CONFIG=".config"

WORKDIR="linux-$VERSION"
ARCHIVE="$WORKDIR.tar.xz"
MIRROR="https://cdn.kernel.org/pub/linux/kernel"
NPROC="-j$(nproc)"

[ -f "$ARCHIVE" ] || wget "${MIRROR}/v${VERSION%%.*}.x/${ARCHIVE}"
[ -d "$WORKDIR" ] || tar -xvf "$ARCHIVE"
[ -f "$WORKDIR/.config" ] || cp "$CONFIG" "$WORKDIR/.config"

pushd "$WORKDIR"

export CFLAGS="-pipe -O2 -march=native"

make olddefconfig
make bzImage modules "$NPROC"

popd


echo "now run:"
echo " - cd $WORKDIR"
echo " - sudo make modules_install INSTALL_MOD_STRIP=1"
echo " - sudo cp arch/x86/boot/bzImage /boot/vmlinuz-$VERSION"
echo " - sudo dracut -f /boot/initramfs-${VERSION}.img ${VERSION}_1"
