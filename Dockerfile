# Step 1: Use an official Maven image with Java 17 to build the project
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Step 2: Use a lightweight Java runtime image to run the video engine
FROM openjdk:17-jdk-slim
WORKDIR /app

# Install FFmpeg directly into the cloud runtime environment
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

# Copy the compiled JAR file from Step 1
COPY --from=build /app/target/cloud-engine-1.0-SNAPSHOT.jar app.jar

# Command to execute your master Java engine file
CMD ["java", "-cp", "app.jar", "com.videogen.VideoGeneratorEngine"]
