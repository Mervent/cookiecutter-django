#!/bin/bash
# stop on errors
set -e

# export the postgres password so that subsequent commands don't ask for it
echo "creating media backup"
echo "---------------"

FILENAME=media_$(date +'%Y_%m_%dT%H_%M_%S').tar.bz2
tar cvjf /backups/$FILENAME -C /app/media .

echo "successfully created backup $FILENAME"
