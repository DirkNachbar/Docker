Oracle Forms & Reports on Docker
=====
This github Repository contains all necessary Docker buildfiles to create an Oracle Forms & Reports 12.2.1.2.0 environment under Docker

## Requirements
- Docker Host with Docker 17 or higher
- Docker Compose
- Oracle Database
   - either native running Oracle Database with UNICODE Character Set
   - or Oracle Database on Docker see (https://github.com/oracle/docker-images/tree/master/OracleDatabase)

## How to build
Get a copy of this repository on your Docker host, make sure that your Docker host have either direct Internet Connection or configure a Proxy to be able to run required `yum install` commands inside the Docker build files

Create your Oracle Database which will host the Metadata Repository for the Oracle Forms & Reports environment. I recommend to use the Docker Image from Oracle https://github.com/oracle/docker-images/tree/master/OracleDatabase


