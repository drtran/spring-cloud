#!/bin/sh

echo "Run this command like this:\n"
echo "./oc_delete_mysql_instance.sh mysqldb\n"

if [ -z "$1" ]
  then echo "ERROR: No app name provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
oc delete route $1
oc delete svc $1
oc delete dc $1
oc delete is $1

echo "Done deleting $1 and related resources."
