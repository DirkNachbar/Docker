#!/usr/bin/python

# Things to do:
#

import os, sys
v_asUser=os.environ['ADM_USER']
v_webpw=os.environ['ADM_PWD']
#v_adminurl=os.environ['AS_HOST']:os.environ['ADMINPORT']
v_adminport=os.environ['ADMINPORT']
v_as_host=os.environ['AS_HOST']
v_ohs_componentname=os.environ['OHS_COMPONENTNAME']
v_ohs_listenport=os.environ['OHS_LISTENPORT']
v_ohs_sslport=os.environ['OHS_SSLPORT']

connect(v_asUser, v_webpw, v_as_host+':'+v_adminport)

ohs_createInstance(instanceName=v_ohs_componentname, machine='AdminServerMachine', listenPort=v_ohs_listenport, sslPort=v_ohs_sslport)

