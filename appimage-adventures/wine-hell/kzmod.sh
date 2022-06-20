#!/bin/bash

export WINEPREFIX=/opt/games/winesteam

WINE="$HOME/Programs/wine-4.12.1-x86_64.AppImage"
STEAM="${WINEPREFIX}/drive_c/Program Files (x86)/Steam/Steam.exe"
STEAMARGS=""

APPID=626680
APPPROC="hl2.exe"
APPARGS="-refresh 144 -window -noborder"

echo "Launching Steam"
"${WINE}" "${STEAM}" ${STEAMARGS} -applaunch "${APPID}" ${APPARGS} &

echo "Waiting for game to start"
until pkill -0 "${APPPROC}"
do
	sleep 0.5
done

echo "Waiting for game to exit"
while pkill -0 "${APPPROC}"
do
	sleep 3
done

echo "Exiting Steam"
"${WINE}" "${STEAM}" -shutdown
