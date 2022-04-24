#!/usr/bin/env bash

DEFAULT_HOST="localhost"
DEFAULT_PORT="2000"
DEFAULT_SIZE="1920x1080"
DEFAULT_RATE="120"

host="${DEFAULT_HOST}"
port="${DEFAULT_PORT}"
size="${DEFAULT_SIZE}"
rate="${DEFAULT_RATE}"

[ -n "$1" ] && host="$1"
[ -n "$2" ] && port="$2"
[ -n "$3" ] && size="$3"
[ -n "$4" ] && rate="$4"

# Stream a current screen to a udp port
ffmpeg -video_size "${size}" -framerate "${rate}" -f x11grab -i :0.0 -preset ultrafast -vcodec mpeg2video -tune zerolatency -f mpegts "udp://${host}:${port}"