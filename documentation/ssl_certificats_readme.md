# Mettre à jour les certificats ssl

TODO : traefik peut gérer automatiquement les certificats ssl, voir comment mettre cela en place.

## Mise  d'update

Script présent ici : catalog/scripts/renew_ssl_certificates.sh

Pour mettre à jour les scripts, il est nécessaire d'arrêter le docker traefik.

```bash
docker compose traefik stop
```

Vous pouvez ensuite exécuter le script qui se chargera de mettre à jours les clefs ssl présentes dans la liste `DOMAIN_NAMES`.
