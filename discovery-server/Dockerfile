FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

VOLUME /tmp

ARG JAR_FILE

COPY ${JAR_FILE} app.jar

ENTRYPOINT [ \
	"java","-Djava.security.egd=file:/dev/./urandom", \
	"-Dspring.profiles.active=${PROFILE}", \
	"-Dport=${PORT_NO}", \
	"-jar","/app.jar" \
]