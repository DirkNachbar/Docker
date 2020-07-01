#
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle Forms & Reports 12.2.1.3.0 without FADS
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# See formsreports.download file in the install directory
#
# Pull base image
# ---------------
FROM oracle/fmw-infrastructure:12.2.1.4
#
# Maintainer
# ----------
MAINTAINER Dirk Nachbar <https://dirknachbar.blogspot.com>
#
# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
USER root
ENV FMW_BIN=fmw_12.2.1.4.0_fr_linux64.bin
ENV FMW_BIN2=fmw_12.2.1.4.0_fr_linux64-2.zip

#
# Copy files and packages for install
# -----------------------------------
ADD  $FMW_BIN /opt/
ADD  $FMW_BIN2 /opt/
ADD  $SQLDEV /opt/
COPY container-scripts/* /opt/oracle/dockertools/
RUN  cd /opt && chmod 755 *.bin && \
     chmod a+xr /opt/oracle/dockertools/*.*
#
USER oracle
COPY install/* /opt/
RUN cd /opt && \
  ./$FMW_BIN -silent -responseFile /opt/formsreports.response -invPtrLoc /opt/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME && \
  rm -fr /opt/*.bin /opt/*.zip /opt/*.response /opt/*.loc

VOLUME ["/opt/oracle/user_projects"]
#
# Define default command to start bash.
#
WORKDIR $ORACLE_HOME
CMD ["/opt/oracle/dockertools/crDomain.sh"]
