#!/bin/sh

echo "Run this command like this:\n"
echo "./oc_create_app_and_expose_svc.sh config-server 8888 http://discovery-server-myproject.192.168.1.63.nip.io/eureka https://github.com/drtran/scf-config-repository \n"

if [ -z "$1" ]
  then echo "ERROR: No image name provided!"; exit
fi


if [ -z "$2" ]
  then echo "ERROR: No port provided!"; exit
fi

if [ -z "$3" ]
  then echo "ERROR: No eureka server provided!"; exit
fi

if [ -z "$4" ]
  then echo "ERROR: No git repository provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
echo on

oc new-app --name=$1 \
	-e PORT_NO=$2 \
	-e EUREKA_SERVER=$3 \
	-e GIT_REPO=$4 \
	-e PROFILE=prod \
	drtran/$1
oc expose --port $2 dc $1
oc expose svc $1
IP=`oc describe route $1 | grep "Requested Host"`

echo "\n\nUse this $IP"

echo "\nDone creating app and exposing the service\n"