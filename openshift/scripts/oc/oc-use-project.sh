#!/bin/sh

echo "Run this command like this:\n"
echo "./oc-use-project.sh service-name"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

oc project $1

oc projects