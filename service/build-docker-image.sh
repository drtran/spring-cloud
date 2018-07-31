#!/bin/sh
# $1: http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka

./mvnw -Dservice.instance.name=test1 -Deureka.server=$1 clean package
docker build --build-arg JAR_FILE=target/service-0.0.1.jar -t service:latest .
docker tag service:latest drtran/service:latest
docker push drtran/service:latest