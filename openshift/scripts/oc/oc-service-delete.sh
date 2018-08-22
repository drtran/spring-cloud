#!/bin/sh

echo "Run this command like this:\n"
echo "./service_delete.sh project service-name"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

if [ -z "$2" ]
  then echo "ERROR: No service name provided!"; exit
fi


echo "Login as developer\n"

oc login -u developer -p developer
oc project $1

oc delete route $2
oc delete svc $2
oc delete dc $2
oc delete is $2

echo "Done deleting $2 and related resources."

	