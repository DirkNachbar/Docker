#!/bin/bash
#
# Name:    buildDockerImage.sh
#
# Purpose: Builds an Oracle Forms & Reports Docker Image
#
# Author:  Dirk Nachbar https://dirknachbar.blogspot.com
#
#=============================================================
usage() {
cat << EOF

Usage: buildDockerImage.sh -v [version]

Builds a Docker Image for Oracle Forms & Reports
Parameters:
   -h: view usage
   -v: Release version to build. Required. Allowed values are
       12.2.1.2, 12.2.1.3, 12.2.1.4
   -s: Skip checksum verification

EOF
exit 0
}

#=============================================================
checkFilePackages() {
  echo "INFO: Checking if required packages are present..."

if [ "${DC_FADS12C}" == "false" ]; then
  jarList=`grep -v -e "^#.*" install/formsreports.download | awk '{print $2}'`
  for jar in ${jarList}; do
     if [ -s ${jar} ]; then
       echo "INFO:   ${jar} found. Proceeding..."
     else
       cat > /dev/stderr <<EOF

ERROR: Install Distribution ${jar} not found in
  `pwd`
  The following are required to proceed.
EOF
       cat install/formsreports.download
       exit 1
     fi
  done
fi

if [[ "${DC_FADS12C}" == "true"  &&  "${VERSION}" =~ 12.2.1.[34] ]]; then
  jarList=`grep -v -e "^#.*" install/formsreports_fads.download | awk '{print $2}'`
  for jar in ${jarList}; do
     if [ -s ${jar} ]; then
       echo "INFO:   ${jar} found. Proceeding..."
     else
       cat > /dev/stderr <<EOF

ERROR: Install Distribution ${jar} not found in
  `pwd`
  The following are required to proceed.
EOF
       cat install/formsreports_fads.download
       exit 1
     fi
  done
fi
}

#=============================================================
checksumPackages() {
  if [ "${SKIPMD5}" -eq 1 ]; then
    echo "INFO: Skipped MD5 checksum as requested"
    return
  fi

  echo "INFO: Checking if required packages are valid..."

  md5sum --quiet -c install/formsreports.download 2> /dev/null
  if [ "$?" -ne 0 ]; then
    cat <<EOF

ERROR: MD5 for required packages to build the ${VERSION} 
       image did not match. Please make sure to download
       or check the files in the ${VERSION} folder.
EOF
    cat install/formsreports.download
    echo " "
    exit $?
  fi
}

#=============================================================
#== MAIN starts here...
#=============================================================
VERSION="NONE"
SKIPMD5=0
while getopts "hsv:" optname; do
  case "$optname" in
    "h")
      usage
      ;;
    "s")
      SKIPMD5=1
      ;;
    "v")
      VERSION="$OPTARG"
      ;;
    *)
      # Should not occur
      echo "ERROR: Invalid argument. buildDockerImage.sh"
      ;;
  esac
done

if [ "${VERSION}" = "NONE" ]; then
  usage
fi

. ../setenv.sh

versionOK=false
if [[ "${VERSION}" =~ 12.2.1.[2-4] ]]
then
  IMAGE_NAME="${DC_REGISTRY_FR}/oracle/formsreports:$VERSION"
  if [ "${DC_FADS12C}" == "false" ]; then
     DOCKERFILE_NAME=Dockerfile
  else
     DOCKERFILE_NAME=Dockerfile_fads
  fi
  versionOK=true
  THEDIR=${VERSION}
fi

if [ "${versionOK}" = "false" ]; then
  echo "ERROR: Incorrect version ${VERSION} specified"
  usage
else
  if [ ! -d ${THEDIR} ]; then
    echo "ERROR: Incorrect version ${THEDIR} directory not found"
    usage
  fi
fi

# Go into version folder
cd ${THEDIR}

checkFilePackages
checksumPackages

# Proxy settings - Set your own proxy environment
if [ "${http_proxy}" != "" ]; then
  PROXY_SETTINGS="--build-arg http_proxy=${http_proxy}"
fi

if [ "${https_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg https_proxy=${https_proxy}"
fi

if [ "${no_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg no_proxy=${no_proxy}"
fi

# ################## #
# BUILDING THE IMAGE #
# ################## #
buildCmd="docker build $BUILD_OPTS --force-rm=true $PROXY_SETTINGS -t $IMAGE_NAME -f $DOCKERFILE_NAME ."

cat > /dev/stdout <<EOF

General Information:
====================
INFO: Image Name : $IMAGE_NAME
INFO: Proxy      : $PROXY_SETTINGS
INFO: Build Opts : ${BUILD_OPTS}
INFO: Current Dir: ${THEDIR}
INFO: Build Command
${buildCmd}

EOF

# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
${buildCmd} || {
  echo "ERROR: There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
  cat << EOF
INFO: Oracle Forms & Reports Docker Image for version: $VERSION 
      is ready to be extended.
      --> $IMAGE_NAME
INFO: Build completed in $BUILD_ELAPSED seconds.

EOF
else
  echo "ERROR: Oracle Forms & Reports Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi
