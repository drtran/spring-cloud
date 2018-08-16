# A simple Spring Boot service

## Essential commands

To use this project effectively, consider using the following scripts:

### Run locally using Maven:

The run for this service requires properties setting through environment variables `SERVICE_INSTANCE_NAME` for `${service.instance.name}` inside the main code. This is one of several ways Spring allows properties to be defined for an application. Thus, we also need `PORT` and `EUREKA_SERVER` variables defined for this service to run

```
export PORT=8181

export EUREKA_SERVER=http://discovery-server-myproject.192.168.1.63.nip.io/eureka

export SERVICE_INSTANCE_NAME=myservice_1

./mvnw clean spring-boot:run
```
You can visit the following URLs:

```
http://192.168.1.63:8181
http://192.168.1.63:8181/v2/api-docs
http://192.168.1.63:8181/swagger-ui.html

```
### Build & publish a Docker image

#### Requirements:

- Must have a Docker engine running
- Must have an account with the Docker Hub (if not, sign up for one - it's free)

These commands builds a container

```
export EUREKA_SERVER=http://discovery-server-myproject.192.168.1.63.nip.io/eureka
./mvnw -Ddocker.image.prefix=drtran clean install dockerfile:build
./mvnw -Ddocker.image.prefix=drtran clean install dockerfile:push
```

### Run a Docker container

This runs a container image built with the above commands. The discovery-server must runs on the openshift. If you run the docker-server as a stand-alone via maven or docker `run` command, you need to modify the URL for the `EUREKA_SERVER` environment variable.

```
docker run -e PORT_NO=8181 -e PROFILE=prod -e EUREKA_SERVER=http://discovery-server-myproject.192.168.1.63.nip.io/eureka -e SERVICE_INSTANCE_NAME=myservice_2 -it -p 8181:8181 drtran/service:latest
```
You can visit the following URLs:

```
http://192.168.1.63:8181
http://192.168.1.63:8181/v2/api-docs
http://192.168.1.63:8181/swagger-ui.html

```
### Import a Docker image to Openshift

#### Requirements
- Must have Openshift (RHEL/origin/minishift) installed and running
- The following commands from the `service` project can be useful:

```
oc_import_image.sh
oc_create_app_and_expose_svc.sh
```

### Openshift status

Check the status of your Openshift instance:

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
./oc_import_image.sh service
```

### Create an openshift application

You can create an openshift application using 
Run this command:

```
./oc_create_app_and_expose_svc.sh config-server 8888 http://discovery-server-myproject.192.168.1.63.nip.io/eureka myservice_1
```

Note the printed hostname (url) that you can use to visit the Spring Eureka server.

Visit the website and verify that the Discovery Server is up and running.

### Delete openshift application instance

Run this command:

```
./oc_delete_app_and_resources.sh service
```

### delete docker image from openshift

Run this command to remove the image from openshift:

```
./oc_delete_image.sh service
```

You can visit the following URLs:

```
http://service-myproject.192.168.1.63.nip.io
http://service-myproject.192.168.1.63.nip.io/v2/api-docs
http://service-myproject.192.168.1.63.nip.io/swagger-ui.html

```
### create an openshift mysqldb

```
./oc_create_mysql_instance.sh
```
Grant permission to access the instance remotely:

```
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mysqldb TO 'mysql_user'@'%' IDENTIFIED BY 'password';

mysql -h 172.17.0.8 -u root -p
mysql -h 172.17.0.8 -u mysql_user -p
```

Currently, login into the mysql db instance using requested host name of mysqldb-myproject.192.168.1.63.nip.io does not work.


### delete an openshift mysqldb 

```
./oc_delete_mysql_instance.sh
```


---

## Creating and running a sprint boot as a service

- Visit [Spring Initializr](https://start.spring.io/). Choose Maven, Java, and Spring Boot 2.0.3
- Change Group to com.drkiettran & Artifact to service.
- Chose dependencies for: Eureka Discovery, DevTools, and Actuator.
- Generate the project and import as existing Maven project into STS.
- Include this to the pom.xml file for @RestController annotation:

```xml

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
```

- Modify ServiceApplication.java to include this:

```java

@EnableDiscoveryClient
@SpringBootApplication
@RestController // not recommended - use for demo purpose only

	@Value("${service.instance.name}")
	private String instance;

	public static void main(String[] args) {
		SpringApplication.run(ServiceApplication.class, args);
	}

	@RequestMapping("/")
	public String message() {
		return "Hello from " + instance;
	}
	
```

- Modify application.properties to include this:

```java

spring.application.name=service
eureka.client.servcie-url.defaultZone=http://localhost:8761/eureka
```

- In the Spring Boot App of the Run/Configuration option, create two instance (instance 1 and instance 2). Override the properties service.port and service.instance.name to instance 1 and instance 2.

- Runs the two instances and note the service registry with the discovery service from the log file.

## Maven run

Test build the service, run this command:

```powershell

./mvnw -Dservice.instance.name=test1 -Deureka.server=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka clean package
```
To run the service from a command line:

```
java -Dservice.instance.name="instance 1" -Dport=1111 -Deureka.server=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -jar target/service-0.0.1.jar
```

## Build a docker image

1. run `./mvnw -Dservice.instance.name=test1 -Deureka.server=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka clean package`
2. run `sudo docker build --build-arg JAR_FILE=target/service-0.0.1.jar -t service:latest .`
3. run `sudo docker run -e PORT_NO=1111 -e PROFILE=default -e EUREKA_SERVER=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -e INSTANCE_NAME=my-instance-name -p 1111:1111 service:latest`
4. run `sudo docker tag service:latest drtran/service:latest`
5. run `sudo docker push drtran/service:latest`

## Openshift Launch

Make sure your openshift runs (i.e. `sudo ./oc cluster up`

1. run `oc login -u system:admin`
2. run `oc import-image drtran/service --from drtran/service --insecure --confirm=true --all=true`
3. run `oc adm policy add-scc-to-user anyuid -z default`
4. run `oc login -u developer -p developer`
5. run `oc new-app --name=service -e PORT_NO=1111 -e PROFILE=default -e EUREKA_SERVER=http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka -e INSTANCE_NAME=my-service-instance drtran/service`
6. run `oc logs -f pods/service-x-xxxxx`
7. run `oc expose --name=my-service --port 1111 pods service-x-xxxxx`
8. run `oc expose svc my-service`
9. run `oc describe route my-service | grep "Requested Host"`


## Note

- Replace this `http://discovery-server-1-ktrt7-myproject.192.168.1.63.nip.io/eureka` with the instance that runs on your openshift server.
