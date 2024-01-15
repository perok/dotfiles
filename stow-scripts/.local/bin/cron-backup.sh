#!/bin/bash

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

# This example cron setup will backup daily at 5:30PM.
# Backup every Friday at 6:00PM.
# Do the full backup on the first of each month at 6:00AM
# $ crontab -e
#    30 17 * * * /home/perok/.config/bin/cron-backup.sh daily
#    00 18 * * 5 /home/perok/.config/bin/cron-backup.sh weekly
#    00 6 1 * *  /home/perok/.config/bin/cron-backup.sh monthly
# TODO add `> /dev/null` to avoid mail spam?
# TODO cron expects running machine. Change to anacron https://linux.die.net/man/8/anacron


# TODO bakcup crontab also
# 0 9 * * * crontab -l | gzip > /backups/'crontab-'$(date +"\%Y\%m\%d-\%H\%M\%S")'.gz'


# TODO use tar instead directly?
# https://unix.stackexchange.com/questions/215146/best-way-to-archive-after-rsync
# https://help.ubuntu.com/community/BackupYourSystem/TAR
# - NO tar does not seems to be reliable enough

## TODO Delete backup files older than 2 weeks before create the new one.
#find /var/backup/ -mtime +14 -type f -delete

TODAY="$(date +%Y-%m-%d)"

BACKUP_DIR=~/Dropbox\ \(Bekk\)
# Add `z` if backup location is over the wire
RSYNC_OPTIONS='-avP --delete --info=progress2'
# TODO --log-file=/home/your-username/Desktop/$(date +%Y%m%d)_rsync.log

case $1 in
  (dailyT)
    # TODO have as manual instead? and add to monthly with manual ad date time
    # -c --create
    tar --update -vpzf "$BACKUP_DIR/backup-dev-daily/backup.tar.gz" \
      --exclude 'node_modules' \
      --exclude 'target' \
      --exclude '.gradle' \
      --exclude '.bloop' \
      --exclude '.metals' \
      --exclude 'vendor' \
      ~/dev
    echo "Done - daily";;

  (daily)
    echo "Started: $(date)" >> "$BACKUP_DIR/backup-dev-daily/backup_job.txt"

    # -avzP - archive mode, be verbose, use compression, preserve partial files, display progress.
    rsync $RSYNC_OPTIONS \
      --exclude 'node_modules' \
      --exclude 'target' \
      --exclude '.gradle' \
      --exclude '.bloop' \
      --exclude '.metals' \
      --exclude '.terraform' \
      --exclude '.expo' \
      --exclude '.cache' \
      --exclude 'vendor' \
      --exclude 'catalina.home_IS_UNDEFINED' \
      ~/dev \
      "$BACKUP_DIR/backup-dev-daily"

    echo "Done: $(date)" >> "$BACKUP_DIR/backup-dev-daily/backup_job.txt"
    echo "Done - daily";;

  (weekly)
    echo "Started: $(date)" >> "$BACKUP_DIR/backup-dev-weekly/backup_job.txt"
    rsync $RSYNC_OPTIONS \
      "$BACKUP_DIR/backup-dev-daily" \
      "$BACKUP_DIR/backup-dev-weekly"

    echo "Done: $(date)" >> "$BACKUP_DIR/backup-dev-weekly/backup_job.txt"
    echo "Done - weekly";;

  (monthly)
    echo "Started: $(date)" >> "$BACKUP_DIR/backup-dev-monthly/backup_job.txt"

    tar -cvjf \
      "$BACKUP_DIR/backup-dev-monthly/monthly_$(date +%Y%m%d).tar.bz2" \
      "$BACKUP_DIR/backup-dev-daily"

    echo "Done: $(date)" >> "$BACKUP_DIR/backup-dev-monthly/backup_job.txt"
    echo "Done - Monthly";;
  (*)
    echo >&2 Not found
    exit 1;;
esac

exit 0

