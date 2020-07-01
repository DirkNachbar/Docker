#!/bin/bash

# Copyright (c) 2014-2017 Oracle and/or its affiliates. All rights reserved.
#
#Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
#

export adminhostname=$adminhostname
export adminport=$adminport


# First Update the server in the domain
export server="infra_server1"
export DOMAIN_ROOT="/opt/oracle/user_projects/domains"
export DOMAIN_HOME="/opt/oracle/user_projects/domains/InfraDomain"

echo $adminhostname
echo $adminport
echo "DOMAIN_HOME: $DOMAIN_HOME"

/opt/oracle/oracle_common/common/bin/wlst.sh -skipWLSModuleScanning /opt/oracle/container-scripts/update_listenaddress.py $server
retval=$?

echo  "RetVal from Update listener call  $retval"

if [ $retval -ne 0 ];
then
    echo "Update listener Failed.. Please check the  Logs"
    exit
fi

# Start Infra server
mkdir -p /opt/oracle/logs
$DOMAIN_HOME/bin/startManagedWebLogic.sh $server "http://"$adminhostname:$adminport > /opt/oracle/logs/startManagedWebLogic$$.log 2>&1 &
statusfile=/tmp/notifyfifo.$$

mkfifo "${statusfile}" || exit 1
{
    # run tail in the background so that the shell can kill tail when notified that grep has exited
    tail -f /opt/oracle/logs/startManagedWebLogic$$.log &
    # remember tail's PID
    tailpid=$!
    # wait for notification that grep has exited
    read templine <${statusfile}
                        echo ${templine}
    # grep has exited, time to go
    kill "${tailpid}"
} | {
    grep -m 1 "<Notice> <WebLogicServer> <BEA-000360> <The server started in RUNNING mode.>"
    # notify the first pipeline stage that grep is done
        echo "RUNNING"> /opt/oracle/logs/startManagedWebLogic$$.status
        echo "Infra server is running"
    echo >${statusfile}
}

# clean up
rm "${statusfile}"
if [ -f /opt/oracle/logs/startManagedWebLogic$$.status ]; then
echo "Infra server has been started"
fi

#Display the logs
tail -f $DOMAIN_HOME/servers/infra_server1/logs/infra_server1.log

childPID=$!
wait $childPID
