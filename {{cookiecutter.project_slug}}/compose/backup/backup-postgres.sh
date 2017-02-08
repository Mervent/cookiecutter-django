#!/bin/bash
# stop on errors
set -e

# export the postgres password so that subsequent commands don't ask for it
export PGPASSWORD=$POSTGRES_PASSWORD

echo "creating postgres backup"
echo "---------------"

FILENAME=postgres_$(date +'%Y_%m_%dT%H_%M_%S').sql.bz2
pg_dump -h postgres -U $POSTGRES_USER django | bzip2 > /backups/$FILENAME

echo "successfully created backup $FILENAME"
