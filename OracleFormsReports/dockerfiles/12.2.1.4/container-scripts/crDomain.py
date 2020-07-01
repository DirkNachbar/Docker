#!/usr/bin/python

# Things to do:
# Logausgabe in File via redirect()

import os, sys
v_asName=os.environ['AS_NAME']
v_asUser=os.environ['ADM_USER']
v_webpw=os.environ['ADM_PWD']
v_adminport=os.environ['ADMINPORT']
v_adminportssl=os.environ['ADMINPORTSSL']
v_domainName=os.environ['DOMAIN_NAME']
v_template=os.environ['TEMPLATE']
v_javaHome=os.environ['JAVA_HOME']
v_fads=os.environ['FADS12C']
v_setup_domain_base=os.environ['DOMAIN_BASE']
v_setup_application_base=os.environ['APPLICATION_BASE']
v_OracleHome=os.environ['INT_ORACLE_HOME']
v_dbhost=os.environ['DB_HOST']
v_dbport=os.environ['DB_PORT']
v_dbservice=os.environ['DB_SERVICE']
v_rcudbstr=v_dbhost+":"+v_dbport+":"+v_dbservice
v_SchemaPrefix=os.environ['SCHEMA_PREFIX']
v_pwdfile=os.environ['PWDFILE']
v_dbUser=os.environ['DBUSER']
v_dbPwd=os.environ['DBPWD']
v_dbRole=os.environ['DBROLE']
v_dbOmf=os.environ['DB_OMF']
v_componentPassword=os.environ['COMPONENTPWD']

def printHeader(headerText):
    print "\n======================================================================================"
    print "--> "+headerText
    print "======================================================================================\n"

def printInfo(infoText):
    print "-->: "+infoText

printHeader("Started: crDomain.py")
if v_fads == "true":
   printInfo("FADS selected => AdminServer needs to be aligned to AdminServer !!")
   v_asName='AdminServer'


printHeader("Create password file")
os.system("echo "+v_dbPwd+">"+v_pwdfile)
os.system("echo " +v_componentPassword+ ">>"+v_pwdfile)
os.system("echo " +v_componentPassword+ ">>"+v_pwdfile)
os.system("echo " +v_componentPassword+ ">>"+v_pwdfile)
os.system("echo " +v_componentPassword+ ">>"+v_pwdfile)
os.system("echo " +v_componentPassword+ ">>"+v_pwdfile)

printHeader("Step: create repository - started")
printInfo("Drop repository "+v_SchemaPrefix)
os.system(v_OracleHome + "/oracle_common/bin/rcu -silent -dropRepository -databaseType ORACLE -connectString "+ v_rcudbstr +" -dbUser "+v_dbUser+" -dbRole "+v_dbRole+" -schemaPrefix "+v_SchemaPrefix+" -component STB -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component MDS -component UCSUMS -f <"+v_pwdfile)
printInfo("Repository "+v_SchemaPrefix+" dropped")

printInfo("Create repository "+v_SchemaPrefix+" - started")
os.system(v_OracleHome + "/oracle_common/bin/rcu -silent -createRepository -honorOMF "+ v_dbOmf +" -connectString "+ v_rcudbstr +" -dbUser "+v_dbUser+" -dbRole "+v_dbRole+" -useSamePasswordForAllSchemaUsers true -schemaPrefix "+v_SchemaPrefix+" -component STB -component IAU -component IAU_APPEND -component IAU_VIEWER -component OPSS -component MDS -component UCSUMS -f < "+v_pwdfile)
printInfo("Repository "+v_SchemaPrefix+" created")

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

printHeader("Step: Prepare Domain --> Set JAVA_HOME in Domain")
setOption('JavaHome',v_javaHome)
printInfo("Step: Set JAVA_HOME in Domain --> Successful")

printHeader("Step: writeDomain and closeTemplate")
writeDomain(v_setup_domain_base+'/'+v_domainName)
closeTemplate()
printInfo("Step: writeDomain and closeTemplate --> Successful")

printHeader("Finished: crDomain.py")
