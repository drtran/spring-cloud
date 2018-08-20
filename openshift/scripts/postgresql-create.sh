#!/bin/sh
#

echo "Run as:"
echo "./postgresql_create.sh project-name user-name password database-name"
echo "ex: ./postgresql_create.sh sonar-service sonar sonar sonardb"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

if [ -z "$2" ]
  then echo "ERROR: No USER provided!"; exit
fi

if [ -z "$3" ]
  then echo "ERROR: No PASSWORD provided!"; exit
fi

if [ -z "$4" ]
  then echo "ERROR: No DATABASE name provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
echo on

oc project $1

oc new-app \
	-f ../db-templates/postgresql-persistent-template.json \
	-p VOLUME_CAPACITY=1Gi \
	-p POSTGRESQL_USER=$2 \
	-p POSTGRESQL_PASSWORD=$3 \
	-p POSTGRESQL_DATABASE=$4

oc expose --port=5432 svc postgresql

echo "reminder: use oc logs pod pod-name to monitor db log"
	