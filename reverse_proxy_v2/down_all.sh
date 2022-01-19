#!/bin/bash

echo "---"
echo "stopping reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml down

echo "---"
echo "stopping Portainer"
echo "---"
docker-compose -f portainer/docker-compose.yml down

echo "---"
echo "stopping Geonetwork"
echo "---"
docker-compose -f geonetwork/docker-compose.yml down

echo "---"
echo "stopping CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml down
