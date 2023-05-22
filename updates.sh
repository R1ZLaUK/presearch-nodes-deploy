#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to automatically accept prompts
export DEBIAN_FRONTEND=noninteractive

# Update package lists
sudo apt update

# Run unattended upgrades
sudo unattended-upgrade -d

# Check if a reboot is required
if [ -f /var/run/reboot-required ]; then
  # Schedule a reboot in 1 minute
  sudo shutdown -r +1 "Server will be restarted in 1 minute."
fi
