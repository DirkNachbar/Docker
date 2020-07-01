#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle FMW Infrastructure 12.2.1.3
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Run:
#      $ docker build -f Dockerfile -t oracle/fmw-infrastructure:12.2.1.3
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile contains a FMW Infra Base Domain.
#
# From
# Full JDK 1.8
# -------------------------
FROM oracle/serverjdk:8

# Maintainer
# ----------
MAINTAINER Dirk Nachbar <https://dirknachbar.blogspot.com>


# Common environment variables required for this build
# ----------------------------------------------------
ENV ORACLE_HOME=/opt/oracle \
    SCRIPT_FILES=/opt/oracle/container-scripts/*.sh \
    USER_MEM_ARGS="-Djava.security.egd=file:/dev/./urandom" \
    DOMAIN_NAME="${DOMAIN_NAME:-InfraDomain}" \
    DOMAIN_HOME=/opt/oracle/user_projects/domains/${DOMAIN_NAME:-InfraDomain} \
    VOLUME_DIR=/opt/oracle/user_projects \
    PATH=$PATH:/usr/java/default/bin:/opt/oracle/oracle_common/common/bin:/opt/oracle/wlserver/common/bin:/opt/oracle/container-scripts


#USER root
# Setup subdirectory for FMW install package and container-scripts
# -----------------------------------------------------------------
RUN mkdir -p /opt && \
    chmod a+xr /opt && \
    useradd -b /opt -d /opt/oracle -m -s /bin/bash oracle && \
    mkdir -p /opt/oracle/container-scripts


# Copy packages and scripts
# -------------
COPY container-scripts/* /opt/oracle/container-scripts/

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV FMW_PKG=fmw_12.2.1.4.0_infrastructure_Disk1_1of1.zip \
    FMW_JAR=fmw_12.2.1.4.0_infrastructure.jar

# Copy packages
# Install the required Packages for Oracle Forms & Reports
# -------------
COPY $FMW_PKG install.file oraInst.loc /opt/
RUN chown oracle:oracle -R /opt && \
    chmod +xr $SCRIPT_FILES && \
    yum install -y binutils compat-libcap1 compat-libstdc++-33.x86_64 compat-libstdc++-33.i686 gcc gcc-c++ glibc.x86_64 glibc.i686 glibc-devel.x86_64 libaio.x86_64 libaio-devel.x86_64 libgcc.x86_64 libgcc.i686 libstdc++.x86_64 libstdc++.i686 libstdc++-devel.x86_64 ksh make sysstat numactl numactl-devel motif motif-devel && \
    ln -s /usr/lib64/libXm.so.4 /usr/lib64/libXm.so.3 && \
    rm -rf /var/cache/yum && \
    mkdir -p $VOLUME_DIR && \
    chown -R oracle:oracle $VOLUME_DIR

VOLUME $VOLUME_DIR


# Install
# ------------------------------------------------------------
USER oracle
RUN  cd /opt && $JAVA_HOME/bin/jar xf /opt/$FMW_PKG && cd - && \
    $JAVA_HOME/bin/java -jar /opt/$FMW_JAR -silent -responseFile /opt/install.file -invPtrLoc /opt/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE="WebLogic Server" && \
    rm /opt/$FMW_JAR /opt/$FMW_PKG /opt/oraInst.loc /opt/install.file

WORKDIR ${ORACLE_HOME}

# Define default command to start script.
CMD ["/opt/oracle/container-scripts/createOrStartInfraDomain.sh"]
