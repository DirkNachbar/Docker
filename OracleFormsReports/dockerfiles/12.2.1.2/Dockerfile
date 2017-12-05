#
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle Forms & Reports 12.2.1.2.0
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# See formsreports.download file in the install directory
#
# Pull base image
# ---------------
FROM oracle/fmw-infrastructure:12.2.1.2
#
# Maintainer
# ----------
MAINTAINER Dirk Nachbar <https://dirknachbar.blogspot.com>
#
# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
USER root
ENV FMW_BIN=fmw_12.2.1.2.0_fr_linux64.bin 

#
# Copy files and packages for install
# -----------------------------------
ADD  $FMW_BIN /opt/
COPY container-scripts/* /opt/oracle/dockertools/
RUN  cd /opt && chmod 755 *.bin && \
     chmod a+xr /opt/oracle/dockertools/*.*
#
USER oracle
COPY install/* /opt/
RUN cd /opt && \
  ./$FMW_BIN -silent -responseFile /opt/formsreports.response -invPtrLoc /opt/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME && \
  rm -fr /opt/*.bin /opt/*.response /opt/*.loc

VOLUME ["/opt/oracle/user_projects"]
#
# Define default command to start bash.
#
WORKDIR $ORACLE_HOME
CMD ["/opt/oracle/dockertools/crDomain.sh"]
