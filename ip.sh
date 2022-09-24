#!/bin/bash
ip_array=( $(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') )
count=20

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [[ $(which docker) && $(docker --version) ]]; then
    echo "Installing Docker"
    # command
  else
    echo "Install docker"
   sudo  apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get update
 sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
 echo "Docker already installed"

fi


docker network create --subnet=172.19.0.0/16 docker_presearch

#declare -p ip_array
for i in "${ip_array[@]}"
do
   : 
   #echo $i
 #  echo 172.19.0.${count}/32
   iptables -t nat -I POSTROUTING -s 172.19.0.${count}/32 -j SNAT --to-source $i
   mkdir /root/psn-prod${count}
   docker run -dt --name psn-prod${count} --restart=unless-stopped -v /root/psn-prod${count}:/app/node --net docker_presearch --ip 172.19.0.${count} -e REGISTRATION_CODE=4d2b0793e97bc536ddc9f2c981b50a1f  presearch/node

   count=$((count+1))
done
docker run -d --name presearch-auto-updater-prod --restart=unless-stopped --net docker_presearch --ip 172.19.0.3 -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater psn-prod20 psn-prod21 psn-prod22 psn-prod23 psn-prod24 psn-prod25 psn-prod26 psn-prod27 psn-prod28 psn-prod29 psn-prod30 psn-prod31 psn-prod32 psn-prod33 psn-prod34
