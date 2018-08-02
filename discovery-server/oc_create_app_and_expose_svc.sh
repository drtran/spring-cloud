#!/bin/sh

if [ -z "$1" ]
  then echo "No port provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
oc new-app --name=discovery-server -e PORT_NO=8761 -e PROFILE=prod drtran/discovery-server
oc expose --port $1 dc discovery-server
oc expose svc discovery-server
IP=`oc describe route discovery-server | grep "Requested Host"`

echo "\n\nUse this $IP"

echo "\nDone creating app and exposing the service\n"