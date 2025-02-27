#!/bin/bash

# Update package list and install prerequisites
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to the Docker group (avoids using sudo for Docker commands)
sudo usermod -aG docker $USER
newgrp docker  # Apply group change immediately

# Enable and start Docker service
sudo systemctl enable --now docker

# Verify Docker installation
docker --version
docker compose version

# Pull and set up Presearch containers
sudo docker stop presearch-node presearch-auto-updater 2>/dev/null
sudo docker rm presearch-node presearch-auto-updater 2>/dev/null

sudo docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node

sudo docker pull presearch/node

sudo docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=4d2b0793e97bc536ddc9f2c981b50a1f presearch/node

# Show logs for Presearch node
sudo docker logs -f presearch-node

echo "Installation complete. Please reboot manually if necessary."
