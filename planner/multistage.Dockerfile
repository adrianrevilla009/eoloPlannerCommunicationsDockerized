# Imagen base para el contenedor de compilación
# Necesitamos tener los archivos protobuf obtenidos de /target de la compilacion
FROM maven:3.9.0-eclipse-temurin-17 as builder
WORKDIR /eoloPlannerCommunications/planner
COPY /src /eoloPlannerCommunications/planner/src
COPY pom.xml /eoloPlannerCommunications/planner
COPY wait-for-it.sh /eoloPlannerCommunications/planner
RUN mvn -B clean package -DskipTests


# Imagen base para el contenedor de la aplicación
# Necesitamos ejecutar un comando wait-for-it para que la ejecución del jar se haga solo cuando los servicios esten corriendo
FROM eclipse-temurin:17-jdk
WORKDIR /usr/src/app/

RUN curl -LJO https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x /usr/src/app/wait-for-it.sh

COPY --from=builder /eoloPlannerCommunications/planner/target/*.jar /usr/src/app/
EXPOSE 8080
CMD [ "java", "-jar", "planner-0.0.1-SNAPSHOT.jar" ]
