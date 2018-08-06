#!/bin/sh

if [ -z "$1" ]
  then echo "No container-name (i.e., discovery-server) provided!"; exit
fi

echo "Logging in as system:admin"

oc login -u system:admin
oc import-image drtran/$1 \
	--from drtran/$1 \
	--insecure \
	--confirm=true \
	--all=true \
	--loglevel=10
oc adm policy add-scc-to-user anyuid -z default

echo "Done importing image"