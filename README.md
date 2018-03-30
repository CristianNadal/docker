# How to build images? (Ubuntu)

## Create image from jenkins-master/Dockerfile
sudo docker build --rm=true --no-cache -t cnadalm-jenkins:1.0 jenkins-master/.

## Create image from postgresql/Dockerfile
sudo docker build --rm=true --no-cache -t cnadalm-postgres:1.0 postgresql/.

## Create image from wildfly/Dockerfile
**/!\ Value 'database' overrides the default argument value in dockerfile**

sudo docker build --rm=true --no-cache --build-arg DB_HOST=database --build-arg DB_PASS=newpwd -t cnadalm-wildfly:1.0 wildfly/.

## *List docker images*
sudo docker images
