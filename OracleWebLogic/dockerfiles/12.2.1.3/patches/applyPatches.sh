#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2017 Oracle and/or its affiliates. All rights reserved.
# 
# Since: January, 2017
# Author: gerald.venzl@oracle.com
# Description: Applies all patches to the Oracle Home
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
# Modified by Dirk Nachbar, Trivadis AG, Switzerland
#   for usage of Oracle WebLogic 12.2.1.3.0 Patching within Docker Image build process


# Switch to Patch Install Directory
cd $PATCH_INSTALL_DIR/

# Loop over all directories (001, 002, 003, ...)
for file in `ls -d */`; do
   # Go into sub directory (cd 001)
   cd $file;
   echo "Extracting patch zip file";
   # Unzip the actual patch (unzip pNNNNNNN.zip)
   $ORACLE_HOME/oracle_common/adr/unzip -o *.zip > /dev/null
   # Go into patch directory (cd NNNNNNN)
   cd */;
   echo "Starting to apply patch";
   # Apply patch
   $ORACLE_HOME/OPatch/opatch apply -silent
   # Get return code
   return_code=$?
   # Error applying the patch, abort
   if [ "$return_code" != "0" ]; then
      exit $return_code;
   fi; 
   # Go back out of patch directory
   cd ../;
   echo "Cleaning up patch directory";
   # Clean up patch directory (-f needed because some files 
   # in patch directory may not have write permissions)
   rm -rf */
   # Delete any xml artifacts if present.
   rm -f *.xml
   # Go back into root directory
   cd ../;
   echo "Done apply patch";
done;

cd /u01

