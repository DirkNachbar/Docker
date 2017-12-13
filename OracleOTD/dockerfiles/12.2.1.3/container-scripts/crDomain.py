#!/usr/bin/python
 
# Things to do:
# Log output in File via redirect()
 
import os, sys
v_asName=os.environ['AS_NAME']
v_asUser=os.environ['ADM_USER']
v_webpw=os.environ['ADM_PWD']
v_adminport=os.environ['ADMINPORT']
v_adminportssl=os.environ['ADMINPORTSSL']
v_domainName=os.environ['DOMAIN_NAME']
v_template=os.environ['TEMPLATE']
v_javaHome=os.environ['JAVA_HOME']
v_setup_domain_base=os.environ['DOMAIN_BASE']
v_setup_application_base=os.environ['APPLICATION_BASE']
v_OracleHome=os.environ['INT_ORACLE_HOME']
v_MachineName=os.environ['MACHINE_NAME']
v_nmListenAddress=os.environ['NM_LISTENADDRESS']
v_nmPort=os.environ['NM_PORT']
v_nmUserName=os.environ['NM_USERNAME']
v_nmPwd=os.environ['NM_PWD']
v_otdTemplate=os.environ['TEMPLATE']
v_otdConfigName=os.environ['OTD_CONFIGNAME']
v_otdServerPort=os.environ['OTD_SERVERPORT']
v_otdServerName=os.environ['OTD_SERVERNAME']
v_otdOriginServer=os.environ['OTD_ORIGINSERVER']
 
def printHeader(headerText):
    print "\n======================================================================================"
    print "--> "+headerText
    print "======================================================================================\n"
 
def printInfo(infoText):
    print "-->: "+infoText
 
printHeader("Started: crDomain.py")
 
printHeader("Step: Read default template (always wls.jar!!)")
readTemplate(v_template)
printInfo("Template: "+v_template+" successfully read")   
 
printHeader("Step: Prepare Domain --> Set Domain Name to "+v_domainName)
cd('/')
cmo.setName(v_domainName)
printInfo("Step: Set Domain Name --> Successful")
 
printHeader("Step: Prepare Domain --> Set User Password")
cd('/')
cd('/Security/'+v_domainName+'/User/'+v_asUser)
cmo.setPassword(v_webpw)
printInfo("Step: Set User Password --> Successful")
 
printHeader('Step: Prepare Domain --> Set AdminServer Name ('+v_asName+') and Port ('+v_adminport+')')
cd('/')
cd('/Server/AdminServer')
cmo.setName(v_asName)
cd('/')
cd('/Server/'+v_asName)
cmo.setListenPort(int(v_adminport))
printInfo("Step: Set AdminServer Name --> Successful")
 
printHeader("Step: Prepare Domain --> Set Domain Properties")
setOption('OverwriteDomain', 'true')
setOption('ServerStartMode','prod')
printInfo("Step: Set Domain Properties --> Successful")
 
printHeader("Step: Prepare Domain --> Align NodeManager")
cd('/NMProperties')
set('ListenAddress',v_nmListenAddress)
set('ListenPort',int(v_nmPort))
set('CrashRecoveryEnabled', 'true')
set('NativeVersionEnabled', 'true')
set('StartScriptEnabled', 'false')
set('SecureListener', 'true')
set('LogLevel', 'INFO')
 
cd('/SecurityConfiguration/base_domain')
set('NodeManagerUsername', v_nmUserName)
set('NodeManagerPasswordEncrypted', v_nmPwd)
printInfo("Step: Align NodeManager --> Successful")
 
 
printHeader("Step: Prepare Domain --> Set JAVA_HOME in Domain")
setOption('JavaHome',v_javaHome)
printInfo("Step: Set JAVA_HOME in Domain --> Successful")
 
printHeader("Step: writeDomain and closeTemplate")
writeDomain(v_setup_domain_base+'/'+v_domainName)
closeTemplate()
 
readDomain(v_setup_domain_base+'/'+v_domainName)
 
printHeader('Step: Create Unix Machine --> Set Machine Name ('+v_MachineName+') and Port ('+v_nmPort+')')
cd('/')
create(v_MachineName, 'UnixMachine')
cd('Machine/' + v_MachineName)
create(v_MachineName, 'NodeManager')
cd('NodeManager/'+v_MachineName)
set('ListenAddress', v_nmListenAddress)
set('ListenPort',int(v_nmPort))
set('NMType','ssl')
 
cd('/Servers/'+v_asName)
set('Machine',v_MachineName)
printInfo("Step: Create Unix Machine --> Successful")
updateDomain()
closeDomain()
 
readDomain(v_setup_domain_base+'/'+v_domainName)
printHeader('Step: Include OTD template')
selectTemplate('Oracle Traffic Director - Restricted JRF','12.2.1.3.0')
loadTemplates()
printInfo('Step: Include OTD template --> Successful')
updateDomain()
closeDomain()
printInfo("Step: writeDomain and closeTemplate --> Successful")
 
printHeader('Step: Creating OTD Instance')
readDomain(v_setup_domain_base+'/'+v_domainName)
props = {}
props['configuration'] = v_otdConfigName
props['listener-port'] = v_otdServerPort
props['server-name'] = v_otdServerName
props['origin-server'] = v_otdOriginServer
otd_createConfiguration(props)
updateDomain()
closeDomain()
 
readDomain(v_setup_domain_base+'/'+v_domainName)
props = {}
props['configuration'] = v_otdConfigName
props['machine'] = v_MachineName
otd_createInstance(props)
updateDomain()
closeDomain()
printInfo('Step: Creating OTD Instance --> Successful')
 
printHeader("Finished: crDomain.py")

