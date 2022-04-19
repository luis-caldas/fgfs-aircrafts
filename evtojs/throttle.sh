#!/usr/bin/env bash

NAME="Rhino Throttle"
PATH_JOY=(/dev/input/by-id/usb*Saitek?Pro?Flight?X-56?Rhino?Throttle*-event-joystick)
FILE="throttle.xboxdrv"

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

# Get our current folder
folder_now="$(get_folder)"

# Move ev throttle to js throttle
sudo xboxdrv --evdev "${PATH_JOY[0]}" --device-name "${NAME}" --evdev-no-grab --config "${folder_now}/${FILE}"
