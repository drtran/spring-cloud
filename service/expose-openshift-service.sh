#!/bin/sh
# $1: pod id
 
oc expose --name=my-service --port 1111 pods $1
oc expose svc my-service
oc describe route my-service | grep "Requested Host"
