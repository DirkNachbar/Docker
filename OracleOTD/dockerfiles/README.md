How to build the image
======================
Before you Start
----------------
1. **FIRST TIME ONLY:**
   - Update the `OracleOTD/setenv.sh` file to point
     to the right locations for the following environment variables
     specific to your environment (See top of file):    
     `DC_USERHOME`, `DC_REGISTRY_OTD`
     and nearly at the bottom:
     `DC_OTD_CONFIGNAME`, `DC_OTD_SERVERNAME`, `DC_OTD_SERVERPORT`, `DC_OTD_ORIGINSERVER`

Oracle Traffic Director Image
-------------------------
1. You must have the install binary downloaded from the
   [Oracle Technology Network](http://www.oracle.com/technetwork/middleware/otd/downloads/index.html) site before proceeding. 
   Unzip the installation zip file
   Drop the install binary into the subdirectory 12.2.1.3
2. From the current directory run these commands. You will 
   be prompted with all the information. Carefully review 
   it and Confirm to proceed. 

       # Use BUILD_OPTS to add extra arguments to the docker build command
       sh buildDockerImage.sh -v 12.2.1.3
