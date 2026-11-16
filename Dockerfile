# Étape 1 : Build avec Maven et JDK 17
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Étape 2 : Image finale légère avec JRE 17
FROM eclipse-temurin:17-jre
WORKDIR /app

# Création d'un utilisateur dédié sans privilèges root
RUN groupadd --system appgroup && useradd --system --gid appgroup appuser

# Copie du JAR depuis l'étape builder
COPY --from=builder /app/target/*.jar app.jar
RUN chown appuser:appgroup app.jar

# Bascule vers l'utilisateur non-root
USER appuser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]