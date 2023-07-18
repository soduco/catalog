# Notice d'utilisation du docker compose

Liste des services dans le Docker-compose.yml

Si ce n'est pas précisé, les images des services sont fetch sur dockerhub

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

Image générée depuis le Dockerfile présent dans le répertoire *webgl2-preview*

```bash
docker build -t webgl2-preview .
```

L'outil Allmaps de visualisation des cartes au format IIIF

url : [preview.geohistoricaldata.org](preview.geohistoricaldata.org)

## ontop

Outil pour le web sémantique (Graphe virtuel, Endpoint SPARQL, mappings rdf)

url : [ontop.geohistoricaldata.org](ontop.geohistoricaldata.org)

## Lodview

Image générée depuis le Dockerfile présent dans le répertoire *LodView*

```bash
docker build -t lodview:latest .
```

Outil pour visualiser de manière jolie les résultats des requêtes SPARQL effectuées dans Ontop

url : [rdf.geohistoricaldata.org](rdf.geohistoricaldata.org)

## ontop_rdf

Autre instance de ontop pour le travail de Solenn sur les photographes.

url : [dir.geohistoricaldata.org](dir.geohistoricaldata.org)

## cantaloupe

Serveur *IIIF Image API* pour stocker nos images IIIF

url : [iiif.geohistoricaldata.org](iiif.geohistoricaldata.org)
