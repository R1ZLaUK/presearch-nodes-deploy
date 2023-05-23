#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to automatically accept prompts
export DEBIAN_FRONTEND=noninteractive

# Install unattended-upgrades package
sudo apt-get install -y unattended-upgrades

# Enable unattended-upgrades by configuring the package
sudo tee /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Perform initial cleanup of unneeded packages
sudo apt-get autoremove --purge -y

# Create a cron job to run auto cleanup after 1 day and then revert to 7-day interval
(crontab -l 2>/dev/null; echo "0 0 * * 1 apt-get autoremove --purge -y") | crontab -
