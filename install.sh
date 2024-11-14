#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root or with sudo."
  exit 1
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker --version
sudo docker compose --version
echo "Docker installation completed successfully!"

DOCKER_COMPOSE_FILE="./docker-compose.yml"
ID_RSA_FILE="./id_rsa"

if [ -f "$ID_RSA_FILE" ]; then
  USER_HOME=$(eval echo ~$(whoami))
  SSH_DIR="$USER_HOME/.ssh"
  
  if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
  fi

  cp "$ID_RSA_FILE" "$SSH_DIR/id_rsa"
  chmod 600 "$SSH_DIR/id_rsa"
  chmod 700 "$SSH_DIR"

  if [ -f "$SSH_DIR/id_rsa" ]; then
    echo "Private key installed successfully in $SSH_DIR."
  else
    echo "Failed to install the private key."
    exit 1
  fi
else
  echo "No private key file found (id_rsa). Please place it next to this script."
fi

if [ -f "$DOCKER_COMPOSE_FILE" ]; then
  sudo docker compose up -d
  sleep 1
  echo "One moment"
  sleep 1
  echo "Almost there..."
  sleep 1
  echo "I'm trying :("
  sleep 1
  docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) | sed 's/^\/\+//'
else
  echo "No docker-compose.yml file found in the current directory. Please place one next to this script."
fi