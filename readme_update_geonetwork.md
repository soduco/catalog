# Mettre à jour Geonetwork

## Etapes à suivre

(testé pour passer à la version 4.2.5)

- faire une backup (scripts à mettre à jour, sensible à l'emplacement d'exécution pour le moment + créer une doc)
  - database : backup_db.sh dans /backup
  - docker volumes : backup_volume.sh dans /backup
  - fichiers de config : dump_config.sh dans /scripts

:warning: En cas de modification des volumes Geonetwork, faites attention de bien effectuer une backup du volume *geonetwork_jetty*. Il contient le fichier permettant de crypter la connexion entre geonetwork et sa base de donnée, qui sera regénéré avec une nouvelle version de Geonetwork. Il m'est arrivé une fois de ne plus pouvoir me connecter à la base de donnée suite à une migration. Je ne me souviens malheureusement plus des étapes ayant conduis à ce soucis, le fichier ne semble pas être modifié à chaque fois.

- si possible, téléchargez la backup ailleurs. Voici un script basique pour faire cela depuis votre machine local.

```bash
#!/bin/bash

mkdir -p backup
scp -r debian@134.158.75.87:/home/debian/catalog/backup/* backup/.

echo "move backup to /soduco/backups/backup_{timestamp}"

mv backup ../backups/backup_`date +%m-%d-%Y"_"%H_%M_%S`
```

Il copie la sauvegarde dans un dossier *backup*, y ajoute un timestamp et le déplace dans un dossier *backups*, pour simplifier la recherche en cas de sauvegardes multiples. Il a été conçu pour s'exécuter suivant l'arborescence suivante:

```md
soduco/
 ├── scripts/
 │   └── script
 └── backups/
     └── backup_07-17-2023_11_28_22
```

Pensez à supprimer les vieilles backup sur la vm, sinon le dossier deviendra vite lourd à télécharger.

- suppression du container geonetwork (via portainer.geohistoricaldata.org, identifiants à demander à Melvin ou via cli)

```bash
docker compose stop geonetwork && docker compose rm geonetwork
```

- suppression du volume geonetwork-jetty (pour pouvoir recréer le fichier jetty.start)

```bash
docker volume rm geonetwork_jetty
```

- création du nouveau container et ses volumes

```bash
docker compose up -d
```

- Si vous souhaitez observez les logs de votre nouveau container

```bash
docker compose logs -f --tail=1000 geonetwork
```
