#!/bin/sh
#

echo "Run as:"
echo "./activemq-create.sh project-name admin-id admin-psw"
echo "ex: ./activemq-create.sh activemq-service admin admin"

if [ -z "$1" ]
  then echo "ERROR: No project name provided!"; exit
fi

if [ -z "$2" ]
  then echo "ERROR: No USER provided!"; exit
fi

if [ -z "$3" ]
  then echo "ERROR: No PASSWORD provided!"; exit
fi

echo "Login as developer\n"

oc login -u developer -p developer
echo on

oc project $1

oc new-app \
	--name='activemq' \
	-e 'ACTIVEMQ_CONFIG_NAME=amqp-srv1' \
	-e 'ACTIVEMQ_CONFIG_DEFAULTACCOUNT=false' \
	-e 'ACTIVEMQ_ADMIN_LOGIN=$1' -e 'ACTIVEMQ_ADMIN_PASSWORD=$1' \
	-e 'ACTIVEMQ_USERS_myproducer=producerpassword' -e 'ACTIVEMQ_GROUPS_writes=myproducer' \
	-e 'ACTIVEMQ_USERS_myconsumer=consumerpassword' -e 'ACTIVEMQ_GROUPS_reads=myconsumer' \
	-e 'ACTIVEMQ_JMX_user1_role=readwrite' -e 'ACTIVEMQ_JMX_user1_password=jmx_password' \
	-e 'ACTIVEMQ_JMX_user2_role=read' -e 'ACTIVEMQ_JMX_user2_password=jmx2_password'
	-e 'ACTIVEMQ_CONFIG_TOPICS_topic1=mytopic1' -e 'ACTIVEMQ_CONFIG_TOPICS_topic2=mytopic2'  \
	-e 'ACTIVEMQ_CONFIG_QUEUES_queue1=myqueue1' -e 'ACTIVEMQ_CONFIG_QUEUES_queue2=myqueue2'  \
	-e 'ACTIVEMQ_CONFIG_MINMEMORY=1024' -e  'ACTIVEMQ_CONFIG_MAXMEMORY=4096' \
	-e 'ACTIVEMQ_CONFIG_SCHEDULERENABLED=true' \
	-v /data/activemq:/data \
	-v /var/log/activemq:/var/log/activemq \
	-p 8161:8161 \
	-p 61616:61616 \
	-p 61613:61613 \
	webcenter/activemq
	
oc expose svc sonarqube
