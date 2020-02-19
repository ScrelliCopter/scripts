#!/bin/sh
set -e
#VERSION="3.10.1"
VERSION="4.0-beta1"
#INSTALLDIR="$HOME/Programs/audacious"
INSTALLDIR="$HOME/Programs/audacious-$VERSION"
FLAGS="--disable-gtk --enable-qt"

BASEURL="https://distfiles.audacious-media-player.org/audacious-${VERSION}.tar.bz2"
PLUGURL="https://distfiles.audacious-media-player.org/audacious-plugins-${VERSION}.tar.bz2"

[ -f "audacious-${VERSION}.tar.bz2" ] || wget "$BASEURL"
[ -d "audacious-${VERSION}" ] && rm -rf "audacious-${VERSION}"
tar -xvf "audacious-${VERSION}.tar.bz2"
cd "audacious-${VERSION}"
./configure $FLAGS "--prefix=/usr"
make "-j$(nproc --all)"
mkdir -p "$INSTALLDIR"
make install "DESTDIR=$INSTALLDIR"
cd ..

SEDPATH="$(echo "$INSTALLDIR" | sed 's_/_\\/_g')"
sed -i "s/^prefix=\/usr$/prefix=$SEDPATH\/usr/" "$INSTALLDIR/usr/lib/pkgconfig/audacious.pc"
sed -i 's/plugin_dir=${exec_prefix}/plugin_dir=\/usr/' "$INSTALLDIR/usr/lib/pkgconfig/audacious.pc"

[ -f "audacious-plugins-${VERSION}.tar.bz2" ] || wget "$PLUGURL"
[ -d "audacious-plugins-${VERSION}" ] && rm -rf "audacious-plugins-${VERSION}"
tar -xvf "audacious-plugins-${VERSION}.tar.bz2"
cd "audacious-plugins-${VERSION}"
#export PKG_CONFIG_SYSROOT_DIR="$INSTALLDIR"
export PKG_CONFIG_PATH="$INSTALLDIR/usr/lib/pkgconfig"
./configure $FLAGS "--prefix=/usr"
make "-j$(nproc --all)"
make install "DESTDIR=$INSTALLDIR"

cat > "$INSTALLDIR/audacious.sh" <<"EOF"
#!/bin/sh
HERE="$(dirname "$0")"
export LD_LIBRARY_PATH="$HERE/usr/lib"
exec "$HERE/usr/bin/audacious" "$@"
EOF
chmod u+x "$INSTALLDIR/audacious.sh"
