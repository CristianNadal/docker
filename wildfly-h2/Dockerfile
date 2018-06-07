FROM jboss/wildfly:12.0.0.Final

MAINTAINER Cristian Nadal "xtian.nadal@gmail.com"

# Download Hibernate 5.2.15 to benefit of new java8 types, then replace version
RUN cd $JBOSS_HOME/modules/system/layers/base/org/hibernate/main && \
    curl -O http://central.maven.org/maven2/org/hibernate/hibernate-core/5.2.15.Final/hibernate-core-5.2.15.Final.jar && \
    curl -O http://central.maven.org/maven2/org/hibernate/hibernate-envers/5.2.15.Final/hibernate-envers-5.2.15.Final.jar && \
    sed -i.bak "s/5.1.10/5.2.15/" module.xml && \
    sed -i.bak "/entitymanager/d" module.xml && \
    sed -i.bak "/java8/d" module.xml && \
    rm *.bak

# Args for datasource
ARG DS_NAME=H2DS
ARG DS_MAX_POOL_SIZE=10
ARG DB_NAME=h2Database
ARG DB_USER=sa
ARG DB_PASS=sa
ARG DB_PORT=9092

# Enable SSL, then create datasource (H2DB in 'server' mode)
RUN /bin/sh -c '$JBOSS_HOME/bin/standalone.sh &' && \
    sleep 5 && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="/core-service=management/security-realm=ApplicationRealm/server-identity=ssl:write-attribute(name=protocol, value=openssl.TLS)" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="data-source add --name=${DS_NAME} --jndi-name=java:jboss/datasources/${DS_NAME} --user-name=${DB_USER} --password=${DB_PASS} --driver-name=h2 --connection-url=jdbc:h2:tcp://localhost:${DB_PORT}/~/data/${DB_NAME}" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=datasources/data-source=${DS_NAME}:write-attribute(name=max-pool-size,value=${DS_MAX_POOL_SIZE})" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command=:shutdown && \
    rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history/ $JBOSS_HOME/standalone/log/*

# Add user to server
USER jboss
RUN $JBOSS_HOME/bin/add-user.sh admin admin --silent

# Expose ports (8443:app, 9092:h2db, 9990:administration, 8787:debug)
EXPOSE 8443 9092 9990 8787

# Init script to initialize DB and Server
COPY entrypoint.sh /entrypoint.sh

# Set the default entrypoint to run on boot
ENTRYPOINT ["/entrypoint.sh"]

