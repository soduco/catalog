###### tags: `12/21`
# Nakala

TL;DR : bon entrepôt pour les données, pas pour les métadonnées. Possibilité d'utiliser Nakala pour stocker les données et de brancher notre solution pour les métadonnées par dessus

https://documentation.huma-num.fr/nakala/

### Présentation
Il est intéressant d’utiliser Nakala dans les cas où l’on souhaite diffuser en ligne un ensemble de données et métadonnées descriptives ayant une cohérence scientifique (corpus, collections, reportages, etc.).

#### Plusieurs solutions s’offrent à vous pour exploiter les données qui sont dans Nakala :
- Vous utilisez le module de publication Nakala_Press proposé par Huma-Num ;
- Vous utilisez des outils existants comme un moteur de blogs, un CMS, etc. ;
- Vous avez les compétences techniques et vous développez votre site au-dessus des APIs de Nakala.

#### Huma-Num prend en charge :
- Une copie sécurisée de vos données et de vos métadonnées sur son infrastructure ;
- L’attribution d’un identifiant stable pour permettre leur citation (Handle avant 2020 et DOI) ;
- La mise à disposition de vos métadonnées de manière interopérable en se basant sur les technologies du Web de données ;
- L’exposition des métadonnées des données par le protocole documentaire OAI-PMH ;
- La pérennité de l’interface web publique générée grâce au module de publication Nakala_Press.

#### En résumé, que fait Nakala ?
- Il vous décharge de la gestion de vos données ;
- Il vous permet de les visualiser ;
- Il vous permet de les regrouper et les présenter dans des collections homogènes ;
- Il prend en charge le partage interopérable des données et des métadonnées et leur citabilité ;
- Il dissocie le stockage de données de leur présentation ;
- Il prépare le référencement des données dans ISIDORE et facilite le processus d’archivage à long terme ;
- Il permet l’éditorialisation de vos données dans un site web personnalisé de type https://monprojet.nakala.fr grâce au module de publication Nakala_Press.

#### Que ne fait pas Nakala ?
- Il n’enrichit pas les données

#### Tester Nakala
- L’interface de test : test.nakala.fr
- Les API de test : apitest.nakala.fr

### Données
#### Tableau de bord
- voir les métriques concernant les données
- voir les données déposées ou partagées
- voir les collections
- Gestion des groupes d'utilisateurs
- gestion des sites Nakala_Press

#### Collections
Regroupe un ensemble de données cohérentes
Une donnée peut appartenir à plusieurs collections
Toute collection publique est présent dans l'entrepôt OAI-PMH de Nakala (peut être indexé, via une demande, par le moteur ISIDORE)

#### Données
Un ou plusieurs fichiers et ses métadonnées
Dépot via dashboard ou API
dépot par lot possible via l'API
Donnée **déposée** puis **publiée**
- Déposée: visibles aux users ayant un droit d'accès et peut être supprimée. Ne peux pas appartenir à une collection publique
- Publiée: création d'un DOI chez datacite. Possibilité de placer les fichiers sous embargo pour rendre accessible seulement les métadonnées. Impossible de supprimer une donnée publiée (sauf demande à Huma-Num et DOI de la donnée sera conservé)

#### Suppression des données et archivage

Lorsque les fichiers d’une donnée publiée sont modifiés, une nouvelle version de la donnée est générée et toutes les anciennes versions restent accessibles. La modification uniquement des métadonnées n’entraine pas la création d’une nouvelle version.

Les données déposées dans Nakala n’entrent pas dans un processus d’archivage à long terme (demande à effectuer).

#### Métadonnées
[Dublin-Core](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/) + 5 métadonnées propre à Nakala (obligatoires pour dépôt, peuvent être converties en DublinCore)
types de données dispos : carte, dataset,...

#### Bla-Bla

indexation
rôles, droits et accessibilité
pérenitté des données
