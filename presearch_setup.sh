#!/bin/bash

# Update the system
sudo apt update && sudo apt upgrade -y

# Install required packages for building Presearch node
sudo apt install -y build-essential git libssl-dev libudev-dev pkg-config npm

# Install Docker
sudo apt install -y docker.io

# Add the current user to the docker group
sudo usermod -aG docker $USER

# Install Node.js (Version 14 LTS)
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

# Clone the Presearch node repository
git clone https://github.com/presearch/node.git
cd node

# Install dependencies and build the node
npm install

# Start the Presearch auto-updater
sudo docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node

# Pull the latest Presearch node Docker image
sudo docker pull presearch/node

# Start the Presearch node
sudo docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=4d2b0793e97bc536ddc9f2c981b50a1f presearch/node

# Show the logs of the Presearch node
sudo docker logs -f presearch-node

# Enable unattended-upgrades by configuring the package
sudo sed -i 's/\/\/\s*"\${distro_id}:\${distro_codename}-updates";/        "\${distro_id}:\${distro_codename}-updates";/' /etc/apt/apt.conf.d/50unattended-upgrades
sudo sed -i 's/\/\/\s*"\${distro_id}:\${distro_codename}-security";/        "\${distro_id}:\${distro_codename}-security";/' /etc/apt/apt.conf.d/50unattended-upgrades

# Perform initial cleanup of unneeded packages
sudo apt-get autoremove --purge -y

# Create a cron job to run auto cleanup after 1 day and then revert to 7-day interval
(crontab -l 2>/dev/null; echo "0 0 * * 1 apt-get autoremove --purge -y") | crontab -

# Reboot the system
sudo reboot

