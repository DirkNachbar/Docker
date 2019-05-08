Oracle Java on Docker
=====
Build a Docker image containing Oracle Server JRE 1.8u152.


## JDK 8
[Download Server JRE 1.8u152](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html) `.tar.gz` file and drop it inside folder `java-8`. 
Build it:

```
$ cd java-8
$ docker build -t oracle/serverjre:8 .

# or use

$ cd java-8
$ ./buildDockerImage.sh
```
