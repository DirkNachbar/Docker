#!/bin/sh
#
#===============================================
# MUST: Customize this to your local env
#===============================================
#
# Directory where all domains/db data etc are 
# kept. Directories will be created here
export DC_HOST_VOL=/home/<user>/oracle/projects  # CHANGE ME
# The mount point within docker
export DC_USERHOME=/opt/oracle

# Registry names where requisite standard images
# can be found
export DC_REGISTRY_FR="localhost"
export DC_REGISTRY_DB=

# Proxy Environment
#export http_proxy=""
#export https_proxy=""
#export no_proxy=""

#===============================================
exportComposeEnv() {
  #
  export DC_HOSTNAME=`hostname -f`
  #
  # Used by Docker Compose from the env
  # Oracle DB Parameters
  #
  export DC_ORCL_PORT=1521
  export DC_ORCL_OEM_PORT=5500
  export DC_ORCL_SID=frdb
  export DC_ORCL_PDB=frpdb
  export DC_ORCL_SYSPWD=Oracle12c
  export DC_ORCL_HOST=${DC_HOSTNAME}
  #
  export DC_ORCL_DBDATA=${DC_USERHOME}/oradata
  #
  # AdminServer Password
  #
  export DC_DDIR_FR=${DC_USERHOME}/user_projects
  export DC_SCRIPT_HOME=/opt/oracle/dockertools
  export DC_INT_ORACLE_HOME=/opt/oracle
  export DC_WL_HOME=${DC_INT_ORACLE_HOME}/wlserver
  export DC_WLST_HOME=${DC_INT_ORACLE_HOME}/oracle_common/common/bin
  export DC_MW=${DC_INT_ORACLE_HOME}
  export DC_DOMAIN_BASE=${DC_DDIR_FR}/domains
  export DC_APPLICATION_BASE=${DC_DDIR_FR}/applications
  export DC_APP_VZ=${DC_APPLICATION_BASE}

  # install forms true / false
  export DC_FORMS12C=true
  export DC_FADS12C=false
  # install reports true / false
  export DC_REPORTS12C=true
  # install OHS true / false
  export DC_WEBTIER12C=true
  export DC_OHS_COMPONENTNAME=ohs1
  export DC_OHS_LISTENPORT=7777
  export DC_OHS_SSLPORT=4443

  # Domain specific
  export DC_TEMPLATE=${DC_WL_HOME}/common/templates/wls/wls.jar
  export DC_DOMAIN_NAME=FRTEST

  # AdminServer
  export DC_AS_NAME=FRTESTAdminServer
  export DC_ADM_USER=weblogic
  export DC_ADM_PWD=welcome1
  export DC_ADMINPORT=7001
  export DC_ADMINPORTSSL=7101
  export DC_AS_HOST=`hostname -f`

  # Name and Port for the Forms Managed Server
  export DC_FORMS_MS_NAME=MS_FORMS
  export DC_FORMS12C_MS_PORT=9001

  # Name and Port for the Reports Managed Server
  export DC_REPORTS_MS_NAME=MS_REPORTS
  export DC_REPORTS12C_MS_PORT=9002

  # Move Reports Application into WLS_FORMS (true or false)
  export DC_REPORTS_IN_FORMS=false

  # Reports Server Definitions
  export DC_REP_SERVER=true
  export DC_REP_SERVER_NAME=repserver1

  # NodeManager
  export DC_NM_LISTENADDRESS=`hostname -f`
  export DC_NM_TYPE=SSL
  export DC_NM_PORT=5556
  export DC_NM_USERNAME=nodemanager
  export DC_NM_PWD=welcome1

  # Repository Connect
  export DC_DBUSER=sys
  export DC_DBPWD=Oracle12c
  export DC_DBROLE=SYSDBA
  export DC_COMPONENTPWD=Oracle12c
  export DC_SCHEMA_PREFIX=${DC_DOMAIN_NAME}
  export DC_DB_HOST=172.17.0.1
  export DC_DB_PORT=${DC_ORCL_PORT}
  export DC_DB_SERVICE=${DC_ORCL_PDB}
  export DC_DB_OMF=false
  export DC_DB_USER_PW=Oracle12c
  export DC_PWDFILE=/tmp/passwords.txt

  #
  # Default version to use for compose images
  #
  export DC_FR_VERSION=12.2.1.2
}

#===============================================
createDirs() {

if [ -d "${DC_ORCL_DBDATA}" ]; then
   mkdir -p ${DC_ORCL_DBDATA}
   chmod 777 ${DC_ORCL_DBDATA}
fi

if [ -d "${DC_DDIR_FR}" ]; then
   mkdir -p ${DC_DDIR_FR}
   chmod 777 ${DC_DDIR_FR}
fi

}

#===============================================
#== MAIN starts here
#===============================================
#
echo "INFO: Setting up Forms & Reports Docker Environment..."
exportComposeEnv
# createDirs
#echo "INFO: Environment variables"
#env | grep -e "DC_" | sort
