###### tags: `11/21`

# Réunion d'entrée 02/11/2021

## Objectif principal du projet

- Créer un catalogue en ligne contenant des corpus/séries/collections de "documents" (un document pouvant être constitué de plusieurs fichiers. ex : toutes les pages d'un annuaire)
- Possibilité d'effectuer des recherches sur ce catalogue
- Pour ce faire, il est nécessaire de créer :
    - un Backend (database + API)
    - un Frontend (interface graphique minimaliste au début)

### Premier besoin

- Récupérer et agréger les sources de plusieurs providers (BNF, archives nationales,...)
    - standardisation des fichiers
    - récupération des métadonnées
    - Unformisation du format des métadonnées
    - hébergement des fichiers si nécessaire (*hébergement de tout ? Me semble trop volumineux et pose problème de la maj des infos chez le provider*)

- Brancher les outils existant sur le catalogue (*automatisation de ces outils ? ex: récupération auto de la source dans le catalogue, exécution de l'outil puis enregistrement dans la catalogue*)

### Second besoin
- Ajouter nos métadonnées
- Maj auto des métadonnées dans le catalogue depuis la source (pas besoin si on héberge pas les documents déjà présents en ligne)
- standardisation des formats d'image (IIIF)
    - conversion ? (mise en cache si nécessaire)
    - "traduction" des requêtes ? (ex: requête IIIF en Zoomify)
- Possibilité d'ajouter des providers
- Possibilité de créer des corpus depuis le catalogue
- Possibilité d'extraire le géoréférencement s'il existe déjà chez le provider
- mise en place d'un serveur IIIF ?
- Gestion des utilisateurs idéalement
- extraction automatique des infos (carte, plan, annuaire, ...)
