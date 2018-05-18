#!/bin/sh

set -o errexit
set -o nounset
set -o xtrace


python manage.py migrate
until python manage.py runserver_plus 0.0.0.0:8000; do
    echo "Restart django" >&2
    sleep 3
done
