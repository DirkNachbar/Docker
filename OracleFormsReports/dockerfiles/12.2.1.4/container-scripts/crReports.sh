#!/bin/bash
#
#
#
#

echo "===================================================="
echo "Program : crReports.sh                      ........"
echo "===================================================="

# Check if the required Environment Variable for Reports Configuration
if [ "${REPORTS12C}" == "true" ]; then
   export CONFIG_JVM_ARGS=-Djava.security.egd=file:/dev/./urandom:$CONFIG_JVM_ARGS
   ${WLST_HOME}/wlst.sh ${SCRIPT_HOME}/crRepTool.py
   ${WLST_HOME}/wlst.sh ${SCRIPT_HOME}/crReportsServer.py
fi

