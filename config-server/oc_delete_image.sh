#!/bin/sh
echo "Run this command like this:\n"
echo "./oc_app_and_resources.sh config-server\n"

if [ -z "$1" ]
  then echo "ERROR: No app name provided!"; exit
fi

echo "Logging in as system:admin"

oc login -u system:admin
oc delete is $1

echo "Done deleting the image $1"