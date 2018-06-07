############################################################################
# Note:
#
# The amount of connections configured in the pool should not be anyway be 
# greater than the maximum number of connections which are allowed by 
# PostGreSQL (100 by default). This value is configured in the 
# /etc/postgres/postgresql.conf file.
############################################################################

FROM jboss/wildfly:12.0.0.Final

MAINTAINER Cristian Nadal "xtian.nadal@gmail.com"

ENV POSTGRESQL_VERSION 42.1.4

# Args for connection
ARG DB_HOST=localhost
ARG DB_PORT=5432
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

# Args for datasource
ARG DS_NAME=PostgreSQLDS
ARG DS_MAX_POOL_SIZE=50

# /!\ Add PG driver
ADD postgresql-${POSTGRESQL_VERSION}.jar /tmp
#RUN cd /tmp && \
#    curl --location --output postgresql-${POSTGRESQL_VERSION}.jar --url http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar    

# Download Hibernate 5.2.15 to benefit of new java8 types, then replace version
RUN cd $JBOSS_HOME/modules/system/layers/base/org/hibernate/main && \
    curl -O http://central.maven.org/maven2/org/hibernate/hibernate-core/5.2.15.Final/hibernate-core-5.2.15.Final.jar && \
    curl -O http://central.maven.org/maven2/org/hibernate/hibernate-envers/5.2.15.Final/hibernate-envers-5.2.15.Final.jar && \
    sed -i.bak "s/5.1.10/5.2.15/" module.xml && \
    sed -i.bak "/entitymanager/d" module.xml && \
    sed -i.bak "/java8/d" module.xml && \
    rm *.bak

# Install postgres driver and datasource, then tune the DDBB
RUN /bin/sh -c '$JBOSS_HOME/bin/standalone.sh &' && \
    sleep 6 && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="module add --name=org.postgresql --resources=/tmp/postgresql-${POSTGRESQL_VERSION}.jar --dependencies=javax.api,javax.transaction.api" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=datasources/jdbc-driver=postgresql:add(driver-name="postgresql",driver-module-name="org.postgresql",driver-class-name=org.postgresql.Driver)" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="data-source add --name=${DS_NAME} --jndi-name=java:jboss/datasources/${DS_NAME} --user-name=${DB_USER} --password=${DB_PASS} --driver-name=postgresql --connection-url=jdbc:postgresql://${DB_HOST}/${DB_NAME}" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command=:shutdown && \
    rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history/ $JBOSS_HOME/standalone/log/*

# Expose ports
EXPOSE 8080 8443 9990 8787

# Add user to server
USER jboss
RUN $JBOSS_HOME/bin/add-user.sh admin admin --silent

# Set the default entrypoint to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
# Note: in standalone mode we need -Duser.timezone=UTC to configure UTC timezone
CMD /bin/sh -c '/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 --debug -DPOSTGRES_HOST=$DB_HOST -DPOSTGRES_PORT=$DB_PORT -DPOSTGRES_USER=$DB_USER -DPOSTGRES_PASSWORD=$DB_PASS -Duser.timezone=UTC -Dee8.preview.mode=true'
