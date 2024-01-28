#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_PATH="./backups/palworld-save-${DATE}.tar.gz"
tar -zcf "$FILE_PATH" "./Pal/Saved/"
printf "备份点已创建至: $FILE_PATH"
