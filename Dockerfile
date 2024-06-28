# Stage 1: Build stage
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app

# Install git using apt-get (for Debian-based images)
RUN apt-get update && \
    apt-get install -y git

# Clone your Git repository and build the application
RUN git clone https://github.com/Bhargavi-lakamsani/sparkjava-war-example.git .
RUN mvn clean install

# Stage 2: Final stage
FROM tomcat:8.0-alpine

# Copy the built WAR file from the build stage to Tomcat's webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/


