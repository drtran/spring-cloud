#!/bin/sh

echo "Run this command like this:\n"
echo "./oc-delete-project.sh service-name"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
oc delete project $1

oc projects