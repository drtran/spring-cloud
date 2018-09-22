#!/bin/sh
echo "Run this command like this:\n"
echo "./del-app.sh discovery-server\n"

if [ -z "$1" ]
  then echo "ERROR: No app name provided!"; exit
fi

oc delete route $1
oc delete svc $1
oc delete dc $1

echo "Done deleting application and related resources for $1."
