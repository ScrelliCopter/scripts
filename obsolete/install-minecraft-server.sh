#!/bin/sh

MC_VERSION="1.12.2"
MC_SHA256="fe1f9274e6dad9191bf6e6e8e36ee6ebc737f373603df0946aafcded0d53167e"

FORGE_VERSION="14.23.5.2854"
FORGE_SHA256="d86b5a6dfbe9768a3c3363ba3dd0aafc1fc28f9057ca83e8820dda3d7caadaff"

sha256_check()
{
	local FILE="$1"
	local SHA256="$2"

	[ -z "${SHA256}" ] && return
	echo "${SHA256}  ${JAR}" | shasum -a 256 -c || return 1
}

fetch_server()
{
	local JAR="$1"
	local VERSION="$2"
	local SHA256="$3"

	[ -f "${JAR}" ] && return

	local FILE="minecraft_server.${VERSION}.jar"
	local URL="https://s3.amazonaws.com/Minecraft.Download/versions/${VERSION}"
	wget "${URL}/${FILE}" -O "${JAR}" || return 1
	if ! sha256_check "${JAR}" "${SHA256}"; then rm -f "${JAR}"; return 1; fi
}

fetch_forge()
{
	local JAR="$1"
	local MC_VERSION="$2"
	local FORGE_VERSION="$3"
	local SHA256="$4"

	[ -f "${JAR}" ] && return

	local FILE="forge-${MC_VERSION}-${FORGE_VERSION}-installer.jar"
	local URL="https://files.minecraftforge.net/maven/net/minecraftforge/forge/${MC_VERSION}-${FORGE_VERSION}"
	wget "${URL}/${FILE}" -O "${JAR}" || return 1
	if ! sha256_check "${JAR}" "${SHA256}"; then rm -f "${JAR}"; return 1; fi
}

curse_wget()
{
	local JAR="$1"
	local CURSEID="$2"
	local SHA256="$3"

	[ -f "${JAR}" ] && return 0

	local IDPT1="$(echo "${CURSEID}" | cut -c 1-4)"
	local IDPT2="$(echo "${CURSEID}" | cut -c 5-7)"
	local FILE="$(basename "${JAR}")"
	local URL="https://media.forgecdn.net/files/${IDPT1}/${IDPT2}"
	wget "${URL}/${FILE}" -O "${JAR}" || return 1
	if ! sha256_check "${JAR}" "${SHA256}"; then rm -f "${JAR}"; return 1; fi
}


fetch_forge forge-installer.jar "${MC_VERSION}" "${FORGE_VERSION}" "${FORGE_SHA256}" || exit 1
java -jar forge-installer.jar --installServer || exit 1
rm -f forge-installer.jar

echo '#!/bin/sh' > start.sh
echo 'JAVA=java' >> start.sh
echo "JAR=forge-${MC_VERSION}-${FORGE_VERSION}.jar" >> start.sh
echo 'exec "$JAVA" -Xmx1024M -Xms1024M -jar "$JAR" nogui' >> start.sh
chmod u+x start.sh

echo "eula=true" > eula.txt

mkdir -p "mods" || exit 1

NGT_JAR="NGTLib2.4.18-35_forge-1.12.2-14.23.2.2611.jar"
NGT_CURSEID="3003745"
curse_wget "mods/${NGT_JAR}" "${NGT_CURSEID}" || exit 1

RTM_JAR="RTM2.4.21-40_forge-1.12.2-14.23.2.2611.jar"
RTM_CURSEID="3061973"
curse_wget "mods/${RTM_JAR}" "${RTM_CURSEID}" || exit 1

WE_VERSION="6.1.10"
WE_JAR="worldedit-forge-mc${MC_VERSION}-${WE_VERSION}-dist.jar"
WE_CURSEID="2941712"
WE_SHA256="cd4768ded9e2b527e3fc093fdf4ce07f058187de7961bdc0d7fa821c1b756f75"
curse_wget "mods/${WE_JAR}" "${WE_CURSEID}" "${WE_SHA256}" || exit 1
