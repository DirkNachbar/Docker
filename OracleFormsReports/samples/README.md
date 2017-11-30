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

