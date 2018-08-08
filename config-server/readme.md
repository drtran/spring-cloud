# Spring Cloud Config

Spring Cloud Config is a software component that allow your applications and/or services to externalize their configuration in a distributed environment. The backend of the server uses git; thus, labeled version control is fully supported. This is extremely important in the area of fast delivery and deployment of microservices in an enterprise infrastructure.

## Essential commands

To use this project effectively, consider using the following scripts:

### Run locally using Maven:

```
./mvnw -Dport=8888 -Deureka.server=http://discovery-server-myproject.192.168.1.63.nip.io/eureka clean spring-boot:run
```

You can visit the following URLs: 

- `http://localhost:8888/config-client-app/default`
- `http://localhost:8888/config-client-app/prod`
- `http://localhost:8888/config-client-app.properties`

### Build & publish a Docker image

#### Requirements:

- Must have a Docker engine running
- Must have an account with the Docker Hub (if not, sign up for one - it's free)

These commands builds a container

```
./mvnw -Deureka.server=http://discovery-server-myproject.192.168.1.63.nip.io/eureka -Ddocker.image.prefix=drtran clean install dockerfile:build
./mvnw -Deureka.server=http://discovery-server-myproject.192.168.1.63.nip.io/eureka -Ddocker.image.prefix=drtran clean install dockerfile:push
```

### Run a Docker container

This runs a container image built with the above commands. The discovery-server must runs on the openshift. If you run the docker-server as a stand-alone via maven or docker `run` command, you need to modify the URL for the EUREKA_SERVER environment variable.

```
docker run -e PORT_NO=8888 -e PROFILE=prod -e EUREKA_SERVER=http://discovery-server-myproject.192.168.1.63.nip.io/eureka -e GIT_REPO=https://github.com/drtran/scf-config-repository -it -p 8888:8888 config-server:latest
```

### Import a Docker image to Openshift

#### Requirements
- Must have Openshift (RHEL/origin/minishift) installed and running
- The following commands from the `config-server` project can be useful:

```
oc_import_image.sh
oc_create_app_and_expose_svc.sh
```

### Openshift status

Check the status of your openshift instance:

``` 
oc status 
```

The output should be something like this:

```
In project My Project (myproject) on server https://192.168.1.63:8443

You have no services, deployment configs, or build configs.
Run 'oc new-app' to create an application.

```
I am using the default 'myproject' project. You can create a new one if needed. Please refer to the [openshift/origin website](http://www.openshift.org)

If the Openshift Origin is not running, you can start it using this command: 

```
./oc cluster up --public-hostname=ip-address
```

### Import Docker Image

To create an openshift application, you would need to import the Docker image. Use the following command to achieve that.

```
./oc_import_image.sh config-server
```

### Create an openshift application

You can create an openshift application using 
Run this command:

```
./oc_create_app_and_expose_svc.sh config-server 8888 http://discovery-server-myproject.192.168.1.63.nip.io/eureka https://github.com/drtran/scf-config-repository.git
```

Note the printed hostname (url) that you can use to visit the Spring Eureka server.

Visit the website and verify that the Discovery Server is up and running.

### Delete openshift application instance

Run this command:

```
./oc_delete_app_and_resources.sh config-server
```

### delete docker image from openshift

Run this command to remove the image from openshift:

```
./oc_delete_image.sh config-server
```

## SWAGGER UI

The URLs for the Swagger-UI:

```
http://config-server-myproject.192.168..1.63.nip.io/v2/api-docs

```
 
---
 

## Run with Openshift

Assuming that you were successfully deployed the discovery-service on openshift. You then can locate the service endpoint of the discovery server, then run your config server instance using that service endpoint as follows:

```
oc describe routers/discovery-server-x-xxxxx | grep "Requested Host"
./mvnw -Dport=8888 -Deureka.server=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -Dgit.repo=https://github.com/drtran/scf-config-repository.git spring-boot:run
```

## Docker Image Build

The following steps build the discovery-server executable, build a docker image, test the image, label it and then push it up to the docker hub. Note that if you build config-server with mvnw command, it will try to contact the discovery server. If you don't have the server running, you would get an exception and you can ignore it. However, you can pass in -Deureka.server=abc property for a working discovery, you can avoid that exception.

1. run `./mvnw clean package` or `./mvnw -Deureka.server=http://discovery-server-myproject.192.168.1.63.nip.io/eureka clean package`
2. run `sudo docker build --build-arg JAR_FILE=target/config-server-0.0.1.jar -t config-server:latest .`
3. run `sudo docker run -e PORT_NO=8888 -e PROFILE=default -e EUREKA_SERVER=http://discovery-server-myproject.192.168.1.63.nip.io/eureka -e GIT_REPO=https://github.com/drtran/scf-config-repository.git -p 8888:8888 config-server:latest`
4. run `sudo docker tag config-server:latest drtran/config-server:latest`
5. run `sudo docker push drtran/config-server:latest`

## Alternatively

You can also use this command to build the docker image for this discovery service:

```
./mvnw -Ddocker.image.prefix=drtran -Deureka.server=http://discovery-server-myproject.192.168.1.63.nip.io/eureka clean install dockerfile:build
./mvnw -Ddocker.image.prefix=drtran -Deureka.server=http://discovery-server-myproject.192.168.1.63.nip.io/eureka clean install dockerfile:push
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


## Getting configuration:

```

http://localhost:8888/config-client-app/default
http://localhost:8888/config-client-app/prod
http://localhost:8888/config-client-app.properties

```











