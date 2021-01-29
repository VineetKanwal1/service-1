# Build stage

FROM maven:3.5-jdk-8-alpine as build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

# Package stage

FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest

WORKDIR /app
COPY --from=build /home/app/target/service-1-0.0.1-SNAPSHOT.jar /app/app.jar

VOLUME /tmp

ENV JAVA_OPTS=""
EXPOSE 8080
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.io.tmpdir=/tmp -Djava.security.egd=file:/dev/./urandom -jar app.jar" ]
