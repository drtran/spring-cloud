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
3. run `sudo docker run -it -p 8761:8761 discovery-server:latest`
4. run `sudo docker tag discovery-server:latest drtran/discovery-server:latest`
5. run `sudo docker push drtran/discovery-server:latest`

## Openshift Launch

Make sure your openshift runs (i.e. `sudo ./oc cluster up`

1. run `oc login -u system:admin`
2. run `oc import-image drtran/discovery-server --from drtran/discovery-image --insecure --confirm=true --all=true`
3. run `oc adm policy add-scc-to-user anyuid -z default`
4. run `oc login -u developer -p developer`
5. run `oc new-app drtran/discovery-server`
6. run `oc logs -f pods/discovery-server-x-xxxxx`
7. run `oc expose --port 8761 pods discovery-server-x-xxxxx`
8. run `oc expose svc discovery-server-x-xxxxx`
9. run `oc describe route discovery-server-x-xxxxx`
10. run `oc get all -o name` - my result looks like this:

```

deploymentconfigs/discovery-server
imagestreams/discovery-server
routes/discovery-server-1-8pfk4
pods/discovery-server-1-8pfk4
replicationcontrollers/discovery-server-1
services/discovery-server-1-8pfk4

```

## Swagger UI

Use this two links to examine the REST API:

```
http://localhost:8761/v2/api-docs
http://localhost:8761/swagger-ui.html
```














