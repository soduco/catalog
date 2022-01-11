#!/bin/bash

echo "---"
echo "starting reverse-proxy"
echo "---"
docker-compose -f nginx/docker-compose.yml up -d
