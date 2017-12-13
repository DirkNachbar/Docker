# Using Docker Compose to orchestrate containers

1. **FIRST TIME ONLY:**
   - Update the `OracleOTD/setenv.sh` file to point
     to the right locations for the following environment variables
     specific to your environment (See top of file):    
     `DC_USERHOME`, `DC_REGISTRY_OTD` and all Oracle Traffic Director specific environment variables `DC_xxx`
   - Create the referenced volume directory on your host (e.g. /opt/oracle/user_projects) and change ownership to oracle:oinstall

         mkdir -p /opt/oracle/oradata
         mkdir -p /opt/oracle/user_projects
         # Make sure that your oracle user on the Docker Host got:
         # uid=54321(oracle) gid=54321(oinstall)
         chown -R oracle:oinstall /opt/oracle/oradata
         chown -R oracle:oinstall /opt/oracle/user_projects
         chmod -R 777 /opt/oracle/oradata
         chmod -R 777 /opt/oracle/user_projects

2. Setup your current environment (running `bash`)

         # cd OracleOTD/samples
         # source ../setenv.sh

4. Starting the Oracle Traffic Director Container. 
   - First Run will create the Forms & Reports schemas, 
   - First Run will create the Domain (Base Domain and extending with Oracle Traffic Director) 
   - Subsequent runs will just start the already configured NodeManager and Admin Server

         docker-compose up -d otdfmw
         docker logs -f otdfmw

5. Starting the Oracle Traffic Director Instance
   - **Ensure that the otdfmw container is up and running**
   - Connect with a browser on your docker host to the forwarded WebLogic AdminServer Port (most likely 7001) to the Enterprise Manager Fusion Middleware Control (http://localhost:7001/em)
     - Go to `Traffic Director` under the Target Navigation, select the pre-configured Instance and use the `Start Instance`button to start your Instance

