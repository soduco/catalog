#!/bin/bash

echo "---"
echo "stopping reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml stop

echo "---"
echo "stopping Portainer"
echo "---"
docker-compose -f portainer/docker-compose.yml stop

echo "---"
echo "stopping Geonetwork"
echo "---"
docker-compose -f geonetwork/docker-compose.yml stop

echo "---"
echo "stopping CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml stop
