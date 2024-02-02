# Geoserver Cloud in a nutshell

# Description

The chart deploys GSCloud with enabled PGConfig capabilities, resulting in the storage of the Geoserver Catalog in a PostgreSQL database. This necessitates a dependency on the bitnami/postgres Helm chart.

Additionally, GSCloud relies on RabbitMQ as the event bus handler to facilitate communication among various GSCloud components and services. The chart specifically enables WMS, WFS, WebUI, and Rest services, incorporating the Gateway to establish a unified entry point for these services.

Given that PostgreSQL requires a persistent location for catalog definition storage, the associated bitnami chart generates a Persistent Volume Claim (PVC) that persists even after uninstalling the chart. This approach ensures continuity across different executions and deployments. If there is a need to cleanse the GSCloud catalog, including layers configurations, removing the corresponding PVC (named: data-gs-cloud-pgconfig-postgresql-0) achieves this objective. Refer to the how-tos section for guidance.

Furthermore, for the creation of distinct datastores linking to databases, shapefiles, TIFFs, or other resources, it becomes imperative to establish a mechanism for mapping these resources within the context of the PODs. This may involve enabling network policies or mapping Persistent Volumes, such as granting access to an AWS bucket, a PostgreSQL database, or simply an NFS folder.

# Requirements

You need a Kubernetes cluster !
You need kubectl !
You need helm !

Check how to do that [here](https://github.com/camptocamp/helm-geoserver-cloud/blob/master/examples/README.md)

# How-To

Note: how-tos are based on local execution using a K3s cluster under the default namespace.


## Download helm dependencies (optional)

No need to do it really, since charts/ folder is included in the repository (just to make it easier for those that want to get a zip file with everything inside)

```bash
helm dependency update
```

## Deploy chart in your cluster

```bash
helm upgrade --install gs-cloud-pgconfig .
```

## Check your deploy

```bash
kubectl get po
```

Then you will get something like this:

```bash
NAME                                             READY   STATUS    RESTARTS      AGE
gs-cloud-pgconfig-gsc-gateway-7c4745ddf7-8slvw   1/1     Running   0             64s
gs-cloud-pgconfig-postgresql-0                   1/1     Running   0             64s
gs-cloud-pgconfig-gsc-wfs-6c8c7fdd5-r8kwb        1/1     Running   0             64s
gs-cloud-pgconfig-gsc-wms-7d5c55d9dc-xq2xt       1/1     Running   0             64s
gs-cloud-pgconfig-gsc-webui-8b786697c-7tvth      1/1     Running   0             64s
gs-cloud-pgconfig-gsc-rest-776cc4d4ff-7q7w9      1/1     Running   1 (44s ago)   64s
gs-cloud-pgconfig-rabbitmq-0                     1/1     Running   0             64s
```

Note: your deploy will be ready once all the pods are in 1/1 in ready column and status = running

## Access the WebUI

```bash
kubectl port-forward svc/gs-cloud-pgconfig-gsc-gateway 9000:8080
```

Then open a browser and navegate to http://localhost:9000/geoserver/web/ , user: admin / pass: geoserver and you are in ! Enjoy it.


## Uninstall chart

```bash
helm uninstall gs-cloud-pgconfig
```

## Clean the catalog

```bash
kubectl delete pvc data-gs-cloud-pgconfig-postgresql-0
```

