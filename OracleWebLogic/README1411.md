Optimized WebLogic Image on Docker
===============
This repository contains a solution for building an space optimized Oracle WebLogic 14.1.1.0.0 Image.

The original (non optimized) Image size for a WebLogic 14.1.1.0.0 is normally 3.18 GB, while my optimized solution is just 1.62 GB (nearly 50% saving)

```
REPOSITORY          TAG                    IMAGE ID            CREATED             SIZE
oracle/weblogic     14.1.1.0.0-optimized   ebe06a93a85b        9 minutes ago       1.62GB
oracle/weblogic     14.1.1.0.0-generic     3bb4e4041df1        21 minutes ago      3.18GB
```

## Prerequirements
You will need to download following installation files:
* [Download Oracle JDK 11](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html) and place the tar.gz file into the subdirectory dockerfiles/14.1.1.0.0/serverjre/java-11
* [Download Oracle WebLogic Server 14.1.1.0.0 Generic](https://www.oracle.com/middleware/technologies/fusionmiddleware-downloads.html) and place the zip file into the subdirectory dockerfiles/14.1.1.0.0

## Build the Oracle JDK 11 Image
At first build the Oracle JDK 11 Image:

```
$ cd dockerfiles/14.1.1.0.0/serverjre
$ ./buildDockerImage.sh
$ docker images | grep jdk
REPOSITORY          TAG                    IMAGE ID            CREATED             SIZE
oracle/jdk          11                     19088de5fc56        23 minutes ago      422MB

```

## Build the Optimized WebLogic Image
After the successful build of the Oracle Server JRE Image you can build the optimized WebLogic 12.2.1.3.0 Image.

In case you dont have a My Oracle Support and you are forced to use Oracle Server JRE 8u512 please use following commands with the option `-o`

```
$ cd dockerfiles
$ ./buildDockerImage.sh -v 14.1.1.0.0 -o
Checking if required packages are present and valid...
fmw_14.1.1.0.0_wls_Disk1_1of1.zip: OK
=====================
Building image 'oracle/weblogic:14.1.1.0.0-optimized' ...
Sending build context to Docker daemon  1.111GB
Step 1/17 : FROM oracle/jdk:11 as base
 ---> 19088de5fc56
Step 2/17 : MAINTAINER Dirk Nachbar <https://dirknachbar.blogspot.com>
 ---> Running in c39c23558036
Removing intermediate container c39c23558036
 ---> d586064f1b4a
. . .
. . .
Step 17/17 : CMD ["/u01/oracle/createAndStartEmptyDomain.sh"]
 ---> Running in 3393938b1ff0
Removing intermediate container 3393938b1ff0
 ---> ebe06a93a85b
Successfully built ebe06a93a85b
Successfully tagged oracle/weblogic:14.1.1.0.0-optimized

  WebLogic Docker Image for 'optimized' version 14.1.1.0.0 is ready to be extended:

    --> oracle/weblogic:14.1.1.0.0-optimized

  Build completed in 76 seconds.

$ docker images | grep weblogic
REPOSITORY          TAG                    IMAGE ID            CREATED             SIZE
oracle/weblogic     14.1.1.0.0-optimized   ebe06a93a85b        5 minutes ago       1.62GB
```

## Create the Oracle WebLogic Container
Before creating and running the Oracle WebLogic 14.1.1.0.0 Container align in the subdirectory `dockerfiles/14.1.1.0.0/properties` in the properties file `domain.properties` the provided username and password.
As next you can run following command:

```
# Define the Docker Image based on your above Docker Image build
# Either its "oracle/weblogic:14.1.1.0.0-optimized" or "oracle/weblogic:14.1.1.0.0-generic"

$ docker run -d --name <ContainerName> \
             -p 7001:7001 -p 9002:9002 \
             -v <Host Path to subdirectory properties>:/u01/oracle/properties \
             -e ADMINISTRATION_PORT_ENABLED=true -e DOMAIN_NAME=<DomainName> \
             oracle/weblogic:14.1.1.0.0-optimized

$ docker logs -f <ContainerName>

# For Example:

$ docker run -d --name wls1411optimized \
             -p 7001:7001 -p 9002:9002 \
             -v /projects/Docker/OracleWebLogic/dockerfiles/14.1.1.0.0/properties:/u01/oracle/properties \
             -e ADMINISTRATION_PORT_ENABLED=true -e DOMAIN_NAME=OptimizedDomain \
             oracle/weblogic:14.1.1.0.0-optimized

$ docker logs -f wls1411optimized

. . .
. . .
<Apr 1, 2020, 12:40:28,980 PM Greenwich Mean Time> <Notice> <WebLogicServer> <BEA-000329> <Started the WebLogic Server Administration Server "AdminServer" for domain "OptimizedDomain" running in production mode.> 
<Apr 1, 2020, 12:40:28,980 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure" is now listening on 172.17.0.2:7002 for protocols iiops, t3s, ldaps, https.> 
<Apr 1, 2020, 12:40:28,981 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "Default" is now listening on 172.17.0.2:7001 for protocols iiop, t3, ldap, snmp, http.> 
<Apr 1, 2020, 12:40:28,981 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "Default[1]" is now listening on 127.0.0.1:7001 for protocols iiop, t3, ldap, snmp, http.> 
<Apr 1, 2020, 12:40:28,982 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure[1]" is now listening on 127.0.0.1:7002 for protocols iiops, t3s, ldaps, https.> 
<Apr 1, 2020, 12:40:28,983 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "DefaultSecure" is now listening on 172.17.0.2:7002 for protocols iiops, t3s, ldaps, https.> 
<Apr 1, 2020, 12:40:28,983 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "Default" is now listening on 172.17.0.2:7001 for protocols iiop, t3, ldap, snmp, http.> 
<Apr 1, 2020, 12:40:28,984 PM Greenwich Mean Time> <Notice> <Server> <BEA-002613> <Channel "Default[1]" is now listening on 127.0.0.1:7001 for protocols iiop, t3, ldap, snmp, http.> 
<Apr 1, 2020, 12:40:29,010 PM Greenwich Mean Time> <Notice> <WebLogicServer> <BEA-000360> <The server started in RUNNING mode.> 
<Apr 1, 2020, 12:40:29,021 PM Greenwich Mean Time> <Notice> <WebLogicServer> <BEA-000365> <Server state changed to RUNNING.> 
```

