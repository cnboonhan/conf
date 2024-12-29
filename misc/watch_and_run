#!/bin/bash

if ! command -v inotifywait &> /dev/null
then
    echo "inotifywait could not be found, installing..."
    sudo apt install inotify-tools -y
fi

if [ -z "$1" ]; then
    echo "No file specified to watch. Please provide a file path."
    exit 1
fi

if [ -z "$2" ]; then
    echo "No Command specified to Run. Please provide a command."
    exit 1
fi

FILE_TO_WATCH="$1"
COMMAND_TO_RUN="$2"

while inotifywait -q -e modify,create,delete,close_write "$FILE_TO_WATCH"; do
    # Run the command
    bash -l -c "$COMMAND_TO_RUN"
done

