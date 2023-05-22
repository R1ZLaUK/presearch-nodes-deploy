#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt-get install -y unattended-upgrades
sudo dpkg-reconfigure -a
sudo dpkg --purge ubuntu-advantage-tools cloud-init
sudo apt clean
sudo apt update
sudo apt install ubuntu-advantage-tools cloud-init
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node
sudo docker pull presearch/node
sudo docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=4d2b0793e97bc536ddc9f2c981b50a1f presearch/node
sudo docker logs -f presearch-node
sudo reboot
