#!/bin/sh
# $1: http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka
 
oc login -u system:admin
oc delete drtran/service
oc import-image drtran/service --from drtran/service --insecure --confirm=true --all=true
oc adm policy add-scc-to-user anyuid -z default
oc login -u developer -p developer
oc new-app --name=my-service -e PORT_NO=1111 -e PROFILE=default -e EUREKA_SERVER=$1 -e INSTANCE_NAME=my-service-instance drtran/service

