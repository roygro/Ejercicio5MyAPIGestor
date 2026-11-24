# Multi-stage build for Spring Boot Backend (Java 21)
FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN mkdir -p /app/data
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8081
ENV PORT=8081
# Default cloud DB configuration (in-memory/file H2 with MySQL mode so it runs out-of-the-box on Render)
ENV SPRING_DATASOURCE_URL=jdbc:h2:file:/app/data/dbgestor;DB_CLOSE_DELAY=-1;MODE=MySQL;NON_KEYWORDS=USER
ENV SPRING_DATASOURCE_DRIVER=org.h2.Driver
ENV SPRING_DATASOURCE_USERNAME=sa
ENV SPRING_DATASOURCE_PASSWORD=
ENV SPRING_JPA_DIALECT=org.hibernate.dialect.H2Dialect
ENTRYPOINT ["java", "-jar", "app.jar"]
