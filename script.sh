sudo git clone https://github.com/adrianrevilla009/eoloPlannerCommunicationsDockerized.git /home/eoloPlannerCommunicationsDockerized
cd /home/eoloPlannerCommunicationsDockerized

# Server image jib quarkus
cd server
mvn quarkus:add-extension -Dextensions='container-image-jib'
mvn install
cd ..
# Weather service image graal native quarkus
cd weatherservice
mvn quarkus:add-extension -Dextensions='container-image-docker'
mvn install -Dnative
cd ..

# Planner image multistage dockerfile spring
cd planner
docker build -f multistage.Dockerfile -t adrian2606/eoloplannercommunications-planner .
docker push adrian2606/eoloplannercommunications-planner
cd ..

# Topo service image buildpacks spring
cd toposervice
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=adrian2606/eoloplannercomunnications-toposervice:version1
docker push adrian2606/eoloplannercomunnications-toposervice:version1