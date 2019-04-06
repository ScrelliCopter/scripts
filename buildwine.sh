#!/bin/bash
set -e

# todo: probably clone and manage repos/tools here

./wine-staging/patches/patchinstall.sh --all DESTDIR=wine

mkdir -p build
pushd build
mkdir -p wine64-build wine32-build prefix/usr

pushd wine64-build
../../wine/configure --prefix=/usr --enable-win64
make -j8 install "prefix=$(realpath ../prefix/usr)"
popd

pushd wine32-build
PKG_CONFIG_PATH=/usr/lib32 ../../wine/configure --prefix=/usr --with-wine64=../wine64-build
make -j8 install "prefix=$(realpath ../prefix/usr)"
popd

cp ../wine.png prefix/
cc ../AppRun.c -s -o prefix/AppRun

cat > prefix/wine.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$(./prefix/usr/bin/wine --version)
Categories=X-Wine;
Icon=wine
TryExec=wine
Exec=wine %u
EOF

ARCH=x86_64 ../appimagetool-x86_64.AppImage prefix

popd
