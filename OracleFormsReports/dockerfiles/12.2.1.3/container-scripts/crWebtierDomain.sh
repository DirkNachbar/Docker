#!/bin/bash
#=====================================================================
#
# $Id: crWebtierDomain.sh $
# $Name: crWebtierDomain.sh
#
# PURPOSE: Script to configure Oracle HTTP Server for Oracle Forms & Reports
#
# PARAMETERS: none, all required parameters are taken from setLocalEnv.sh
#
# AUTHOR:  Dirk Nachbar (https://dirknachbar.blogspot.com) ,  2017
#
# Modified : 
#
#
#=====================================================================


echo "======================================================================================"
echo " Program  : crWebtierDomain.sh                                                ........"
echo "======================================================================================"

# Check the required Environment Variables for OHS COnfiguration
if [  -z "${OHS_COMPONENTNAME}"  -o -z "${OHS_LISTENPORT}" -o -z "${OHS_SSLPORT}" ]; then
   echo "Environment not set - Exit"
   exit 1
fi

# In case we are facing problems with /dev/random
export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:$CONFIG_JVM_ARGS

${WLST_HOME}/wlst.sh ${SCRIPT_HOME}/crWebtierDomain.py


echo "======================================================================================"
echo "Starting newly create OHS Component ${OHS_COMPONENTNAME} "
echo "======================================================================================"

echo ${NM_PWD} | ${DOMAIN_BASE}/${DOMAIN_NAME}/bin/startComponent.sh ${OHS_COMPONENTNAME} storeUserConfig

