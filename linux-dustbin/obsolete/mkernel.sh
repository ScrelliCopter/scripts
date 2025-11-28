#!/bin/bash

die()
{
	echo >&2 "$@"
	exit 1
}

help()
{
	echo "list of commands:"
	echo
	echo "$@ help ----------------------- show this help"
	echo
	echo "$@ fetch <archive version> ---- fetch and extract kernel"
	echo "$@ build <archive version> ---- fetch & build kernel"
	echo "$@ package <archive version> -- fetch, build, & package kernel"
	echo "$@ install <archive version> -- install built kernel (root required)"
	echo "$@ unpack <archive version> --- install kernel from package (root required)"
	echo "$@ remove <release version> --- remove kernel from system (root required)"
	echo
	echo "\"archive version\" -- downloaded archive version string, ie. 5.4"
	echo "\"release version\" -- full version string, ie. 5.4.0, 5.4.0-rc8, 5.4.0_1"
	echo
}

get_info()
{
	#. $(dirname "$0")/mkernel.conf
	. ./mkernel.conf
	
	VERSION="$@"
	#CONFIG=".config"
	#CONFIG="kernelconfig"

	WORKDIR="linux-$VERSION"
	ARCHIVE="$WORKDIR.tar.xz"
	MIRROR="https://cdn.kernel.org/pub/linux/kernel"
	REMOTE="${MIRROR}/v${VERSION%%.*}.x/${ARCHIVE}"

	# shit hack for fetching RCs
	if expr "$VERSION" : ".*-rc[0-9][0-9]*$" > /dev/null
	then
		ARCHIVE="$WORKDIR.tar.gz"
		MIRROR="https://git.kernel.org/torvalds/t"
		REMOTE="${MIRROR}/${ARCHIVE}"
	fi
}

fetch()
{
	if [ ! -d "$WORKDIR" ]
	then
		# fetch archive
		[ -f "$ARCHIVE" ] || wget "$REMOTE" || die "unable to fetch archive"

		# extract archive
		tar -xvf "$ARCHIVE" || die "unable to extract archive"
	fi
	[ -f "$WORKDIR/.config" ] || cp "$CONFIG" "$WORKDIR/.config" || die "kernel config missing"
}

setup_buildenv()
{
	# 1 core = 1 thread, else num cores + 1
	NPROC="$(nproc)"
	[ "$NPROC" -gt 1 ] && NPROC="$((${NPROC} + 1))"

	[ -z "$KCFLAGS" ] || export KCFLAGS="$KCFLAGS"
}

build()
{
	[ -d "$WORKDIR" ] || die "nonexistent directory"
	pushd "$WORKDIR"

	setup_buildenv

	make olddefconfig || die "make olddefconfig failed"
	make bzImage modules "-j${NPROC}" || die "make bzImage && modules failed"

	popd
}

package()
{
	[ -d "$WORKDIR" ] || die "nonexistent directory"
	pushd "$WORKDIR"

	setup_buildenv

	make olddefconfig || die "make olddefconfig failed"
	make targz-pkg "-j${NPROC}" INSTALL_MOD_STRIP=1
	
	VERSION="$(make -s kernelrelease)"
	ARCHIVE="linux-$VERSION-x86.tar.gz"
	mv "$ARCHIVE" ../

	popd
}

#make_initramfs()
#{
	#dracut -f --lzma "$BOOT/initramfs-${VERSION}.img" "${VERSION}" || die "failed to run dracut"
	#update-initramfs -c -k "${VERSION}" || die "failed to run update-initramfs"
#}

install()
{
	BOOT="/boot"

	[ -d "$WORKDIR" ] || die "nonexistent directory"
	[ "$EUID" -eq 0 ] || die "install must be ran as root"

	pushd "$WORKDIR"

	# get actual version string
	VERSION="$(make -s kernelrelease)"
	IMAGE="$(make -s image_name)"

	make modules_install INSTALL_MOD_STRIP=1 || die "make modules_install failed"
	cp $IMAGE "$BOOT/vmlinuz-$VERSION" || die "failed to copy kernel to $BOOT"
	make_initramfs

	popd

	echo
	echo "to remove or run (as root):"
	echo "  ./mkernel remove $VERSION"
	echo
}

unpack()
{
	BOOT="/boot"
	VERSION="$@"
	ARCHIVE="linux-$VERSION-x86.tar.gz"
	VMLINUX="vmlinux-$VERSION"

	[ -f "$ARCHIVE" ] || die "nonexistent archive"
	[ "$EUID" -eq 0 ] || die "unpack must be ran as root"

	tar -C /boot/ --exclude="$VMLINUX" -xf "$ARCHIVE" boot --strip-components=1 || die "unable to extract package"
	tar -C /lib/modules/ --exclude="lib/modules/$VERSION/build" --exclude="lib/modules/$VERSION/source" -xf "$ARCHIVE" lib/modules --strip-components=2  || die "unable to extract package"
	
	make_initramfs
}

rmfile() { [ -f "$1" ] && echo "deleting \"$1\"" && rm "$1"; }
remove()
{
	VERSION="$@"

	BOOT="/boot"
	MODDIR="/lib/modules/$VERSION"

	[ "$EUID" -eq 0 ] || die "remove must be ran as root"

	rmfile "$BOOT/config-$VERSION"
	rmfile "$BOOT/System.map-$VERSION"
	rmfile "$BOOT/vmlinux-$VERSION"
	rmfile "$BOOT/vmlinuz-$VERSION"
	rmfile "$BOOT/initramfs-${VERSION}.img"
	rmfile "$BOOT/initrd.img-${VERSION}"
	[ -d "$MODDIR" ] && echo "deleting \"$MODDIR\"" && rm -rf "$MODDIR"
}


[ "$#" -ge 1 ] || die "command required but none provided"
case "$1" in
	help)
		help "$0"
		;;
	fetch)
		[ "$#" -eq 2 ] || die "fetch requires a version number"
		get_info "$2"
		fetch
		;;
	build)
		[ "$#" -eq 2 ] || die "build requires a version number"
		get_info "$2"
		fetch
		build
		echo
		echo "now run (as root):"
		echo "  $0 install $VERSION"
		echo
		;;
	package)
		[ "$#" -eq 2 ] || die "package requires a version number"
		get_info "$2"
		fetch
		package
		echo
		echo "now run (as root):"
		echo "  $0 unpack $VERSION"
		echo
		;;
	install)
		[ "$#" -eq 2 ] || die "install requires a version number"
		get_info "$2"
		install
		;;
	unpack)
		[ "$#" -eq 2 ] || die "unpack requires a version number"
		get_info "$2"
		unpack "$2"
		;;
	remove)
		[ "$#" -eq 2 ] || die "remove requires a version number"
		remove "$2"
		;;
	*)
		die "unknown command"
		;;
esac
