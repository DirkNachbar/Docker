Optimized Oracle XE 18c on Docker
=====
Build a Docker image containing Oracle XE 18c with optimized size (5.41 GB instead of 8.7 GB) including Archivelog Mode and Flashback


## Oracle XE 18c Software
[Download Oracle XE 18c](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) `.rpm` file and drop it inside folder `18.4.0`. 
Build it:

```
$ ./buildDockerImage.sh -v 18.4.0 -x
. . .
Successfully built ac71812fa9d3
Successfully tagged oracle/database:18.4.0-xe


  Oracle Database Docker Image for 'xe' version 18.4.0 is ready to be extended: 
    
    --> oracle/database:18.4.0-xe

  Build completed in 697 seconds.

```
