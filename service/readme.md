# An exercise project 

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
