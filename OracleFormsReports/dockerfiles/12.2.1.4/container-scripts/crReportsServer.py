#!/usr/bin/python

import os, sys
v_asUser=os.environ['ADM_USER']
v_asPw=os.environ['ADM_PWD']
v_adminport=os.environ['ADMINPORT']
v_as_host=os.environ['AS_HOST']
v_rep_server_name=os.environ['REP_SERVER_NAME']

connect(v_asUser,v_asPw, v_as_host+':'+v_adminport)

createReportsServerInstance(instanceName=v_rep_server_name,machine='AdminServerMachine')

