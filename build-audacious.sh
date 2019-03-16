#!/bin/sh
set -e
INSTALLDIR="$HOME/Programs/audacious"
VERSION="3.10.1"
FLAGS="--disable-gtk --enable-qt"

BASEURL="https://distfiles.audacious-media-player.org/audacious-${VERSION}.tar.bz2"
PLUGURL="https://distfiles.audacious-media-player.org/audacious-plugins-${VERSION}.tar.bz2"

[ -f "audacious-${VERSION}.tar.bz2" ] || wget "$BASEURL"
[ -d "audacious-${VERSION}" ] && rm -rf "audacious-${VERSION}"
tar -xvf "audacious-${VERSION}.tar.bz2"
cd "audacious-${VERSION}"
./configure $FLAGS --prefix="$INSTALLDIR"
make "-j$(nproc --all)"
mkdir -p "$INSTALLDIR"
make install
cd ..

[ -f "audacious-plugins-${VERSION}.tar.bz2" ] || wget "$PLUGURL"
[ -d "audacious-plugins-${VERSION}" ] && rm -rf "audacious-plugins-${VERSION}"
tar -xvf "audacious-plugins-${VERSION}.tar.bz2"
cd "audacious-plugins-${VERSION}"
PKG_CONFIG_PATH="$INSTALLDIR/lib/pkgconfig" ./configure $FLAGS "--prefix=$INSTALLDIR"
make "-j$(nproc --all)"
make install

cat > "$INSTALLDIR/audacious.sh" <<"EOF"
#!/bin/sh
HERE="$(dirname "$0")"
LD_LIBRARY_PATH="$HERE/lib" "$HERE/bin/audacious"
EOF
chmod u+x "$INSTALLDIR/audacious.sh"
