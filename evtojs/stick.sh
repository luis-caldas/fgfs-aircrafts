#!/usr/bin/env bash

NAME="Rhino Stick"
PATH_JOY=(/dev/input/by-id/usb*Saitek?Pro?Flight?X-56?Rhino?Stick*-event-joystick)
FILE="stick.xboxdrv"

# Get our current folder
folder_now="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# Move ev throttle to js throttle
sudo xboxdrv --evdev "${PATH_JOY[0]}" --device-name "${NAME}" --evdev-no-grab --config "${folder_now}/${FILE}"