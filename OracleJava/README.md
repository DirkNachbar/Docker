Oracle Java on Docker
=====
Build a Docker image containing Oracle JDK 1.8.


## JDK 8
[Download Server JDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) `.tar.gz` file and drop it inside folder `java-8`. 
Build it:

```
$ cd java-8
$ docker build -t oracle/serverjdk:8 .
```
