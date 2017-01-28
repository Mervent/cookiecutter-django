#!/bin/bash
# stop on errors
set -e

# export the postgres password so that subsequent commands don't ask for it
export PGPASSWORD=$POSTGRES_PASSWORD

echo "creating backup"
echo "---------------"

FILENAME=backup_$(date +'%Y_%m_%dT%H_%M_%S').sql.gz
pg_dump -h postgres -U $POSTGRES_USER django | gzip > /backups/$FILENAME

echo "successfully created backup $FILENAME"
