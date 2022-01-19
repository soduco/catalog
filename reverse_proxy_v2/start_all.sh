#!/bin/bash

echo "---"
echo "starting CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml up -d

echo "---"
echo "starting Geonetwork"
echo "---"
docker-compose -f geonetwork/docker-compose.yml up -d

echo "---"
echo "starting Portainer"
echo "---"
docker-compose -f portainer/docker-compose.yml up -d

echo "---"
echo "starting reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml up -d
