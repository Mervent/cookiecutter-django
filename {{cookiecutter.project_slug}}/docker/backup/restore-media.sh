#!/bin/bash
# stop on errors
set -e

# export the postgres password so that subsequent commands don't ask for it
echo "restoring media backup"
echo "---------------"

FILENAME=$1
tar xvf /backups/$FILENAME -C /app/media

echo "successfully restored backup $FILENAME"
