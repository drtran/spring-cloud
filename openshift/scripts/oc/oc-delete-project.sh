#!/bin/sh

echo "Run this command like this:\n"
echo "./oc-delete-project.sh service-name"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

oc delete project $1

oc projects