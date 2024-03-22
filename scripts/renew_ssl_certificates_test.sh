#!/bin/bash
#
# Script to test renew certification

# test if traefik is up
# if true throw error
# TODO
# else ask for generate or renew certs

DOMAIN_NAMES="catalog.geohistoricaldata.org,\
    traefik.geohistoricaldata.org,\
    portainer.geohistoricaldata.org,\
    iiif.geohistoricaldata.org,\
    pgadmin.geohistoricaldata.org,\
    database.geohistoricaldata.org,\
    portainer.geohistoricaldata.org,\
    preview.geohistoricaldata.org,\
    rdf.geohistoricaldata.org,\
    dir.geohistoricaldata.org,\
    map.geohistoricaldata.org,\
    directory.geohistoricaldata.org"
    # Not used at the moment
    # ontop.geohistoricaldata.org

if [ ! "$(docker ps -q -f name=catalog-traefik-1)" ]
then
    echo "Traefik not running, testing certificates renewal"
    echo "-------------"
    echo "testing (dry-run) certs renewal for all services"
    sudo certbot certonly --standalone --dry-run -d $DOMAIN_NAMES
else
    echo "Traefik running. It must be stopped for certbot to work."
    echo "you can execute the following command to stop traefik :"
    echo "docker compose stop traefik"
fi
