# Using Docker Compose to orchestrate containers

1. **FIRST TIME ONLY:**
   - Update the `OracleFormsReports/setenv.sh` file to point
     to the right locations for the following environment variables
     specific to your environment (See top of file):    
     `DC_USERHOME`, `DC_REGISTRY_FR`, `DC_REGISTRY_DB`    

2. Setup your current environment (running `bash`)

       # cd OracleFormsReports/samples
       # source ../setenv.sh

3. Setup and start the Database container
   - Ensure port 1521 is free for use for the database

         netstat -an | grep 1521
   - Start the DB Container

         docker-compose up -d frdb
         docker logs -f frdb

4. Starting the Oracle Forms & Reports Container. 
    - **Ensure Database is up first**
    - First Run will run RCU and create the Forms & Reports schemas, 
      Creates the Domain (Base Domain and extending with Forms & Reports) and starts the 
      NodeManager, AdminServer and Oracle HTTP Server (OHS)
    - Subsequent runs will just start the already configured NodeManager and Admin Server

          docker-compose up -d frfmw
          docker logs -f frfmw
5. Starting the Managed Servers, Oracle HTTP Server and Reports Server
    - **Ensure that the frfmw container is up and running**
    - Connect with a browser on your docker host to the forwarded WebLogic AdminServer Port (most likely 7001) to the Enterprise Manager Fusion Middleware Control (http://localhost:7001/em)
        - Startup the Managed Servers for Forms and Reports and the Oracle HTTP Server
    - For starting up the created Reports Server use following commands:

          docker exec -ti frfmw /bin/bash
          cd /opt/oracle/user_projects/domains/<DOMAIN_NAME>/bin
          ./startComponent.sh <REPORTS_SERVER_NAME>

