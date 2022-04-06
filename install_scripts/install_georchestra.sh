#!/bin/bash

# update OS
echo "****************"
echo "Updating OS"
echo "****************"
sudo apt-get update && \
sudo apt-get -f upgrade

# remove old docker version and set up repository for debian
echo "****************"
echo "Removing old docker version"
echo "****************"
sudo apt-get remove docker docker-engine docker.io containerd runc

echo "****************"
echo "adding docker debian repository"
echo "****************"
sudo apt-get update && \
  sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# --yes added on gpg to force overwrite if file already exist
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker engine
echo "****************"
echo "Installing docker engine"
echo "****************"
sudo apt-get update && \
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# test docker
echo "****************"
echo "checking docker engine"
echo "****************"
docker -v
# sudo docker run hello-world

# add docker to sudo group and activate changes
echo "****************"
echo "adding docker to sudo group"
echo "****************"
sudo groupadd docker && \
sudo usermod -aG docker $USER && \
newgrp docker 

# test docker with admin privileges
echo "****************"
echo "testing docker with admin privileges"
echo "****************"
docker run hello-world

# docker-compose installation
echo "****************"
echo "Installing docker engine"
echo "****************"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# test docker-compose
echo "****************"
echo "checking docker-compose"
echo "****************"
docker-compose --version

# git installation
echo "****************"
echo "git installation"
echo "****************"
sudo apt-get update && \
sudo apt-get -y install git

# clone git folder and rename it
echo "****************"
echo "cloning repo"
echo "****************"

if [ -d "docker" ]; then
  echo "folder \"docker/\" already exist, can't clone from github"
  exit 0
else
  git clone --recurse-submodules https://github.com/georchestra/docker.git
fi

# changing ip to 134.158.75.35
echo "****************"
echo "setting ip to 134.158.75.35"
echo "****************"
# line for traeffik
find docker/. \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/127-0-1-1/134-158-75-35/g'
# line for mapstore config
find docker/. \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/127.0.0.1/134.158.75.35/g'

# check if georchestra_docker already exist
if [ -d "georchestra_docker" ]; then
  echo "****************"
  echo "folder georchestra_docker already exist"
  echo "git folder pulled into docker/"
  echo "****************"
else
  echo "****************"
  echo "renaming repo to georchestra_docker"
  echo "****************"
  mv docker/ georchestra_docker/
fi

# echo "****************"
# echo "launching georchestra"
# echo "****************"
# docker-compose -f georchestra_docker/docker-compose.yml up -d