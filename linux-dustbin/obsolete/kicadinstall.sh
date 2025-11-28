#!/bin/bash

export CFLAGS="-march=native -O2 -pipe"
export CXXFLAGS="$CXXFLAGS"
NPROC="$(nproc --all)"
CMARG="-DCMAKE_BUILD_TYPE=Release -DKICAD_USE_OCE=OFF -DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"

fetch_glm()
{
	local URL="https://github.com/g-truc/glm/archive"
	local VER="0.9.9.2"

	if [ ! -d "glm-${VER}/" ]; then
		wget "https://github.com/g-truc/glm/archive/0.9.9.2.tar.gz" || exit 1
		tar -xvf "${VER}.tar.gz" || exit 1
		rm -f "${VER}.tar.gz"
	fi

	GLMVER="$VER"
	GLMDIR="$(readlink -f glm-${VER})"
}

build()
{
	local D="$1"
	local CMARG="$2"

	mkdir -p "$D/build" || exit 1
	pushd "$D/build" || exit 1
	if [[ "$D" == "kicad" ]]; then
		cmake .. $CMARG || exit 1
	else
		cmake .. || exit 1
	fi
	make "-j${NPROC}" || exit 1
	sudo make install || exit 1
	popd
}

fetch_glm
build "kicad" "$CMARG -DGLM_ROOT_DIR=$GLMDIR"
