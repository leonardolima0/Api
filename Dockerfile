# Build da aplicação
FROM eclipse-temurin:21-jdk AS build

WORKDIR /app

# Copia arquivos do Gradle primeiro para aproveitar cache
COPY api/gradlew .
COPY api/gradle gradle
COPY api/build.gradle.kts .
COPY api/settings.gradle.kts .

RUN chmod +x gradlew

# Baixa dependências
RUN ./gradlew dependencies --no-daemon || true

# Copia o restante do projeto
COPY api .

# Gera o JAR
RUN ./gradlew bootJar --no-daemon

# Imagem final
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]