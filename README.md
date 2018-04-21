# How to build images? (Ubuntu)

## Create image from jenkins-master/Dockerfile
sudo docker build --rm=true --no-cache -t cnadalm-jenkins:1.0 jenkins-master/.

## Create image from postgresql/Dockerfile 
sudo docker build --rm=true --no-cache --build-arg DB_NAME=microdb --build-arg DB_USER=micro --build-arg DB_PASS=changeme -t micro/postgres:1.0 postgresql/.

## Create image from wildfly/Dockerfile
sudo docker build --rm=true --no-cache --build-arg DB_HOST=database --build-arg DB_PASS=newpwd -t cnadalm-wildfly:1.0 wildfly/.

## Create image from payara/Dockerfile
sudo docker build --rm=true --no-cache -t cnadalm-payara:1.0 payara/.

## List docker images
sudo docker images
