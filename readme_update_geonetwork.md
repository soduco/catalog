# Mettre à jour Geonetwork

## Etapes à suivre

(testé pour passer à la version 4.2.5)

- faire une backup (scripts à mettre à jour, sensible à l'emplacement d'exécution pour le moment + créer une doc)
  - database : backup_db.sh dans /backup
  - docker volumes : backup_volume.sh dans /backup
  - fichiers de config : dump_config.sh dans /scripts (présence du fichier contenant le password pour crypter l'accès à la base de donnée)
- suppression du container geonetwork (via portainer.geohistoricaldata.org, password à demander à Melvin ou via cli (docker stop, docker rm...))
- suppression du volume geonetwork-jetty (pour pouvoir recréer le fichier jetty.start)
- création du nouveau container (docker compose up -d)
