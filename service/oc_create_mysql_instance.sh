#!/bin/sh

echo "Run this command like this:\n"
echo "./oc_create_mysql_instance.sh \
mysqldb \
3306 \
user_name \
user_psw \
root_psw \
\n"

if [ -z "$1" ]
  then echo "ERROR: No name provided!"; exit
fi


if [ -z "$2" ]
  then echo "ERROR: No port provided!"; exit
fi

if [ -z "$3" ]
  then echo "ERROR: No user name provided!"; exit
fi

if [ -z "$4" ]
  then echo "ERROR: No user password provided!"; exit
fi

if [ -z "$5" ]
  then echo "ERROR: No root password provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
echo on
#oc new-app --name=mysqldb \
#	-e PORT_NO=3306 \
#	-e MYSQL_USER=mysql_user \
#	-e MYSQL_PASSWORD=password \
#	-e MYSQL_ROOT_PASSWORD=password \
#	registry.access.redhat.com/openshift3/mysql-55-rhel7
	
oc new-app --name=$1 \
	-e PORT_NO=$2 \
	-e MYSQL_USER=$3 \
	-e MYSQL_PASSWORD=$4 \
	-e MYSQL_ROOT_PASSWORD=$5 \
	registry.access.redhat.com/openshift3/mysql-55-rhel7
	
oc expose --port $2 dc $1
oc expose svc $1
IP=`oc describe route $1 | grep "Requested Host"`

echo "\n\nUse this $IP"

echo "\nDone creating $1 and exposing the service\n"