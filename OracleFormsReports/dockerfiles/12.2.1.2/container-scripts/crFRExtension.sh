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
#set -e
set -u

echo "======================================================================================"
echo " Program  : crFRExtension.sh                                    ........"
echo "======================================================================================"

# In case we are facing problems with /dev/random
export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:"$CONFIG_JVM_ARGS"

"${WLST_HOME}/wlst.sh" "${SCRIPT_HOME}/crFRExtension.py"

if [ "${FORMS12C}" == "true" ]; then
  mkdir -p  "${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${FORMS_MS_NAME}/security"
  echo "username=${ADM_USER}" >  "${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${FORMS_MS_NAME}/security/boot.properties"
  echo "password=${ADM_PWD}" >> "${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${FORMS_MS_NAME}/security/boot.properties"
fi


if [ "${REPORTS12C}" == "true" ]; then
  mkdir -p  "${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${REPORTS_MS_NAME}/security"
  echo "username=${ADM_USER}" >  "${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${REPORTS_MS_NAME}/security/boot.properties"
  echo "password=${ADM_PWD}" >> "${DOMAIN_BASE}/${DOMAIN_NAME}/servers/${REPORTS_MS_NAME}/security/boot.properties"
fi

