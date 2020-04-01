Oracle Java on Docker
=====
Build a Docker image containing Oracle JDK 11.


## JDK 11
[Download Oracle JDK 11](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) `.tar.gz` file and drop it inside folder `java-11`. 
Build it:

```
$ cd java-11
$ docker build -t oracle/jdk:11 .

# or use

$ cd java-11
$ ./buildDockerImage.sh
```
