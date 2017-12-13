#!/bin/bash
#=====================================================================
# 
# $Id: crDomain.sh $
# $Name: crDomain.sh
#
# PURPOSE: Script to create an Oracle Traffic Director WebLogic Domain
#          Updated Version only to be used with Docker !!!!
#
# PARAMETERS: none
#
# AUTHOR    : Dirk Nachbar (https://dirknachbar.blogspot.com) ,  2017 
#
#
#=====================================================================
# set -x

# Set Start Time
start_time=$(date +%s)

echo "Building Oracle Traffic Director Domain: ${DOMAIN_NAME}"

function warten
{
echo " "
echo "ENTER to proceed ..."
read
echo "The Installation Process is started ..."
}

echo "======================================================================================"
echo " Program  : crDomain.sh                                                ........"
echo "======================================================================================"

if [ -z "${WLST_HOME}" ]; then
    echo "Environment not correctly set - please verify"
    exit 1
fi

if ! test -d "${DOMAIN_BASE}/${DOMAIN_NAME}"; then
   echo "=================================================="
   echo "Domain will be installed ..."
   echo "=================================================="
   if [  -z "${ADM_PWD}"  -o -z "${TEMPLATE}" -o -z "${ADMINPORT}" -o -z "${MW}" -o -z "${ADMINPORTSSL}" -o -z " ${DOMAIN_NAME}" ]; then
      echo "Environment not set - Exit"
      exit 1
   fi

   # In case we are facing problems with /dev/random
   export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:$CONFIG_JVM_ARGS
   # Avoiding MDS-11019 error messages
   export JAVA_OPTIONS="${JAVA_OPTIONS} -Dfile.encoding=UTF8"

   ${WLST_HOME}/wlst.sh ${SCRIPT_HOME}/crDomain.py 

   mkdir -p  ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${AS_NAME}/security
   echo "username=${ADM_USER}" >  ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${AS_NAME}/security/boot.properties
   echo "password=${ADM_PWD}" >> ${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${AS_NAME}/security/boot.properties


      finish_time=$(date +%s)
      echo "Finished"
      echo "Domain Build Time: $(( $((finish_time - start_time))/60))  minutes."
   else
      # Docker Hack, if Domain is already created (first run), we will be here
      # and can startup the Forms & Reports Domain
      # In case we are facing problems with /dev/random
      export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:$CONFIG_JVM_ARGS
      # Avoiding MDS-11019 error messages
      export JAVA_OPTIONS="${JAVA_OPTIONS} -Dfile.encoding=UTF8"
      # Startup the Node Manager and AdminServer
      echo "Domain is already installed and will be started..."
      nohup ${DOMAIN_BASE}/${DOMAIN_NAME}/bin/startNodeManager.sh > /dev/null 2>&1 &
      echo "Wait 30 seconds for Node Manager to start ..."
      sleep 30
      ${DOMAIN_BASE}/${DOMAIN_NAME}/startWebLogic.sh
   fi


