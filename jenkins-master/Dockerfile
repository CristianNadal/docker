FROM jenkins:2.60.1
MAINTAINER Cristian Nadal <xtian.nadal@gmail.com>

USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

# install maven (unzip already installed, inherited from jenkins->openjdk images)
#ADD apache-maven-3.5.0-bin.zip /home/jenkins/
#RUN unzip /home/jenkins/apache-maven-3.5.0-bin.zip -d /home/jenkins/
#RUN chown -R jenkins /home/jenkins/apache-maven-3.5.0

USER jenkins

ENV JAVA_OPTS="-Xmx1024m"
