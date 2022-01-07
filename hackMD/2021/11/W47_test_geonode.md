###### tags: `11/21`
# W47 test geonode

[documentation](https://docs.geonode.org/en/master/)
[github](https://github.com/GeoNode/geonode)
[dockerhub](https://hub.docker.com/u/geonode)
[docker-compose](https://github.com/GeoNode/geonode/blob/master/docker-compose.yml)

docker installation currently not working (django container can't connect to geoserver container)

docker-compose list:
- custom django application. It includes Geonode.
    - django
    - celery
    - nginx
    - letsencrypt
- geoserver backend
    - geoserver
    - data-dir-conf (geoserver_data):
        - The data-docker project can be your base data container volume to add data from scratch to GeoServer and PostGIS and then make them persisted when you want to stop your current containers.
    - db (postgis)
    - rabbitmq (needed by celery)

### Documentation
[docu](https://docs.geonode.org/en/master)
[wiki](https://github.com/GeoNode/geonode/wiki)

#### Basics
[presentation](https://docs.geonode.org/en/master/start/index.html)
- Geospatial data storage
- Data mixing, maps creation
- GeoNode as a building block:
    - other Open Source projects extend GeoNode’s functionality.
#### Users
- unregistered users have read-only access to public maps, layers and documents
- GeoNode is primarily a social platform
#### Data
three main types of resources that GeoNode can manage: Documents, Layers, Maps

#### Configuration
- Customize look and feel
- Permissions
- Read-Only and Maintenance mode
- Harvesting from : 
    - other GeoNode instances
    - OGC WMS servers
    - ArcGIS REST services
- Harvesting workflows:
    - Continuous harvesting
    - One-time harvesting
- Monitoring:
    - Analytics
    - collect metrics
    - Monitoring Dashboard
        - Software Performance
        - Hardware Performance
    - [GeoHealthCheck](https://geohealthcheck.org/)
    - API for monitoring
    - User Analytics
    - Notifications
- Full GeoNode Backup & Restore
- B/R Jenkins Job in Docker environment

#### Administering
- create groups
- create workflows
- ...

#### API
https://docs.geonode.org/en/master/devel/api/V2/index.html
