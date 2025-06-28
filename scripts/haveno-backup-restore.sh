#!/bin/bash
clear
backup_script() {
    echo "This script will make an encrypted backup with zip"
    HAVENO_ORIGIN="$HOME/.local/share/Haveno-reto"
    if [ -d "$HAVENO_ORIGIN" ]; then
        read -p "Please enter the backup directory: " DEST_DIR
        if [ -d "$DEST_DIR" ]; then
            zip -re9 "$DEST_DIR/Haveno-reto_backup.zip" "$HAVENO_ORIGIN"
            echo "Your backup is available at $DEST_DIR/Haveno-reto_backup.zip"
            exit
        else
            echo "The backup directory does not exist."
        fi
    else
        echo "$HAVENO_ORIGIN does not exist."
    fi
}
restore_script() {
    echo "This script will Restore Haveno-reto"
    HAVENO_ORIGIN="$HOME/.local/share/Haveno-reto"
    read -p "Please enter where the directory where did you stored Haveno-reto_backup.zip: " HAVENO_BACKUP
      if [ -d "$HAVENO_BACKUP" ]; then
         unzip "$HAVENO_BACKUP/Haveno-reto_backup.zip"
         cp -r $HAVENO_BACKUP/Haveno-reto $HAVENO_ORIGIN
         echo "Your backup is available at $DEST_DIR/Haveno-reto_backup.zip"
         exit
      else
      echo "The backup directory does not exist."
      fi
}
if [[ "$1" == "--backup" ]]; then
    backup_script
elif [[ "$1" == "--restore" ]]; then
    restore_script
else
    echo "Usage: $0 --backup | --restore"
    exit 1
fi
