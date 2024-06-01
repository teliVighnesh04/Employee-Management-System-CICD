# Stage 1: Build the application
FROM maven:3.8.3-openjdk-17 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src
COPY wait-for-it.sh .

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Adding wait 
RUN chmod +x wait-for-it.sh

# Expose the application port (optional, adjust according to your app)
EXPOSE 8081

# Set the entry point
ENTRYPOINT ["wait-for-it.sh", "mysql:3306", "--timeout=60", "--", "sh", "-c", "java", "-jar", "app.jar"]

