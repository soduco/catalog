# Mettre à jour les certificats ssl

TODO : traefik peut gérer automatiquement les certificats ssl, voir comment mettre cela en place.

## Mise à jour des certificats

Pour mettre à jour les scripts, il est nécessaire d'arrêter le docker traefik.

```bash
docker compose traefik stop
```

Vous pouvez ensuite exécuter le script qui se chargera de mettre à jours les clefs ssl présentes dans la liste `DOMAIN_NAMES`.

Le script pour tester le renouvellement des certificats (dry-run) est présent ici : catalog/scripts/renew_ssl_certificates_test.sh
Le script pour renouveller les certificats est ici : catalog/scripts/renew_ssl_certificates.sh

Le script de renouvellement se charge de déplacer les anciennes clefs ssl depuis /config/traefik vers catalog/config/traefik/ssl_old.
Il copie aussi les clefs nouvellement générées depuis le répertoire de letsencrypt (/etc/letsencrypt/live/catalog.geohistoricaldata.org-0001/) vers catalog/config/traefik.
Ceci n'est PAS une bonne pratique, letsencrypt conseille de laisser les clefs dans leur dossier d'origine.
TO DO : mettre en place un symlink (possible avec des fichiers utilisés par docker ?) ou modifier le chemin d'accès donné dans le docker compose)