##########
# README #
##########

### General info ###

The jenkins-data volume container is not useful in docker-compose environment as 
long we can create persisting volumes directly from docker-compose.yml


### How to configure Jenkins from docker image ###

Once jenkins container has been installed (and data volume initialized) :

* Install 'Suggested' plugins

* Create regular user (dondecomo, dondecomo)
    In docker container, with command 'cat /var/jenkins_home/secrets/initialAdminPassword' 
    we can see the admin default password.

* Go to Jenkins > Manage Jenkins > Manage plugins > Available
    Install without restart:
        Maven integration plugin
        Pipeline Maven integration plugin
        Delivery Pipeline Plugin
        openJDK-native-plugin
        Bitbucket Plugin
        SonarQube Scanner for Jenkins

* Go to Jenkins > Manage Jenkins > Global Tool Configuration
    Configure JDK
        Name : java 8u131 openjdk
        JAVA_HOME : /usr/lib/jvm/java-8-openjdk-amd64
    Configure Git
        Let default values...
    Configure Maven
        Name : Maven 3.5.0
        Check Install automatically 
        Version : 3.5.0    


### Add Items ###

* Build and Package (Maven project)
    Description
        Compile | Test | Package
    Discard old builds
        Max # of builds to keep : 5
    Delivery Pipeline configuration 
        Stage Name : Build
        Task Name : Build and Package
    Source Code Management 
        Configure Git repository
            Repository URL : https://cnadalm@bitbucket.org/dondecomo/dondecomo-parent.git
            Credentials ...
    Build Triggers
        Build when a change is pushed to BitBucket
        (NOT) Repository poll : H/30 * * * *
    Build
        Goals : clean package
        Use custom workspace
            Directory : workspace-pipeline
    Build Settings        
        E-mail Notification
            Recipient : xtian.nadal@gmail.com
    
* Integration Tests
    Description
        Run Business Integration Tests
    Discard Old Builds
        Max # of builds to keep : 5
    Delivery Pipeline Configuration
    Source Code Management
        None
    Build Triggers
        Build after other projects are built
            Build and Package : Trigger only if build is stable
    Build
        Goals and options : clean install -DskipTests -DskipITs
        Use custom workspace
            Directory : workspace-pipeline
    Post Steps
        Run only if build succeeds
        Invoke top-level Maven targets
            Maven Version : Maven 3.5.0
            Goals : -Dtest=com.dondecomo.core.**.*TestIT.java -Dfile.encoding=UTF-8 -DfailIfNoTests=false surefire:test
    Project properties
        E-mail notifications

* Acceptance Tests (COPIED FROM Integration Tests)
    Description
        Run Acceptance Integration Tests
    Discard Old Builds
        Max # of builds to keep : 5
    Delivery Pipeline Configuration
    Source Code Management
        None
    Build Triggers
        Build after other projects are built (stable)
    Pre Steps
        Execute shell
            Command :
                # Go to workspace sql scripts folder
                cd ~/workspace-pipeline/dist/dev/scripts/sql/
                # Copy data scripts into postgres container and then execute script
                # Example : docker cp ./localfile.sql containername:/container/path/file.sql
                docker cp ./200_DATA.sql dc-database:/docker-entrypoint-initdb.d/dump.sql
                # Example : docker exec -u postgres pg_test psql postgres postgres -f docker-entrypoint-initdb.d/dump.sql
                docker exec -u dondecomo dc-database psql dondecomo dondecomo -f docker-entrypoint-initdb.d/dump.sql
                # Nomally, the artifact ROOT.war should be in path : ~/workspace-pipeline/deployments/
                # As this directory is a docker volume shared with wildfly deployments folder, the WAR should be deployed automatically
    Build
        Goals and options : -Dtest=com.dondecomo.api.**.*TestIT.java -Dfile.encoding=UTF-8 -DfailIfNoTests=false surefire:test
        Use custom workspace
            Directory : workspace-pipeline
    Project properties
        E-mail notifications

* Quality Java (COPIED FROM Acceptance Tests)
    Description
        Run Sonar quality metrics
    Discard Old Builds
        Max # of builds to keep : 5
    Delivery Pipeline Configuration
        Stage Name : Quality
        Task Name : Quality Java
    Source Code Management
        None
    Build Triggers
        Build after other projects are built (stable)
    Build
        Goals and options : clean org.jacoco:jacoco-maven-plugin:prepare-agent install -DskipITs
        Use custom workspace
            Directory : workspace-pipeline
    Post Steps
        Maven Version : Maven_3.5.0
        Goals : sonar:sonar -DskipTests -DskipITs -Dsonar.host.url=http://192.168.99:100:9000
    Project properties
        E-mail notifications



