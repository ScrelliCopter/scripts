#!/bin/sh

[ -z "$1" ] && { echo "Subvolume path required"; exit 1; }

BASE="$(dirname "$(realpath "$0")")"
DIR="${BASE}/$1"
NAME="$(basename "${DIR}")-$(date '+%Y%m%d')"
SNAPDIR="${BASE}/snapshots"

[ -d "${DIR}" ] || { echo "Argument is not a directory"; exit 1; }
[ "$(stat --format=%i "${DIR}")" -eq 256 ] || { echo "Not a subvolume"; exit 1; }

echo "btrfs subvolume snapshot -r "${DIR}" ${SNAPDIR}/${NAME}"
