# catalog

endpoints :

- [traefik](http://traefik.geohistoricaldata.org)
- [geonetwork](http://catalog.geohistoricaldata.org)
- [pgadmin4](http://pgadmin.geohistoricaldata.org)
- [cantaloupe](http://iiif.geohistoricaldata.org)
- [ontop](http://ontop.geohistoricaldata.org)
- database address: catalog.geohistoricaldata.org:8080
- geonetwork-ui (disabled for now)

TLS now enabled.

Memo for futur certificate generation :
Certbot used for certificate generation with "catalog.geohistoricaldata.org" domain name and this command :

```bash
sudo certbot certonly --webroot
```

list of subdomains for certbot :
catalog.geohistoricaldata.org traefik.geohistoricaldata.org iiif.geohistoricaldata.org ontop.geohistoricaldata.org pgadmin.geohistoricaldata.org database.geohistoricaldata.org
