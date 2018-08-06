#!/bin/sh

echo "Run this command like this:\n"
echo "./oc_create_app_and_expose_svc.sh discovery-server 8761\n"

if [ -z "$1" ]
  then echo "ERROR: No image name provided!"; exit
fi


if [ -z "$2" ]
  then echo "ERROR: No port provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer

oc new-app \
	--name=$1 \
	-e PORT_NO=$2 \
	-e PROFILE=prod \
	drtran/$1

oc expose --port $2 dc $1
oc expose svc $1
IP=`oc describe route $1 | grep "Requested Host"`

echo "\n\nUse this $IP"

echo "\nDone creating app and exposing the service\n"