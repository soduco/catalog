#!/bin/bash

# curl -L catalog.geohistoricaldata.org/geonetwork/srv/api/records/697871b7-f663-4e0e-8785-c48ecfe05515/tags


export CATALOG=https://catalog.geohistoricaldata.org/geonetwork
export CATALOGUSER=admin
export CATALOGPASS=admin
export PROCESS=migrate-201904

# auth block baginning
rm -f /tmp/cookie;
curl -s -c /tmp/cookie -o /dev/null \
  -X GET \
  -H "Accept: application/json" \
  "$CATALOG/srv/api/me";
export TOKEN=`grep XSRF-TOKEN /tmp/cookie | cut -f 7`;
curl -LX GET \
    -H  "accept: application/json" \
    -H  "X-XSRF-TOKEN: $TOKEN" --user $CATALOGUSER:$CATALOGPASS -b /tmp/cookie \
  "$CATALOG/srv/api/me";
# end auth block

curl -LX GET \
    -H  "accept: application/json" \
    -H  "X-XSRF-TOKEN: $TOKEN" --user $CATALOGUSER:$CATALOGPASS -b /tmp/cookie \
    "catalog.geohistoricaldata.org/geonetwork/srv/api/records/abc9604f-6e12-4691-b862-7e636f837ce4"
