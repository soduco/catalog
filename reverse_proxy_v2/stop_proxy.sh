#!/bin/bash

echo "---"
echo "stopping reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml down

