How to build the image
======================
Before you Start
----------------
1. **FIRST TIME ONLY:**
   - Update the `OracleFormsRepors/setenv.sh` file to point
     to the right locations for the following environment variables
     specific to your environment (See top of file):    
     `DC_USERHOME`, `DC_REGISTRY_FR`, `DC_REGISTRY_DB`    

Forms & Reports Image
-------------------------
1. You must have the install binary downloaded from the
   [Oracle Technology Network](http://www.oracle.com/technetwork/developer-tools/forms/downloads/index.html) site before proceeding. 

   Drop the install binary into the subdirectory 12.2.1.2
2. From the current directory run these commands. You will 
   be prompted with all the information. Carefully review 
   it and Confirm to proceed. 

       # Use BUILD_OPTS to add extra arguments to the docker build command
       sh buildDockerImage.sh -v 12.2.1.2
