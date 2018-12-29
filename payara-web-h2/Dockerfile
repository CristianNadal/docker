FROM payara/server-web:5.181

MAINTAINER Cristian Nadal "xtian.nadal@gmail.com"

ENV PAYARA_DOMAIN domain1
# domain1 VS production 

# Args for DataBase and DataSource
ARG DB_HOST=localhost
ARG DB_PORT=9092
ARG DB_NAME=H2DB
ARG DB_USER=sa
ARG DB_PASS=sa
ARG DB_POOLNAME=${DB_NAME}Pool
ARG DB_POOLSIZE=5
ARG DB_POOLSIZE_MAX=25
ARG DS_NAME=H2DS

# ENV DB_USER ...
# ENV DB_PASS ... 

# Setup configuration :: Connection Pool, JDBC Resource, then some JVM Options
RUN $PAYARA_PATH/bin/asadmin start-domain $PAYARA_DOMAIN && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile create-jdbc-connection-pool \
    --datasourceclassname org.h2.jdbcx.JdbcDataSource \
    --restype javax.sql.XADataSource \
    --property user=$DB_USER:password=$DB_PASS:url="jdbc\:h2\:tcp\://$DB_HOST\:$DB_PORT/~/data/$DB_NAME" $DB_POOLNAME && \
#  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile ping-connection $DB_POOLNAME && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
    resources.jdbc-connection-pool.$DB_POOLNAME.steady-pool-size=$DB_POOLSIZE && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
    resources.jdbc-connection-pool.$DB_POOLNAME.max-pool-size=$DB_POOLSIZE_MAX && \
#  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
#    resources.jdbc-connection-pool.$DB_POOLNAME.is-connection-validation-required=true && \
#  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
#    resources.jdbc-connection-pool.$DB_POOLNAME.connection-validation-method=custom-validation && \
#  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
#    resources.jdbc-connection-pool.$DB_POOLNAME.validation-classname=org.glassfish.api.jdbc.validation.H2ConnectionValidation && \
#  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
#    resources.jdbc-connection-pool.$DB_POOLNAME.fail-all-connections=true && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
    resources.jdbc-connection-pool.$DB_POOLNAME.statement-leak-timeout-in-seconds=5 && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile set \
    resources.jdbc-connection-pool.$DB_POOLNAME.connection-leak-timeout-in-seconds=5 && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile create-jdbc-resource --connectionpoolid $DB_POOLNAME jdbc/$DS_NAME && \
  $PAYARA_PATH/bin/asadmin --user=admin --passwordfile=/opt/pwdfile create-jvm-options -Duser.timezone=UTC && \
  $PAYARA_PATH/bin/asadmin stop-domain $PAYARA_DOMAIN

# Expose ports (4848:administration, 8080:app, 8181:app TLS, 9009:debug, 9092:H2DB)
EXPOSE 4848 8080 8181 9009 9092

# Post Boot Commands script
COPY entrypoint.sh $PAYARA_PATH/entrypoint.sh
USER root
RUN \
 chown -R payara:payara $PAYARA_PATH/entrypoint.sh && \
 chmod a+x $PAYARA_PATH/entrypoint.sh
USER payara

ENTRYPOINT $PAYARA_PATH/entrypoint.sh
