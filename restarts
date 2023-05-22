#!/bin/bash

# Create a temporary cron file
cron_file=$(mktemp)

# Add the reboot command to the cron file
echo "0 0 * * 0 /sbin/shutdown -r +1" >> "$cron_file"

# Install the cron job
crontab "$cron_file"

# Remove the temporary cron file
rm "$cron_file"
