#!/bin/bash

echo "---"
echo "rebuilding CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml build

echo "---"
echo "rebuilding Geonetwork"
echo "---"
docker-compose -f geonetwork/docker-compose.yml build

echo "---"
echo "rebuilding Portainer"
echo "---"
docker-compose -f portainer/docker-compose.yml build

echo "---"
echo "rebuilding reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml build
