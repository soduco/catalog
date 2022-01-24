Rework of the precedent proxy for more flexibility

:warning: Dataverse not included in proxy and scripts (didn't find how to redirect it with Nginx)

Must be launch separately from others, while proxy is down (to free port 80)

And Dataverse must be down for reverse-proxy to be launched

## Nginx
reverse-proxy set for :
- Portainer (port 9000)
- CKAN (port 5000)
- Geonetwork (port 8080)

## Portainer
working on http://134.158.75.87/portainer/

admin account : admin / catalogtest

## CKAN
CKAN v.2.9.4 2021-09-22

.git folder deleted to not create subdirectory (it was simpler that way)

working on http://134.158.75.87

admin account : johndoe / catalogtest

## Geonetwork
Geonetwork v4.0.5

working on http://134.158.75.87/geonetwork/

admin account : admin / admin

## Dataverse 
Dataverse v5.8 from docker hub image

.git folder deleted to not create subdirectory (it was simpler that way)

Not included in proxy and scripts (didn't find how to redirect it with Nginx)

Must be launch separately from others, while they are down (to free port 80)

working on http://134.158.75.87

admin account : dataverseAdmin / catalogtest1
