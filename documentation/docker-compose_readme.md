# Notice d'utilisation du docker compose

Liste des services dans le Docker-compose.yml

Si ce n'est pas précisé les images des services sont téléchargés depuis dockerhub

## Traefik

Reverse-proxy pour les autres applications.
Gère la redirection en https. Peut gérer automatiquement les certificats SSL et leur renouvellement (à configurer)

url : [traefik.geohistoricaldata.org](traefik.geohistoricaldata.org)

## portainer

Dashboard pour manipuler les instances dockers (images, containers, volumes, ...)

url : [portainer.geohistoricaldata.org](portainer.geohistoricaldata.org)

## database

Base de donnée Postgis de geonetwork

Pour le moment inacessible directement depuis l'extérieur (cf. Pgadmin pour y accéder)

Un pgcron à été ajouté pour automatiser la mise à jour des vues matérialisées.

Image générée depuis le Dockerfile présent dans le répertoire `/source/postgresql-pgcron`

basé sur l'image `postgis/postgis:11-2.5` (à mettre à jour, tester la v15, utilisée dans l'exemple de geonetwork-ui)

## pgadmin4

Dashboard pour manipuler la base de donnée

url : [pgadmin.geohistoricaldata.org](pgadmin.geohistoricaldata.org)

## geonetwork

Notre catalogue

## elasticsearch

Outil utilisé par geonetwork pour indexation/recherche des données

Inacessible directement depuis l'extérieur (cf. kibana pour y accéder)

## kibana

Dashboard pour accèder aux données d'elasticsearch

Inacessible directement depuis l'extérieur, le dashboard est accessible dans les paramètres de geonetwork (Admin console -> statistics and status -> content statistics)

## preview

Image générée depuis le Dockerfile présent dans le répertoire `/source/webgl2-preview`

```bash
docker build -t webgl2-preview .
```

L'outil Allmaps de visualisation des cartes au format IIIF

url : [preview.geohistoricaldata.org](preview.geohistoricaldata.org)

## ontop

Outil pour le web sémantique (Graphe virtuel, Endpoint SPARQL, mappings rdf)

url : [ontop.geohistoricaldata.org](ontop.geohistoricaldata.org)

## Lodview

Image générée depuis le Dockerfile présent dans le répertoire `/source/LodView`

```bash
docker build -t lodview:latest .
```

Outil pour visualiser de façon plus agréable les résultats des requêtes SPARQL effectuées dans Ontop

url : [rdf.geohistoricaldata.org](rdf.geohistoricaldata.org)

## ontop_rdf

Autre instance de ontop pour le travail de Solenn sur les photographes.

url : [dir.geohistoricaldata.org](dir.geohistoricaldata.org)

## cantaloupe

Serveur *IIIF Image API* pour stocker nos images IIIF

url : [iiif.geohistoricaldata.org](iiif.geohistoricaldata.org)

Les images qui ont été testées (09/2023) sont celles de:

- UCLA Library [uclalibrary/cantaloupe:5.0.5-7](https://github.com/UCLALibrary/docker-cantaloupe)
- Teklia [registry.gitlab.teklia.com/iiif/cantaloupe:5.0.5](https://gitlab.com/armbiant/docker-cantaloupe)

Il en ressort que l'image UCLA est plus "pratique" car on peut lui passer des variable d'environnement Java pour adapter, notamment pour adapter la quantitée de ram allouée. NB: l'image UCLA utilise par défaut 80% de la RAM allouée au container. (Ne pas allouer 100% -> cause des crashs)

## geonetwork-ui

Application de visualisation des datasets présents dans notre catalogue.

url : [preview.geohistoricaldata.org](preview.geohistoricaldata.org) (à modifier)

Image générée depuis le répertoire `/source/geonetwork-ui/apps/datahub` via le script suivant:

```bash
npm install
npx nx run datahub:docker-build
```

Vous référer au README présent dans le répertoire pour plus d'informations.

## map-proxy

Proxy wms pour pouvoir fournir des flux wms sans les héberger dans un geoserver

url : [map.geohistoricaldata.org](map.geohistoricaldata.org)
