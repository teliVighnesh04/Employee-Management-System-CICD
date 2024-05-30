# Stage 1: Build the application
FROM maven:3.8.3-openjdk-17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port (optional, adjust according to your app)
EXPOSE 8080

# Set the entry point
ENTRYPOINT ["java", "-jar", "app.jar"]

