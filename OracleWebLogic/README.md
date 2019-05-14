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

If you don't have a My Oracle Support Login you will have to download the Oracle Server JRE 8u152, as with a higher Oracle Server JRE you will run into a bug during the WebLogic Domain creation.

* [Download Oracle Server JRE 8u152](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html) and place the tar.gz file into the subdirectory dockerfiles/12.2.1.3/serverjre
* [Download Oracle WebLogic Server 12.2.1.3.0 Generic](https://www.oracle.com/technetwork/middleware/weblogic/downloads/index.html) and place the zip file into the subdirectory dockerfiles/12.2.1.3

In case you have a My Oracle Support Login, you can use a higher version that Oracle Server JRE 8u512, for example Oracle Server JRE 8u202. 

**IMPORTANT CHANGES 14th May 2019**: I have changed the patch apply procedure completely, instead of using hard-coded patch number, you can use a flexible patch concept now:
For this, download your desired patches (only the OPatch Patch 28186730 is mandatory) and place each single patch in a subdirectory `patches/00n`
For example you want to apply directly at your Image build the Oracle CPU April 2019 for WebLogic 12.2.1.3.0 (Patch no. 29016089) and the Patch 29637821. Just download the 2 patches and place the Patch 29016089 in `patches/001` and the Patch 29637821 in `patches/002`. The OPatch Patch 28186730, which is mandatory, you need to place in `patches`. 

```
cd dockerfiles/12.2.1.3.0/patches
tree
├── 001
│   └── p29016089_122130_Generic.zip
├── 002
│   └── p29637821_122130_Generic.zip
├── applyPatches.sh
└── p28186730_139400_Generic.zip
```

So download following files:

* [Download Oracle Server JRE 8u202](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html) and place the tar.gz file into the subdirectory dockerfiles/12.2.1.3/serverjre
* [Download Oracle WebLogic Server 12.2.1.3.0 Generic](https://www.oracle.com/technetwork/middleware/weblogic/downloads/index.html) and place the zip file into the subdirectory dockerfiles/12.2.1.3
* [Download OPatch Patch, Patch 28186730 from My Oracle Support](https://updates.oracle.com/Orion/Services/download/p28186730_139400_Generic.zip?aru=22731294&patch_file=p28186730_139400_Generic.zip) and place the zip file into the subdirectory dockerfiles/12.2.1.3/patches
* [Download CPU Patch April 2019, Patch 29016089](https://updates.oracle.com/Orion/Services/download/p29016089_122130_Generic.zip?aru=22640288&patch_file=p29016089_122130_Generic.zip) and place the zip file into the subdirectory dockerfiles/12.2.1.3/patches/00n
* any desired patch which you need on top, place them into `patches/00n`

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
After the successful build of the Oracle Server JRE Image you can build the optimized WebLogic 12.2.1.3.0 Image.

In case you dont have a My Oracle Support and you are forced to use Oracle Server JRE 8u512 please use following commands with the option `-o`

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

In case you a My Oracle Suppport and you have downloaded the above mentioned 2 patches, you can build your Docker Image with the option `-p`

```
$ cd dockerfiles
$ ./buildDockerImage.sh -v 12.2.1.3 -p

Checking if required packages are present and valid...
fmw_12.2.1.3.0_wls_Disk1_1of1.zip: OK
=====================
Building image 'oracle/weblogic:12.2.1.3-optimized_patch' ...
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
Successfully tagged oracle/weblogic:12.2.1.3-optimized_patch

  WebLogic Docker Image for 'optimized_patch' version 12.2.1.3 is ready to be extended:

    --> oracle/weblogic:12.2.1.3-optimized_patch

  Build completed in 258 seconds.

$ docker images
REPOSITORY           TAG                        IMAGE ID            CREATED             SIZE
oracle/weblogic      12.2.1.3-optimized_patch   2e2ca542ba03        21 hours ago        1.49GB
```


## Create the Oracle WebLogic Container
Before creating and running the Oracle WebLogic 12.2.1.3.0 Container align in the subdirectory `dockerfiles/12.2.1.3/properties` in the properties file `domain.properties` the provided username and password.
As next you can run following command:

```
# Define the Docker Image based on your above Docker Image build
# Either its "oracle/weblogic:12.2.1.3-optimized" or "oracle/weblogic:12.2.1.3-optimized_patch"

$ docker run -d --name <ContainerName> \
             -p 7001:7001 -p 9002:9002 \
             -v <Host Path to subdirectory properties>:/u01/oracle/properties \
             -e ADMINISTRATION_PORT_ENABLED=true -e DOMAIN_NAME=<DomainName> \
             oracle/[weblogic:12.2.1.3-optimized|weblogic:12.2.1.3-optimized_patch]

$ docker logs -f <ContainerName>

# For Example:

$ docker run -d --name wls12213optimized \
             -p 7001:7001 -p 9002:9002 \
             -v /work/OracleWebLogic/dockerfiles/12.2.1.3/properties:/u01/oracle/properties \
             -e ADMINISTRATION_PORT_ENABLED=true -e DOMAIN_NAME=OptimizedDomain \
             oracle/[weblogic:12.2.1.3-optimized|weblogic:12.2.1.3-optimized_patch]

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

