#!/bin/sh

aircraft="PC-9A"
airport="EICK"
callsign="EIRW"

if [ -n "$1" ]; then
	aircraft="$1"
fi

pp_jimenezmlaa_color=32 fgfs \
	--fg-aircraft=. \
	--aircraft="$aircraft" \
	--airport="$airport" \
	--units-meters \
	--time-match-local \
	--com1="123.4" \
	--com2="121.5" \
	--enable-real-weather-fetch \
	--callsign="$callsign" \
	--multiplay=out,20,mpserver01.flightgear.org,5000 \
	--enable-terrasync
