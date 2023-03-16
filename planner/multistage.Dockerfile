# Imagen base para el contenedor de compilación
# Necesitamos tener los archivos protobuf obtenidos de /target de la compilacion
FROM maven:3.9.0-eclipse-temurin-17 as contenedor_compilacion
WORKDIR /eoloPlannerCommunications/planner
COPY /src /eoloPlannerCommunications/planner/src
COPY pom.xml /eoloPlannerCommunications/planner
COPY wait-for-it.sh /eoloPlannerCommunications/planner
RUN mvn -B clean package -DskipTests


# Imagen base para el contenedor de la aplicación
# Necesitamos ejecutar un comando wait-for-it para que la ejecución del jar se haga solo cuando los servicios esten corriendo
FROM eclipse-temurin:17-jdk
WORKDIR /usr/src/app/
COPY --from=contenedor_compilacion /eoloPlannerCommunications/planner/target/*.jar /usr/src/app/
RUN chmod +x /eoloPlannerCommunications/wait-for-it.sh
EXPOSE 8080
CMD [ "java", "-jar", "planner-0.0.1-SNAPSHOT.jar" ]
