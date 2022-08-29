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

list of subdomains for certbot :
catalog.geohistoricaldata.org,traefik.geohistoricaldata.org,iiif.geohistoricaldata.org,ontop.geohistoricaldata.org,pgadmin.geohistoricaldata.org,database.geohistoricaldata.org

Certbot used for certificate generation with this command (needs port 80 open, so with traefik down):

```bash
sudo certbot certonly --standalone -d catalog.geohistoricaldata.org,traefik.geohistoricaldata.org,iiif.geohistoricaldata.org,ontop.geohistoricaldata.org,pgadmin.geohistoricaldata.org,database.geohistoricaldata.org
```
