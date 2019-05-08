#!/bin/sh
#
# Name:    buildDockerImage.sh
#
# Purpose: Builds an Oracle Server JRE 1.8 Docker Image
#
# Author:  Dirk Nachbar https://dirknachbar.blogspot.com
#
#=============================================================

docker build -t oracle/serverjre:8 .

