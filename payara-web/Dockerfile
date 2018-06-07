############################################################################
# Note:
#
# The amount of connections configured in the pool should not be anyway be 
# greater than the maximum number of connections which are allowed by 
# PostGreSQL (100 by default). This value is configured in the 
# /etc/postgres/postgresql.conf file.
############################################################################

FROM payara/server-web:5.181

MAINTAINER Cristian Nadal "xtian.nadal@gmail.com"

ENV POSTGRESQL_VERSION 42.1.4

USER payara

# /!\ Add PG driver
ADD postgresql-${POSTGRESQL_VERSION}.jar /opt/payara5/glassfish/domains/domain1/lib
#RUN cd /tmp && \
#    curl --location --output postgresql-${POSTGRESQL_VERSION}.jar --url http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/${POSTGRESQL_VERSION}/postgresql-${POSTGRESQL_VERSION}.jar    

# Args for connection
ARG DB_HOST=localhost
ARG DB_PORT=5432
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

# Args for datasource
ARG DS_NAME=PostgreSQLDS
ARG DS_POOLNAME=PostgreSQLDSPool
#ARG DS_MAX_POOL_SIZE=50

# Setup configuration :: Connection Pool
RUN ${PAYARA_PATH}/bin/asadmin start-domain domain1 && \
  ${PAYARA_PATH}/bin/asadmin --user=admin --passwordfile=/opt/pwdfile create-jdbc-connection-pool \
    --datasourceclassname org.postgresql.ds.PGConnectionPoolDataSource \
    --restype javax.sql.ConnectionPoolDataSource \
    --property User=${DB_USER}:Password=${DB_PASS}:DatabaseName=${DB_NAME}:ServerName=${DB_HOST}:Port=${DB_PORT} ${DS_POOLNAME} && \
  ${PAYARA_PATH}/bin/asadmin stop-domain domain1

# Setup configuration :: JDBC Resource
RUN ${PAYARA_PATH}/bin/asadmin start-domain domain1 && \
  ${PAYARA_PATH}/bin/asadmin --user=admin --passwordfile=/opt/pwdfile create-jdbc-resource --connectionpoolid ${DS_POOLNAME} ${DS_NAME} && \
  ${PAYARA_PATH}/bin/asadmin stop-domain domain1

# Setup configuration :: JVM Options
RUN ${PAYARA_PATH}/bin/asadmin start-domain domain1 && \
  ${PAYARA_PATH}/bin/asadmin --user=admin --passwordfile=/opt/pwdfile create-jvm-options -Duser.timezone=UTC && \
  ${PAYARA_PATH}/bin/asadmin stop-domain domain1

# Override exposed ports
EXPOSE 4848 9009 8080 8181
