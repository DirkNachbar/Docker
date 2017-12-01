Oracle Forms & Reports on Docker
=====
This github Repository contains all necessary Docker buildfiles to create an Oracle Forms & Reports 12.2.1.2.0 and Oracle Forms & Reports 12.2.1.3.0 environments under Docker

## Requirements
- Docker Host with Docker 17 or higher
- Docker Compose
- Oracle Database
   - either native running Oracle Database with UNICODE Character Set
   - or Oracle Database on Docker see (https://github.com/oracle/docker-images/tree/master/OracleDatabase)

For a good HowTo setup your initial Docker environment, you may have a look on Gerald Venzl's Blog https://geraldonit.com/2017/08/21/creating-an-oracle-database-docker-image/ . Specially the section "Increase base image size" will save you a lot of trouble ;-)

## How to build Oracle Forms & Reports 12.2.1.2.0
Get a copy of this repository on your Docker host, make sure that your Docker host have either direct Internet Connection or configure a Proxy to be able to run required `yum install` commands inside the Docker build files

**Important** As pre requirement you should create upfront the necessary volumes on your Docker Host:

         mkdir -p /opt/oracle/oradata
         mkdir -p /opt/oracle/user_projects
         # Make sure that your oracle user on the Docker Host got:
         # uid=54321(oracle) gid=54321(oinstall)
         chown -R oracle:oinstall /opt/oracle/oradata
         chown -R oracle:oinstall /opt/oracle/user_projects
         chmod -r 777 /opt/oracle/oradata
         chmod -r 777 /opt/oracle/user_projects

Create your Oracle Database which will host the Metadata Repository for the Oracle Forms & Reports environment. I recommend to use the Docker Image from Oracle https://github.com/oracle/docker-images/tree/master/OracleDatabase

1. Change to the subdirectory OracleJava/java-8
   - Place the JDK 8u151 tar.gz in the folder OracleJava/java-8

         ./buildDockerImage.sh

   - This will create an Image with OracleLinux:latest containing the Oracle JDK 8u151
   - **Resulting Image => oracle/serverjdk**

2. Change to the subdirectory OracleFMWInfrastructure/dockerfiles
   - Place the fmw_12.2.1.2.0_infrastructure_Disk1_1of1.zip file under OracleFMWInfrastructure/dockerfiles/12.2.1.2

         ./buildDockerImage.sh -v 12.2.1.2

   - This extend the oracle/serverjdk image with several required RPM's for Oracle Forms & Reports and install an Oracle WebLogic Server Infrastructure 12.2.1.2.0
   - **Resulting Image => oracle/fmw-infrastructure TAG: 12.2.1.2**

3. Change to the subdirectory OracleFormsReports/dockerfiles
   - Place the fmw_12.2.1.2.0_fr_linux64.bin file under OracleFormsReports/dockerfiles/12.2.1.2

         ./buildDockerImage.sh -v 12.2.1.2

   - This extend the oracle/fmw-infrastructure image with Oracle Forms & Reports 12.2.1.2.0 Software
   - **Resulting Image => localhost/oracle/formsreports TAG: 12.2.1.2**

4. Change to the subdirectory OracleFormsReports/sample
   - Align the ../setenv.sh file with your personal settings
   - Afterwards execute following commands:

         source ../setenv.sh
         docker-compose up -d frfmw; docker logs frfmw -f

5. Startup the frfmw container
   - To startup the frfmw container (Node Manager and AdminServer) use following command

         docker start frfmw
         # Tail the container logs until you see the line
         # . . . <BEA-000365> <Server state changed to RUNNING.>
         docker logs -f frfmw

   - To startup the Managed Server and Oracle HTTP Server connect with a browser on your Docker Host to the forwarded AdminServer port (most likely 7001) to the Enterprise Manager Fusion Middleware Control (http://localhost:7001/em)
   - To startup the created Oracle Reports Server use following commands:

         docker exec -ti frfmw /bin/bash
         cd /opt/oracle/user_projects/domains/<DOMAIN_NAME>/bin
         ./startComponent.sh <REPORTS_SERVER_NAME>
         exit

6. Configure your Forms & Reports
   - As the complete `$DOMAIN_HOME` is mapped to a volume (/opt/oracle/user_projects/<DOMAIN_NAME>) on your Docker host, you can directly edit from the Docker Host your various configuration files, e.g. formsweb.cfg, rwserver.conf, httpd.conf and so on

## How to build Oracle Forms & Reports 12.2.1.3.0
Get a copy of this repository on your Docker host, make sure that your Docker host have either direct Internet Connection or configure a Proxy to be able to run required `yum install` commands inside the Docker build files

**Important** As pre requirement you should create upfront the necessary volumes on your Docker Host:

         mkdir -p /opt/oracle/oradata
         mkdir -p /opt/oracle/user_projects
         # Make sure that your oracle user on the Docker Host got:
         # uid=54321(oracle) gid=54321(oinstall)
         chown -R oracle:oinstall /opt/oracle/oradata
         chown -R oracle:oinstall /opt/oracle/user_projects
         chmod -r 777 /opt/oracle/oradata
         chmod -r 777 /opt/oracle/user_projects

**Important** In case you are planning to use the new Oracle Forms 12.2.1.3.0 feature Forms Application Deployment Services (FADS), you have to name your WebLogic Admin Server "AdminServer" !!! As this name for the Admin Server is hardcoded in the configuration script for FADS and in the deployed FADS ear-file

Create your Oracle Database which will host the Metadata Repository for the Oracle Forms & Reports environment. I recommend to use the Docker Image from Oracle https://github.com/oracle/docker-images/tree/master/OracleDatabase

1. Change to the subdirectory OracleJava/java-8
   - Place the JDK 8u151 tar.gz in the folder OracleJava/java-8

         ./buildDockerImage.sh

   - This will create an Image with OracleLinux:latest containing the Oracle JDK 8u151
   - **Resulting Image => oracle/serverjdk**

2. Change to the subdirectory OracleFMWInfrastructure/dockerfiles
   - Place the fmw_12.2.1.3.0_infrastructure_Disk1_1of1.zip file under OracleFMWInfrastructure/dockerfiles/12.2.1.3

         ./buildDockerImage.sh -v 12.2.1.3

   - This extend the oracle/serverjdk image with several required RPM's for Oracle Forms & Reports and install an Oracle WebLogic Server Infrastructure 12.2.1.3.0
   - **Resulting Image => oracle/fmw-infrastructure TAG: 12.2.1.3**

3. Change to the subdirectory OracleFormsReports/dockerfiles
   - Place the fmw_12.2.1.3.0_fr_linux64.bin and fmw_12.2.1.3.0_fr_linux64-2.zip files under OracleFormsReports/dockerfiles/12.2.1.3

         ./buildDockerImage.sh -v 12.2.1.3

   - This extend the oracle/fmw-infrastructure image with Oracle Forms & Reports 12.2.1.3.0 Software
   - **Resulting Image => localhost/oracle/formsreports TAG: 12.2.1.3**

4. Change to the subdirectory OracleFormsReports/sample
   - Align the ../setenv.sh file with your personal settings (**Important**: Change the variable DC_FR_VERSION to 12.2.1.3)
   - Afterwards execute following commands:

         source ../setenv.sh
         docker-compose up -d frfmw; docker logs frfmw -f

5. Startup the frfmw container
   - To startup the frfmw container (Node Manager and AdminServer) use following command

         docker start frfmw
         # Tail the container logs until you see the line
         # . . . <BEA-000365> <Server state changed to RUNNING.>
         docker logs -f frfmw

   - To startup the Managed Server and Oracle HTTP Server connect with a browser on your Docker Host to the forwarded AdminServer port (most likely 7001) to the Enterprise Manager Fusion Middleware Control (http://localhost:7001/em)
   - To startup the created Oracle Reports Server use following commands:

         docker exec -ti frfmw /bin/bash
         cd /opt/oracle/user_projects/domains/<DOMAIN_NAME>/bin
         ./startComponent.sh <REPORTS_SERVER_NAME>
         exit

6. Configure your Forms & Reports
   - As the complete `$DOMAIN_HOME` is mapped to a volume (/opt/oracle/user_projects/<DOMAIN_NAME>) on your Docker host, you can directly edit from the Docker Host your various configuration files, e.g. formsweb.cfg, rwserver.conf, httpd.conf and so on

## License

To download and run Oracle Fusion Middleware and Oracle JDK, regardless whether inside or outside a Docker container, you must download the binaries from the Oracle website and accept the license indicated at that page.
