#!/bin/bash

# notes: 
# check https://github.com/camptocamp/helm-geoserver-cloud/tree/master/examples/pgconfig-wms-hpa  for a reference/guide
# ab command required
# remember to start the cluster and port-forward the gateway
# based on using layer ch.astra.nationalstrassenachsen from https://wms.geo.admin.ch/?REQUEST=GetCapabilities&SERVICE=WMS&VERSION=1.0.0&lang=en in a WMS cascade datastore

WMS_URL="http://localhost:9000/geoserver/wms?SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&FORMAT=image%2Fpng&TRANSPARENT=true&STYLES&LAYERS=test%3Ach.astra.nationalstrassenachsen&exceptions=application%2Fvnd.ogc.se_inimage&SRS=EPSG%3A2056&WIDTH=769&HEIGHT=359&BBOX=2628297.2396917907%2C1161127.5666655225%2C2745623.985655881%2C1215846.1146757442"

ab -Sdl -t 120 -c 64 "$WMS_URL"

