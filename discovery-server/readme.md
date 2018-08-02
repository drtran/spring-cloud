# An exercise project 

## Creating and running a sprint framework netflix eureka server

Date: 21 July 2018.

- I leave the default spring boot version 2.0.3 at the time
- I created a spring boot project from [spring initializr](https://start.spring.io/) with eureka server, devtools and actuator.
- I named the project discovery-server
- I downloaded the project and then export to my workspace running Spring STS 3.9.5
- Added @EnableEurekaServer annotation at the beginning of the DiscoverServerApplication.java. I realized that I chose Eureka Discovery as opposed to Eureka Server option in the Spring Initializr website. I searched and added the latest dependency from Maven to fix this problem.
- I added the following to the application.properties file:

```
spring.application.name=discovery-server
eureka.client.register-with-eureka=false
eureka.client.fetch-registry=false
server.port=8761
```

- I then ran the springboot application.

## service discovery

- a service can register and deregister
- a client (a service) can find services
- health check for a service
- remove unhealthy service

## typical client <--> service <--> service-discovery relationship

1. service registers with service discovery server
2. client looks up a service location
3. discovery server returns a location of the service
4. client requests a service from the service
5. service responses to the client

## Docker Imange Build

The following steps build the discovery-server executable, build a docker image, test the image, label it and then push it up to the docker hub.

1. run `./mvnw clean package`
2. run `sudo docker build --build-arg JAR_FILE=target/discovery-server-0.0.1.jar -t discovery-server:latest .`
3. run `sudo docker run -e PORT_NO=8761 -e PROFILE=prod -it -p 8761:8761 discovery-server:latest`
4. run `sudo docker tag discovery-server:latest drtran/discovery-server:latest`
5. run `sudo docker push drtran/discovery-server:latest`

### Alternatively

You can also use this command to build the docker image for this discovery service:

```
./mvnw -Ddocker.image.prefix=drtran clean install dockerfile:build
./mvnw -Ddocker.image.prefix=drtran clean install dockerfile:push
```

## Openshift

I installed and ran Openshift Origin. You can visit this website for more information on how to stand one up: [https://www.openshift.org] 

### Openshift status

Check the status of your openshift instance:

``` 
oc status 
```

If it is not running, you can start it using this command: 

```
./oc cluster up --public-hostname=ip-address
```

### Import Docker Image

Run this command:

```
./oc_import_image.sh
```

### Create Instance

Run this command:

```
./oc_create_app_and_expose_svc.sh
```
Note the printed hostname that you can use to visit the Spring Eureka server.

### Delete the instance

Run this command:

```
./oc_delete_app_and_resources.sh
```

## Swagger UI

Use this two links to examine the REST API:

```
http://localhost:8761/v2/api-docs
http://localhost:8761/swagger-ui.html
```














