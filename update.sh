#!/usr/bin/env bash

AIRCRAFTS_URL="https://svn.code.sf.net/p/flightgear/fgaddon/trunk/Aircraft/"
AIRCRAFTS_LIST=( "737-800" "PC-9M" "PC-12" "dhc6" )
ADDONS_URL="https://svn.code.sf.net/p/flightgear/fgaddon/trunk/Addons/"
ADDONS_LIST=( "Headtracker" )

AIRCRAFTS_FOLDER="aircrafts"
ADDONS_FOLDER="addons"

# Get current folder
folder_now="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

echo "Updating aircrafts"

# Clone aircrafts
for each_ac in "${AIRCRAFTS_LIST[@]}"; do
	echo "Updating ${each_ac}"
	svn co "${AIRCRAFTS_URL}${each_ac}" "${folder_now}/${AIRCRAFTS_FOLDER}/${each_ac}"
done

echo "Updating addons"

# Clone addons
for each_ad in "${ADDONS_LIST[@]}"; do
	echo "Updating ${each_ad}"
	svn co "${ADDONS_URL}${each_ad}" "${folder_now}/${ADDONS_FOLDER}/${each_ad}"
done

echo "Done"
