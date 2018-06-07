#!/bin/sh

# This will start TCP Server ('server' mode) for H2 Database Engine (only allow TCP/IP connections)
nohup java -jar $JBOSS_HOME/modules/system/layers/base/com/h2database/h2/main/h2*.jar -tcp -tcpAllowOthers &


# This will boot WildFly in the standalone mode and bind to all interface
# Note: in standalone mode we need -Duser.timezone=UTC to configure UTC timezone
$JBOSS_HOME/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Duser.timezone=UTC -Dee8.preview.mode=true --debug

