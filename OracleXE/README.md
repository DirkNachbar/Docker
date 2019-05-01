Optimized Oracle XE 18c on Docker
=====
Build a Docker image containing Oracle XE 18c with optimized size (5.41 GB instead of 8.7 GB) including Archivelog Mode and Flashback


## Oracle XE 18c Software
[Download Oracle XE 18c](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) `.rpm` file and drop it inside folder `18.4.0`. 

## Prerequirements
You will need to complete following prerequirements
```
$ groupadd -g 54321 oinstall
$ useradd -d /home/oracle -m -g oinstall [-G docker] -u 54321 oracle
# Depending on your disk layout you will need to create 4 directories
# e.g. you have one mount point called u01, create the following 4 directories below and switch the ownership to the oracle user
$ mkdir -p /u01/diag
$ mkdir -p /u01/oradata
$ mkdir -p /u01/fast_recovery_area
$ mkdir -p /u01/tools
```
## Build it
To build the images just run below command:
```
$ ./buildDockerImage.sh -v 18.4.0 -x
. . .
Successfully built ac71812fa9d3
Successfully tagged oracle/database:18.4.0-xe


  Oracle Database Docker Image for 'xe' version 18.4.0 is ready to be extended: 
    
    --> oracle/database:18.4.0-xe

  Build completed in 697 seconds.

```

## Run the Container

