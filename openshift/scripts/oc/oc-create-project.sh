#!/bin/sh

echo "Run this command like this:\n"
echo "./oc-create-project.sh service-name"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
oc new-project $1

oc projects