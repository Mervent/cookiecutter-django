FROM postgres:{{ cookiecutter.postgresql_version }}

# add backup scripts
ADD backup-media.sh /usr/local/bin/backup-media
ADD backup-postgres.sh /usr/local/bin/backup-postgres
ADD restore-postgres.sh /usr/local/bin/restore-postgres
ADD list-backups.sh /usr/local/bin/list-backups

# make them executable
RUN chmod +x /usr/local/bin/backup-media
RUN chmod +x /usr/local/bin/backup-postgres
RUN chmod +x /usr/local/bin/restore-postgres
RUN chmod +x /usr/local/bin/list-backups
