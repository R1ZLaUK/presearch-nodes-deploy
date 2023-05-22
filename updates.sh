#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to automatically accept prompts
export DEBIAN_FRONTEND=noninteractive

# Update package lists and upgrade installed packages
sudo apt update && sudo apt upgrade -y

# Install unattended-upgrades package
sudo apt-get install -y unattended-upgrades

# Configure unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
