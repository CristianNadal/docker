#!/bin/sh


############
### H2DB ###
############

# Start TCP Server ('server' mode) for H2 Database Engine (only allow TCP/IP connections)
nohup java -Xms32m -Xmx256m -jar $PAYARA_PATH/h2db/bin/h2*.jar -tcp -tcpPort 9092 -tcpAllowOthers &
#nohup java -Xms32m -Xmx256m -cp $PAYARA_PATH/h2db/bin/h2*.jar org.h2.tools.Server -tcp -tcpAllowOthers -tcpPort 9092 &

# Start H2 in Server Mode
#${PAYARA_PATH}/bin/asadmin start-database --dbtype h2 --jvmoptions="-Xms32m -Xmx256m" --dbhost localhost --dbport 9092

# Stop (example)
#${PAYARA_PATH}/bin/asadmin stop-database --dbtype h2 --dbhost localhost --dbport 9092


#########################
### PAYARA WEB SERVER ###
#########################

# Start Payara Web Server
${PAYARA_PATH}/bin/asadmin start-domain --debug true ${PAYARA_DOMAIN}

# then Deploy applications
${PAYARA_PATH}/bin/asadmin --user=admin --passwordfile=/opt/pwdfile deploy --force --enabled=true --contextroot / ${PAYARA_PATH}/deployments/nanny.war
${PAYARA_PATH}/bin/asadmin --user=admin --passwordfile=/opt/pwdfile deploy --force --enabled=true --contextroot /account/ ${PAYARA_PATH}/deployments/nanny-account.war

# Start Payara Web Server then deploy applications (from https://github.com/payara/docker-payaraserver-web/blob/master/Dockerfile)
#${PAYARA_PATH}/generate_deploy_commands.sh
#${PAYARA_PATH}/bin/startInForeground.sh --passwordfile=/opt/pwdfile --postbootcommandfile ${POSTBOOT_COMMANDS} --debug true ${PAYARA_DOMAIN}



