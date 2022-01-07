###### tags: `11/21`
# W47 test geonetwork

[github](https://github.com/geonetwork)
[dockerhub](https://hub.docker.com/u/geonetwork)

docker-compose used : https://github.com/geonetwork/geonetwork-microservices/blob/main/docker-compose.yml

serveur tourne en local, bdd à remplir pour tests

### geonetwork documentation:

[link here](https://geonetwork-opensource.org/docs.html)

### User guide
#### Maps and dataset visualisation
- GeoNetwork can use an external map viewer
- GeoNetwork uses OWSContext to store, share and load maps

#### Describing information
Templates are metadata records that you can use for describing new resources.
You can create, import, edit, delete them.
A few standards support multilingual metadata.

#### Associating resources
You can associate a record with documents using a URL or you can upload attachments to a metadata file store (with 2 folder, one public and one private.
You can add an overview
Possibility to link URL
describing attributes table in a feature catalog
DataCite API is used to create DOI (Digital Object Identifier) [comment créer un DOI](https://sist19.sciencesconf.org/data/pages/SIST19_A_BATTAIS.pdf)

#### Classify information
Tag with categories or keywords

#### Publishing and Managing privileges
You can manage privileges
You can assign templates to limited groups, so only these groups can use the template in their work process
you can transfer metadata ownership from one user to another

#### Analysing data
The administration panel provides statistics on search and on records in the catalog.
All datasets described in metadata records and accessible through a download services (ie WFS) can be analyzed to improve search and data visualization. The catalog collect WFS features and index them. (needs Elasticsearch)

#### Workflow
validation tool in metadata editor. Can be configured.
The metadata editor can be configured to analyse metadata and make suggestions to improve it. [example](https://github.com/metadata101/iso19139.mcp/blob/master/src/main/plugin/iso19139.mcp/suggest.xsl)
possible to create a new process
existence of a Record life cycle to keep record state (draft, submitted, approved...)
Workflow can be enabled for the full catalogue, certain groups or on an individual record level
email alert on status change

#### Updating a set of records (Batch editing)
User and admin can batch edit
you can add batch process

#### Harvesting
Harvesting is the process of ingesting metadata from remote sources and storing it locally in the catalog for fast searching. It is a scheduled process, so local copy and remote metadata are kept aligned.

harvesters list:
- Geonetwork Harvester
- CSW services
- OGC Services
- Local File System harvester
- WebDAV (Distributed Authoring and Versioning) / WAF (web accessible folder)
- OAI-PMH harvester
- ArcSDE harvester
- GeoPortal REST harvester
- THREDDS Catalog Harvester
- OGC WFS GetFeature Harvester
- Z3950 Harvester

#### Exporting records
ZIP or CSV

### Admin guide
Configuring the catalog
Managing users and groups
Managing classification system
Managing metadata & template

### Maintainer guide
Setting up search/content statistics
Setup ElasticSearch
Setup Kibana
Setup GeoNetwork
Production use:
- Database
- Java container
- Data folder
- Memory
- Scaling
- GeoNetwork and Docker
- Web Proxy
- WEB

### API guide
#### GeoNetwork API
swagger docu (http://localhost:8080/geonetwork/doc/api/)

#### CSW
The CSW end point exposes the metadata records in your catalog in XML format using the OGC CSW protocol (version 2.0.2).

#### OpenSearch
opensearch entry point at http://localhost:8080/geonetwork/srv/eng/portal.opensearch

#### INSPIRE ATOM
Only records based on the ISO19139 standard can be used with Atom. ISO19115-3 records are not.
A separate OpenSearch endpoint is created for every Atom-based download service

#### Q Search
allows you to query the catalog programmatically http://localhost:8080/geonetwork/srv/eng/q

result with query example : {"error": { "message": "Use ES search instead." , "class": "UnsupportedOperationException" , "request": {} } } 

#### RDF DCAT end point
The RDF DCAT end point provides a way of getting information about the catalog, the datasets and services, and links to distributed resources in a machine-readable format

#### Open Archive Initiative (OAI)
empty page in the manual
#### Z39-50
also empty

### Customizing guide
info on how to customize aspects of geonetwork:

    Search application
        Create your own view
        Change default view configuration
        Create your own view
        Enrich your custom view
        Wro4j resource management
    Customizing metadata views
    Customizing editor
        Defining field type
        Grouping element from the standards
        Defining multilingual fields
        Configuring views
        Defining a view
        Defining a tab
        Adding a section to a tab
        Adding a field
        Adding a template based field
        Adding documentation or help
        Adding a button
        Adding a group
    Theming
    Configuring search fields
        Add a search field
        Boosting documents and fields
        Boosting search results
    Configuring faceted search
        Facet principle
        Facet response when searching
        Configuration
    Advanced configuration
        User session timeout configuration
    Adding static pages
        Examples of API usage
    Implementing schema plugins
        Metadata schemas and profiles
        Implementing a metadata schema or profile
        Schema Plugins
    Characterset
    Miscellaneous
        Invalid CSRF Token
        Using the H2 database

