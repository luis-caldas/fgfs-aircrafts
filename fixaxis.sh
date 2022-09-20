#!/usr/bin/env bash

FOLDER="evtojs"

# Get our current folder
folder_now="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# Start Stick
bash "${folder_now}/${FOLDER}/stick.sh" &

# Start Throttle
bash "${folder_now}/${FOLDER}/throttle.sh" &

# Wait for processes to end
wait