package com.drkiettran.service;

import java.lang.management.ManagementFactory;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@EnableDiscoveryClient
@SpringBootApplication
@RestController // not recommended - use for demo purpose only
public class ServiceApplication {

	// Passing in as environment variable (SERVICE_INSTANCE_NAME) [ubuntu]
	@Value("${service.instance.name}")
	private String instance;

	public static void main(String[] args) {
		SpringApplication.run(ServiceApplication.class, args);
	}

	@RequestMapping("/")
	public String message() {
		return "Hello from instance " + instance + " process id " + ManagementFactory.getRuntimeMXBean().getName()
				+ "\n";
	}
}
