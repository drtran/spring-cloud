#!/bin/sh

echo "Logging in as system:admin"

oc login -u system:admin
oc import-image drtran/discovery-server --from drtran/discovery-image --insecure --confirm=true --all=true
oc adm policy add-scc-to-user anyuid -z default

echo "Done importing image"