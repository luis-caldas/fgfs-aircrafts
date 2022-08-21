#!/usr/bin/env bash

# defaults
aircraft="ec135p2"
airport="EIME"
callsign="E270"

# function that finds the folder in which the script executing it is located
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

# extract current folder
current_folder="$(get_folder)"

# auto select aircraft if none given, also print all available
if [ -n "$1" ]; then
	aircraft="$1"
else
	fgfs --fg-aircraft="$current_folder" --show-aircrafts
fi

# auto select callsign if none given
if [ -n "$2" ]; then
	callsign_out="$2"
else
	callsign_out="${callsign}"
	echo "Callsign is ${callsign}"
fi

# auto select airport if none given
if [ -n "$3" ]; then
	airport_out="$3"
else
	airport_out="${airport}"
	echo "Airport is ${airport}"
fi


# run the game command
pp_jimenezmlaa_color=8 \
OSG_SPLIT_STEREO_AUTO_ADJUST_ASPECT_RATIO=ON \
FG_HOME="${current_folder}/home" \
fgfs \
	--data="${current_folder}/data" \
	--fg-aircraft="${current_folder}/aircrafts" \
	--aircraft="$aircraft" \
	--airport="$airport_out" \
	--units-meters \
	--time-match-local \
	--com1="123.4" \
	--com2="121.5" \
	--enable-real-weather-fetch \
	--callsign="$callsign_out" \
	--addon="${current_folder}/addons/Headtracker" \
	--generic=socket,in,25,127.0.0.1,5542,udp,opentrack \
	--multiplay=out,20,mpserver01.flightgear.org,5000 \
	--enable-terrasync
