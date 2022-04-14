#!/usr/bin/env bash

URL="https://svn.code.sf.net/p/flightgear/fgaddon/trunk/Aircraft/"
AIRCRAFTS_LIST=( "737-800" "PC-9M ")

FOLDER="aircrafts"

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

folder_now=$(get_folder)

for each_ac in "${AIRCRAFTS_LIST[@]}"; do
    echo snv co "${URL}${each_ac}" "${folder_now}/${FOLDER}/${each_ac}"
done
