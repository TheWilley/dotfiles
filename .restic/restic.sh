#!/bin/bash

source $HOME/.restic/restic.env

# Edit this line
BACKUP_DRIVE="/mnt/tretioo/Backup"

LOG_FILE="$HOME/.restic/restic.log"

# Get the current date and time
CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")

# Append the date and time to the file
echo "===== Snapshot Log: $CURRENT_DATETIME =====" >> "$LOG_FILE"

# Run backup
restic backup $BACKUP_DRIVE 2>&1 | tee -a $LOG_FILE

echo -e "\n" >> "$LOG_FILE"

# Append the output of 'restic snapshots' to the file
restic snapshots >> "$LOG_FILE" 2>&1

# Add a separator for readability
echo -e "\n=============================================\n" >> "$LOG_FILE"

# Cleanup
restic forget --keep-weekly 3 --prune
