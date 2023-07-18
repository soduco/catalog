# Mettre à jour Geonetwork

## Etapes à suivre

(testé pour passer à la version 4.2.5)

- faire une backup (scripts à mettre à jour, sensible à l'emplacement d'exécution pour le moment + créer une doc)
  - database : backup_db.sh dans /backup
  - docker volumes : backup_volume.sh dans /backup
  - fichiers de config : dump_config.sh dans /scripts (présence du fichier contenant le password pour crypter l'accès à la base de donnée)
- si possible, téléchargez la backup ailleurs. Voici un script basique pour faire cela depuis votre machine local.

```bash
#!/bin/bash

mkdir -p backup
scp -r debian@134.158.75.87:/home/debian/catalog/backup/* backup/.

echo "move backup to /soduco/backups/backup_{timestamp}"

mv backup ../backups/backup_`date +%m-%d-%Y"_"%H_%M_%S`
```

Il copie la sauvegarde dans un dossier *backup* avant de le renommer et déplacer dans un dossier *backups*. Il a été conçu pour s'exécuter suivant l'arborescence suivante:

```md
soduco/
 ├── scripts/
 │   └── script
 └── backups/
     └── backup_07-17-2023_11_28_22
```

- suppression du container geonetwork (via portainer.geohistoricaldata.org, identifiants à demander à Melvin ou via cli)

```bash
docker compose stop geonetwork && docker compose rm geonetwork
```

- suppression du volume geonetwork-jetty (pour pouvoir recréer le fichier jetty.start)

```bash
docker volume rm geonetwork_jetty
```

- création du nouveau container et volume

```bash
docker compose up -d
```
