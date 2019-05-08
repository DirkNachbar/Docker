Optimized WebLogic Image on Docker
===============
This repository contains a solution for building an space optimized Oracle WebLogic 12.2.1.3.0 Image.

The original Image provided by Oracle https://github.com/oracle/docker-images/tree/master/OracleWebLogic got an image size of 2.93 GB, while my optimized solution is just 1.4 GB (50% saving)

```
REPOSITORY           TAG                  IMAGE ID            CREATED             SIZE
oracle/weblogic      12.2.1.3-optimized   854be1c2bbb9        7 minutes ago       1.4GB
oracle/weblogic      12.2.1.3-generic     ba0d1c2dc430        25 minutes ago      2.93GB
```

## Prerequirements
You will need to complete following requirements to build the optimized Oracle WebLogic 12.2.1.3.0 Image:

* [Download Oracle Server JRE 8u152](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html) and place the tar.gz file into the subdirectory dockerfiles/12.2.1.3/serverjre
* [Download Oracle WebLogic Server 12.2.1.3.0 Generic](https://www.oracle.com/technetwork/middleware/weblogic/downloads/index.html) and place the zip file into the subdirectory dockerfiles/12.2.1.3

## Build the Oracle Server JRE Image
At first build the Oracle Server JRE Image:

```
$ cd dockerfiles/12.2.1.3/serverjre
$ ./buildDockerImage.sh
$ docker images | grep serverjre
REPOSITORY           TAG                  IMAGE ID            CREATED             SIZE
oracle/serverjre     8                    63b4768f6557        About an hour ago   387MB
```

## Build the Optimized WebLogic Image
After the successful build of the Oracle Server JRE Image you can build the optimized WebLogic 12.2.1.3.0 Image

```
$ cd dockerfiles
$ ./buildDockerImage.sh -v 12.2.1.3 -o

Checking if required packages are present and valid...
fmw_12.2.1.3.0_wls_Disk1_1of1.zip: OK
=====================
Building image 'oracle/weblogic:12.2.1.3-optimized' ...
Sending build context to Docker daemon    839MB
Step 1/17 : FROM oracle/serverjre:8 as base
 ---> 63b4768f6557
Step 2/17 : LABEL maintainer="dirk.nachbar@trivadis.com"
 ---> Running in 9bfcf5aaa1d4
Removing intermediate container 9bfcf5aaa1d4
 ---> 6cff4f8712d8
. . .
. . .
Step 13/17 : FROM base
 ---> 718f0506dfb8
Step 14/17 : COPY --chown=oracle:oracle --from=builder $ORACLE_HOME $ORACLE_HOME
 ---> 46ee0e3fd822
Step 15/17 : COPY --chown=oracle:oracle --from=builder $JAVA_HOME $JAVA_HOME
 ---> bddc30cf710e
Step 16/17 : WORKDIR ${ORACLE_HOME}
 ---> Running in b7a122dc521b
Removing intermediate container b7a122dc521b
 ---> 1b2aa03acef6
Step 17/17 : CMD ["/u01/oracle/createAndStartEmptyDomain.sh"]
 ---> Running in 296506a7fc03
Removing intermediate container 296506a7fc03
 ---> 854be1c2bbb9
Successfully built 854be1c2bbb9
Successfully tagged oracle/weblogic:12.2.1.3-optimized

  WebLogic Docker Image for 'optimized' version 12.2.1.3 is ready to be extended:

    --> oracle/weblogic:12.2.1.3-optimized

  Build completed in 258 seconds.

$ docker images
REPOSITORY           TAG                  IMAGE ID            CREATED             SIZE
oracle/weblogic      12.2.1.3-optimized   854be1c2bbb9        24 minutes ago      1.4GB
```

## Create the Oracle WebLogic Container
Before creating and running the Oracle WebLogic 12.2.1.3.0 Container align in the subdirectory `dockerfiles/12.2.1.3/properties` in the properties file `domain.properties` the provided username and password.
As next you can run following command:

```
$ docker run -d --name <ContainerName> \
             -p 7001:7001 -p 9002:9002 \
             -v <Host Path to subdirectory properties>:/u01/oracle/properties \
             -e ADMINISTRATION_PORT_ENABLED=true -e DOMAIN_NAME=<DomainName> \
             oracle/weblogic:12.2.1.3-optimized

$ docker logs -f <ContainerName>

# For Example:

$ docker run -d --name wls12213optimized \
             -p 7001:7001 -p 9002:9002 \
             -v /work/OracleWebLogic/dockerfiles/12.2.1.3/properties:/u01/oracle/properties \
             -e ADMINISTRATION_PORT_ENABLED=true -e DOMAIN_NAME=OptimizedDomain \
             oracle/weblogic:12.2.1.3-optimized

$ docker logs -f wls12213optimized

<May 8, 2019 8:56:16,862 AM UTC> <Notice> <WebLogicServer> <BEA-000329> <Started the WebLogic Server Administration Server "AdminServer" for domain "OptimizedDomain" running in production mode.> 
<May 8, 2019 8:56:16,864 AM UTC> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure[1]" is now listening on 127.0.0.1:7002 for protocols iiops, t3s, ldaps, https.> 
<May 8, 2019 8:56:16,865 AM UTC> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure" is now listening on 172.17.0.2:7002 for protocols iiops, t3s, ldaps, https.> 
<May 8, 2019 8:56:16,865 AM UTC> <Notice> <Server> <BEA-002613> <Channel "Default" is now listening on 172.17.0.2:7001 for protocols iiop, t3, ldap, snmp, http.> 
<May 8, 2019 8:56:16,866 AM UTC> <Notice> <Server> <BEA-002613> <Channel "Default[1]" is now listening on 127.0.0.1:7001 for protocols iiop, t3, ldap, snmp, http.> 
<May 8, 2019 8:56:16,866 AM UTC> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure[1]" is now listening on 127.0.0.1:7002 for protocols iiops, t3s, ldaps, https.> 
<May 8, 2019 8:56:16,866 AM UTC> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure" is now listening on 172.17.0.2:7002 for protocols iiops, t3s, ldaps, https.> 
<May 8, 2019 8:56:16,867 AM UTC> <Notice> <Server> <BEA-002613> <Channel "Default" is now listening on 172.17.0.2:7001 for protocols iiop, t3, ldap, snmp, http.> 
<May 8, 2019 8:56:16,867 AM UTC> <Notice> <Server> <BEA-002613> <Channel "Default[1]" is now listening on 127.0.0.1:7001 for protocols iiop, t3, ldap, snmp, http.> 
<May 8, 2019 8:56:16,881 AM UTC> <Notice> <WebLogicServer> <BEA-000360> <The server started in RUNNING mode.> 
<May 8, 2019 8:56:16,911 AM UTC> <Notice> <WebLogicServer> <BEA-000365> <Server state changed to RUNNING.> 
```

