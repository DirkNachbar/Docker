#!/bin/sh
#
#===============================================
# MUST: Customize this to your local env
#===============================================
#
# Directory where all domains/db data etc are 
# kept. Directories will be created here
export DC_USERHOME=/opt/oracle

# Registry names where requisite standard images
# can be found
export DC_REGISTRY_OTD="localhost"

# Proxy Environment
#export http_proxy=""
#export https_proxy=""
#export no_proxy=""

#===============================================
exportComposeEnv() {
  #
  export DC_HOSTNAME=`hostname -f`
  #
  # AdminServer Password
  #
  export DC_DDIR_OTD=${DC_USERHOME}/user_projects
  export DC_SCRIPT_HOME=/opt/oracle/dockertools
  export DC_INT_ORACLE_HOME=/opt/oracle
  export DC_WL_HOME=${DC_INT_ORACLE_HOME}/wlserver
  export DC_WLST_HOME=${DC_INT_ORACLE_HOME}/oracle_common/common/bin
  export DC_MW=${DC_INT_ORACLE_HOME}
  export DC_DOMAIN_BASE=${DC_INT_ORACLE_HOME}/user_projects/domains
  export DC_APPLICATION_BASE=${DC_INT_ORACLE_HOME}/user_projects/applications
  export DC_APP_VZ=${DC_APPLICATION_BASE}
 
  # Domain specific
  export DC_TEMPLATE=${DC_WL_HOME}/common/templates/wls/wls.jar
  export DC_DOMAIN_NAME=OTDDOMAIN
 
  # AdminServer
  export DC_AS_NAME=${DC_DOMAIN_NAME}AdminServer
  export DC_ADM_USER=weblogic
  export DC_ADM_PWD=welcome1
  export DC_ADMINPORT=7001 
  export DC_ADMINPORTSSL=7101
  export DC_AS_HOST=`hostname -f`
  export DC_MACHINE_NAME=`hostname -s`
 
  # NodeManager
  export DC_NM_LISTENADDRESS=`hostname -f`
  export DC_NM_TYPE=SSL
  export DC_NM_PORT=5556
  export DC_NM_USERNAME=nodemanager
  export DC_NM_PWD=welcome1
 
  # OTD Configuration
  # Change to your required settings
  export DC_OTD_CONFIGNAME=test
  export DC_OTD_SERVERNAME=myserver
  export DC_OTD_SERVERPORT=7777
  export DC_OTD_ORIGINSERVER=weblogic122130:7003

  #
  # Default version to use for compose images
  #
  export DC_OTD_VERSION=12.2.1.3
}


#===============================================
#== MAIN starts here
#===============================================
#
echo "INFO: Setting up Oracle Traffic Director Docker Environment..."
exportComposeEnv
#echo "INFO: Environment variables"
#env | grep -e "DC_" | sort
