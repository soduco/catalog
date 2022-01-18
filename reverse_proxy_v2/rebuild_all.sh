#!/bin/bash

echo "---"
echo "rebuilding CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml build

echo "---"
echo "rebuilding reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml build
