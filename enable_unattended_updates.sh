#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to automatically accept prompts
export DEBIAN_FRONTEND=noninteractive

# Enable unattended-upgrades by configuring the package
sudo sed -i 's/\/\/\s*"\${distro_id}:\${distro_codename}-updates";/        "\${distro_id}:\${distro_codename}-updates";/' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i 's/\/\/\s*"\${distro_id}:\${distro_codename}-security";/        "\${distro_id}:\${distro_codename}-security";/' /etc/apt/apt.conf.d/50unattended-upgrades

# Perform initial cleanup of unneeded packages
sudo apt-get autoremove --purge -y

# Create a cron job to run auto cleanup after 1 day and then revert to 7-day interval
(crontab -l 2>/dev/null; echo "0 0 * * 1 apt-get autoremove --purge -y") | crontab -
