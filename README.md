# catalog

endpoints :

- [geonetwork](http://catalog.geohistoricaldata.org/geonetwork)
- [pgadmin4](http://catalog.geohistoricaldata.org/pgadmin)
- database address: catalog.geohistoricaldata.org:8080
- geonetwork-ui (disabled for now)

TLS now enabled.

Memo for futur certificate generation :
Certbot used for certificate generation with "catalog.geohistoricaldata.org" domain name and this command :

```bash
sudo certbot certonly --webroot
```
