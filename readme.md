# Spring cloud project

With Docker & Openshift platforms

This repo contains projects that are based Dustin Schultz's older implementation using Spring Boot 1.5.x. These projects uses Spring Boot 2.0.3.

These projects are also developed with Docker and Openshift platforms in mind. Each project is self-contained; however, nearly all projects rely on the 'discovery-service' project.

Thus, make sure you get the `discovery-service` project is running before any attempt on other projects. You will have an easier time afterward.

## Platforms that I use for this effort

- Ubuntu 16.04
- Docker version 18.03.1-ce, build 9ee9f40
- Openshift Origin 3.9.0
- Openshift Client oc 3.7:

```
oc v3.9.0+191fece
kubernetes v1.9.1+a0ce1bc657
features: Basic-Auth GSSAPI Kerberos SPNEGO

Server https://192.168.1.63:8443
openshift v3.9.0+191fece
kubernetes v1.9.1+a0ce1bc657

```

- Java JDK 1.8
- Spring STS 3.9.5

## Discovery service project

In order to create, run and maintain a microservice efficiently and effectively, some type of service discovery is necessary. This project runs a service discovery server that allows microservices to register their services by names and their potential clients can discover them also by names.


## Configuration server project

This project runs a Spring Configuration Server that allows applications to externalize their configuration in order to deploy and maintain easier.



