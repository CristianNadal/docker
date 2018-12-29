# How to build images?

## Create image from jenkins-master/Dockerfile
sudo docker build --rm=true --no-cache -t cnadalm-jenkins:1.0 jenkins-master/.

## Create image from postgresql/Dockerfile 
### /!\ Remember to change DB_PASS
sudo docker build --rm=true --no-cache --build-arg DB_NAME=microdb --build-arg DB_USER=micro --build-arg DB_PASS=changeme -t micro/postgres:1.0 postgresql/.

## Create image from wildfly-postgres/Dockerfile
### /!\ Remember to change DB_PASS
sudo docker build --rm=true --no-cache --build-arg DB_HOST=database --build-arg DB_NAME=microdb --build-arg DB_USER=micro --build-arg DB_PASS=changeme -t cnadalm/wildfly-postgres:1.0 wildfly/.

## Create image from wildfly-h2/Dockerfile
### Defaul SSL enabled, H2 datasource added
sudo docker build --rm=true --no-cache --build-arg DS_NAME=anynameds --build-arg DB_NAME=anynamedb -t cnadalm/wildfly-h2:1.0 wildfly-h2/.

## Create image from payara-micro/Dockerfile
### /!\ Implemented directly on the docker-compose file

## Create image from payara-web/Dockerfile
### /!\ Remember to change DB_PASS
sudo docker build --rm=true --no-cache --build-arg DB_HOST=database --build-arg DB_NAME=microdb --build-arg DB_USER=micro --build-arg DB_PASS=changeme -t web/payara:1.0 payara-web/.

## Create image from payara-web-h2/Dockerfile
sudo docker build --rm=true --no-cache --build-arg DS_NAME=anynameds --build-arg DB_NAME=anynamedb -t cnadalm/payara-web-h2:1.0 payara-web-h2/.

## List docker images
sudo docker images
