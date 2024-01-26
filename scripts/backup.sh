#!/bin/bash

if [ "${RCON_ENABLED}" = true ]; then
        rcon-cli save
fi

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="/workspace/backups/palworld-save-${DATE}.tar.gz"
cd /workspace/Pal/ || exit

tar -zcf "$FILE_PATH" "Saved/"
echo "backup created at $FILE_PATH"
