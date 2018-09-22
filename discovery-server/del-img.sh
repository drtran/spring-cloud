#!/bin/sh
echo "Run this command like this:\n"
echo "./del-img.sh discovery-server\n"

if [ -z "$1" ]
  then echo "ERROR: No app name provided!"; exit
fi
oc delete is $1

echo "Done deleting the image $1"