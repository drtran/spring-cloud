FROM openjdk:8-jdk-alpine

VOLUME /tmp

ARG JAR_FILE

COPY ${JAR_FILE} app.jar

ENTRYPOINT [ \
	"java","-Djava.security.egd=file:/dev/./urandom", \
	"-Dspring.profiles.active=${PROFILE}", \
	"-Dport=${PORT_NO}", \
	"-Deureka.server=${EUREKA_SERVER}", \
	"-Dgit.repo=${GIT_REPO}", \
	"-jar","/app.jar" \
]