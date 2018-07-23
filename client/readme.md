# An exercise project 

## Creating and running a sprint boot as a client (JHipster calls it gateway)

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

```
spring.application.name=service
eureka.client.servcie-url.defaultZone=http://localhost:8761/eureka
```

- In the Spring Boot App of the Run/Configuration option, create two instance (instance 1 and instance 2). Override the properties service.port and service.instance.name to instance 1 and instance 2.

- Runs the two instances and note the service registry with the discovery service from the log file.


- 