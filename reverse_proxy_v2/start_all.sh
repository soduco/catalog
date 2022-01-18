#!/bin/bash

echo "---"
echo "starting CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml up -d

echo "---"
echo "starting reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml up -d
