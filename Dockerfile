# syntax=docker/dockerfile:1

########################################
# Estagio 1 - build do JAR com Maven
########################################
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copia o descritor do projeto e o codigo-fonte
COPY pom.xml .
COPY src ./src

# Compila e empacota, pulando os testes.
# O "--mount=type=cache" mantem o repositorio local do Maven (~/.m2) entre
# builds, deixando as execucoes seguintes muito mais rapidas (requer BuildKit,
# que e o padrao no Docker atual).
#
# Ambiente SEM BuildKit? Troque a linha do RUN por:
#   RUN mvn -B dependency:go-offline || true \
#    && mvn -B clean package -DskipTests
RUN --mount=type=cache,target=/root/.m2 mvn -B clean package -DskipTests

########################################
# Estagio 2 - imagem final de execucao
########################################
FROM eclipse-temurin:21-jre
WORKDIR /app

# Executa a aplicacao como usuario sem privilegios (boa pratica de seguranca -
# Aula 05, slides 25 e 49). O Dockerfile do enunciado nao faz isso; esta e uma
# melhoria justificada.
RUN groupadd --system spring && useradd --system --gid spring spring
USER spring:spring

# Copia apenas o artefato gerado no estagio anterior (imagem final sem Maven)
COPY --from=build /app/target/biblioteca-0.0.1-SNAPSHOT.jar app.jar

# Porta padrao do Spring Boot (application.properties: server.port=8080)
EXPOSE 8080

# MaxRAMPercentage faz a JVM respeitar o limite de memoria do container (cgroups)
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]
