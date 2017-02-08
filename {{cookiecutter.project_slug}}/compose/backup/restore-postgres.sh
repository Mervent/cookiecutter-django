#!/bin/bash

# stop on errors
set -e

# export the postgres password so that subsequent commands don't ask for it
export PGPASSWORD=$POSTGRES_PASSWORD

# check that we have an argument for a filename candidate
if [[ $# -eq 0 ]] ; then
    echo 'usage:'
    echo '    docker-compose run postgres restore <backup-file>'
    echo ''
    echo 'to get a list of available backups, run:'
    echo '    docker-compose run postgres list-backups'
    exit 1
fi

# set the backupfile variable
BACKUPFILE=/backups/$1

# check that the file exists
if ! [ -f $BACKUPFILE ]; then
    echo "backup file not found"
    echo 'to get a list of available backups, run:'
    echo '    docker-compose run postgres list-backups'
    exit 1
fi

echo "beginning restore from $1"
echo "-------------------------"

# delete the db
# deleting the db can fail. Spit out a comment if this happens but continue since the db
# is created in the next step
echo "deleting old database django"
if dropdb -h postgres -U $POSTGRES_USER django
then echo "deleted $POSTGRES_USER database"
else echo "database django does not exist, continue"
fi

# create a new database
echo "creating new database $POSTGRES_USER"
createdb -h postgres -U $POSTGRES_USER django -O $POSTGRES_USER

# restore the database
echo "restoring database $POSTGRES_USER"
bzip2 -d $BACKUPFILE | psql -h postgres -U $POSTGRES_USER django
