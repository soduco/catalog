###### tags: `12/21`
# Zenodo

[user docu](https://help.zenodo.org/)
[dev docu](https://developers.zenodo.org/)
[github](https://github.com/zenodo/zenodo)
[github docu](https://zenodo.readthedocs.io/en/latest/)
[installation](https://github.com/zenodo/zenodo/blob/master/INSTALL.rst)

### Based on Invenio Framework
Invenio Framework gives you all the features you need to build a trusted digital repository.
https://github.com/inveniosoftware/invenio

### Architecture
#### Server management
monitoring infrastructure based on Flume, Elasticsearch, Kibana and Hadoop

#### Frontend servers
Python and the Flask web development framework

#### Data storage
One checksum is stored by Invenio, and used to detect changes to files made from outside of Invenio

#### Metadata storage
- Metadata and persistent identifiers in Zenodo are stored in a PostgreSQL instance
- 12-hourly backup cycle with one backup sent to tape storage once a week
- indexed in an Elasticsearch cluster
- stored in JSON format and structure described by versioned JSONSchemas
- All changes to metadata records on Zenodo are versioned

#### Others / Back-end
Zenodo relies on Redis for caching and RabbitMQ and python Celery for distributed background jobs.

### Docu

[DOI versionning](https://help.zenodo.org/#versioning)
