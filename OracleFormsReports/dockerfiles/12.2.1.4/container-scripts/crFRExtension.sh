#!/bin/bash
#=====================================================================
# 
# $Id: crDomain.sh $
# $Name: basenv-16.05.final.c $ 
#
# PURPOSE: Script to a WebLogic Domain with Forms & Reports
#          Script will be called by crDomain.sh
#
# PARAMETERS: none, all required parameters are taken from setLocalEnv.sh
#
# AUTHOR:  Robert Crames (https://robertcrames.blogspot.com) ,  2017
#
# Modified : Dirk Nachbar (https://dirknachbar.blogspot.com) ,  2017 
#
#
#=====================================================================
echo "======================================================================================"
echo " Program  : crFRExtension.sh                                    ........"
echo "======================================================================================"

     # In case we are facing problems with /dev/random
     export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:$CONFIG_JVM_ARGS
     # Avoiding MDS-11019 error messages with Docker
     #export JAVA_OPTIONS="${JAVA_OPTIONS} -Dfile.encoding=UTF8"
     export CONFIG_JVM_ARGS="${CONFIG_JVM_ARGS} -Dfile.encoding=UTF8"

     # FADS Hack with Docker
     cd ${DOMAIN_BASE}

     ${WLST_HOME}/wlst.sh ${SCRIPT_HOME}/crFRExtension.py 

     if [ "${FORMS12C}" == "true" ]; then
         mkdir -p  ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${MS_NAME4FORMS}/security
         echo "username=${ADM_USER}" >  ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${MS_NAME4FORMS}/security/boot.properties
         echo "password=${ADM_PWD}" >> ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${MS_NAME4FORMS}/security/boot.properties
     fi


     if [ "${REPORTS12C}" == "true" ]; then
        mkdir -p  ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${MS_NAME4REPORTS}/security
        echo "username=${ADM_USER}" >  ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${MS_NAME4REPORTS}/security/boot.properties
        echo "password=${ADM_PWD}" >> ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${MS_NAME4REPORTS}/security/boot.properties
     fi

