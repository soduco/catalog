#!/bin/bash
#
# Script to automatically renew certificates and move them to the proper folder (untill Traefik is correctly configured)

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
    echo "Traefik not running, renewing certificates."
    echo "-------------"
    echo "renewing certs for all services"
    sudo certbot certonly --standalone -d $DOMAIN_NAMES

    # move certs for traefik

    # echo "moving certs disable since certbot is on dry-run"

    CATALOG_PATH="/home/debian/catalog"
    
    echo "-------------"
    echo "Moving old ssl files to folder ssl_old"
    mkdir -p "$CATALOG_PATH/config/traefik/ssl_old"
    # mv ssl/* not working
    sudo mv "$CATALOG_PATH/config/traefik/ssl/fullchain.crt" "$CATALOG_PATH/config/traefik/ssl_old/"
    sudo mv "$CATALOG_PATH/config/traefik/ssl/privkey.pem" "$CATALOG_PATH/config/traefik/ssl_old/"

    echo "-------------"
    echo "Copying new generated ssl files to folder ssl"
    sudo cp /etc/letsencrypt/live/catalog.geohistoricaldata.org-0001/fullchain.pem /home/debian/catalog/config/traefik/ssl/fullchain.crt
    sudo cp /etc/letsencrypt/live/catalog.geohistoricaldata.org-0001/privkey.pem /home/debian/catalog/config/traefik/ssl/

    echo "-------------"
    echo "End of script"
    echo "You should consider making a backup of the new config with dump_config.sh"

else
    echo "Traefik running. It must be stopped for certbot to work."
    echo "you can execute the following command to stop traefik :"
    echo "docker compose stop traefik"
fi
