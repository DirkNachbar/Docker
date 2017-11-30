Oracle Fusion Middleware Infrastructure on Docker
=================================================
This Docker configuration has been used to create the Oracle Fusion Middleware Infrastructure image. Providing this FMW image facilitates the configuration, and environment setup for DevOps users.
This Image will be used for the Oracle Forms & Reports 12.2.1.2.0 Image

## How to build and run
This project offers a sample Dockerfile and scripts to build a Oracle Fusion Middleware Infrastructue 12cR2 (12.2.1.x) image. To assist in building the image, you can use the [buildDockerImage.sh](dockerfiles/buildDockerImage.sh) script. See below for instructions and usage.

The `buildDockerImage.sh` script is just a utility shell script that takes the version of the image that needs to be built. Expert users are welcome to directly call `docker build` with their prefered set of parameters.

### Building Oracle JDK base image
You must first download the Oracle JDK 8u151 binary and drop in folder `../OracleJava/java-8` and build that image. For more information, visit the [OracleJava](../OracleJava) folder's [README](../OracleJava/README.md) file.

        $ cd ../OracleJava/java-8
        $ sh build.sh

        
### Building the Oracle FMW Infrastructure 12.2.1.x base image
**IMPORTANT:**If you are building the Oracle FMW Infrastructure image you must first download the Oracle FMW Infrastructure 12.2.1.x binary and drop in folder `../OracleFMWInfrastructure/dockerfiles/12.2.1.2`. 

        $ sh buildDockerImage.sh
        Usage: buildDockerImage.sh -v [version]
        Builds a Docker Image for Oracle FMW Infrastructure.

        Parameters:
           -v: version to build. Required.
           Choose : 12.2.1.2
           -c: enables Docker image layer cache during build
           -s: skips the MD5 check of packages


**IMPORTANT:** the resulting images will have installed the required Oracle WebLogic Infrastructure for the Oracle Forms & Reports 12.2.1.2.0 Image. You must extend the image with the Oracle Forms & Reports Dockerfile and after create the Forms & Reports Domain with the provided docker-compose command.


