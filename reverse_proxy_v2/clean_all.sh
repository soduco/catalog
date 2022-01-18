#!/bin/bash

echo "---"
echo "cleaning reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml down -v

echo "---"
echo "cleaning CKAN"
echo "---"
docker-compose -f ckan/contrib/docker/docker-compose.yml down -v
