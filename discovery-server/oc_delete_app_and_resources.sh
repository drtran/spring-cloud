#!/bin/sh

echo "Login as developer\n"

oc login -u developer -p developer
oc delete route discovery-server
oc delete svc discovery-server
oc delete dc discovery-server

echo "Done deleting application and related resources."
