#!/bin/sh
#

echo "Run as:"
echo "./sonar_create.sh project-name dburl user-name password"
echo "ex: ./sonar_create.sh sonar-service jdbc:postgresql://172.17.0.5:5432/sonardb sonar sonar"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

if [ -z "$2" ]
  then echo "ERROR: No dburl provided!"; exit
fi

if [ -z "$3" ]
  then echo "ERROR: No USER provided!"; exit
fi

if [ -z "$4" ]
  then echo "ERROR: No PASSWORD provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
echo on

oc project $1

oc new-app \
	--name=sonarqube \
	-e SONARQUBE_JDBC_URL=$2 \
	-e SONARQUBE_JDBC_USERNAME=$3 \
	-e SONARQUBE_JDBC_PASSWORD=$4 \
	sonarqube
	
oc expose svc sonarqube
