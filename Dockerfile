# Stage 1: Build the application
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies (cached layer)
#COPY pom.xml .
#RUN mvn dependency:go-offline -B

# Copy the source code and build the project
#COPY src ./src
#RUN mvn clean package -DskipTests

# Stage 2: Run the application
#FROM eclipse-temurin:17-jre-alpine
#WORKDIR /app

# Copy the runner and the war file from the build stage
#COPY --from=build /app/target/dependency/webapp-runner.jar webapp-runner.jar
#COPY --from=build /app/target/*.war app.war

# Expose the port the app runs on
#EXPOSE 8080

# Use environment variable for Port to match Render/Cloud expectations
#CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "app.war"]