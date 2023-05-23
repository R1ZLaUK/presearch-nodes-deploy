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
