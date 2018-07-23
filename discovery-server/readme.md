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

