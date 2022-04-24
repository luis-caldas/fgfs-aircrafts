#!/usr/bin/env bash

AIRCRAFTS_URL="https://svn.code.sf.net/p/flightgear/fgaddon/trunk/Aircraft/"
AIRCRAFTS_LIST=( "737-800" "PC-9M" )
ADDONS_URL="https://svn.code.sf.net/p/flightgear/fgaddon/trunk/Addons/"
ADDONS_LIST=( "Headtracker" )

AIRCRAFTS_FOLDER="aircrafts"
ADDONS_FOLDER="addons"

function get_folder() {

    # get the folder in which the script is located
    SOURCE="${BASH_SOURCE[0]}"

    # resolve $SOURCE until the file is no longer a symlink
    while [ -h "$SOURCE" ]; do

      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

      SOURCE="$(readlink "$SOURCE")"

      # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"

    done

    # the final assignment of the directory
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

    # return the directory
    echo "$DIR"
}

# Get current folder
folder_now=$(get_folder)

# Clone aircrafts
for each_ac in "${AIRCRAFTS_LIST[@]}"; do
    svn co "${AIRCRAFTS_URL}${each_ac}" "${folder_now}/${AIRCRAFTS_FOLDER}/${each_ac}"
done

# Clone addons
for each_ad in "${ADDONS_LIST[@]}"; do
    svn co "${ADDONS_URL}${each_ad}" "${folder_now}/${ADDONS_FOLDER}/${each_ad}"
done