FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
RUN apt-get update && \
    apt-get install -y git
RUN git clone https://github.com/Bhargavi-lakamsani/sparkjava-war-example.git .
RUN mvn clean install

FROM tomcat:8.0-alpine
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
