# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# ORACLE DOCKERFILES PROJECT
# --------------------------
# This is the Dockerfile for Oracle Database 18c Express Edition
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) oracle-database-xe-18c-1.0-1.x86_64.rpm
#     Download Oracle Database Express Edition (XE) Release 18.4.0.0.0 (18c) for Linux x64
#     from https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put the downloaded file in the same directory as this Dockerfile
# Run: 
#      $ docker build -t oracle/database:18.4.0-xe -f Dockerfile.xe .
#
#
# Pull base image
# ---------------
FROM oraclelinux:7-slim as base

# Maintainer
# ----------
LABEL maintainer="dirk.nachbar@trivadis.com"

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
    ORACLE_SID=XE \
    INSTALL_FILE_1="oracle-database-xe-18c-1.0-1.x86_64.rpm" \
    RUN_FILE="runOracle.sh" \
    PWD_FILE="setPassword.sh" \
    CONF_FILE="oracle-xe-18c.conf" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    INSTALL_DIR="$HOME/install" \
    ORACLE_DOCKER_INSTALL="true" \
    NLS_LANG=AMERICAN_AMERICA.AL32UTF8 \
    CUSTOM_SQL="custom.zip"

# Use second ENV so that variable get substituted
ENV PATH=$ORACLE_HOME/bin:$PATH

# Copy binaries to the Image
# -------------
COPY $RUN_FILE $PWD_FILE $CHECK_DB_FILE $INSTALL_DIR/
COPY $CONF_FILE $INSTALL_DIR/

RUN cd $INSTALL_DIR && \
    yum -y install unzip.x86_64 oracle-database-preinstall-18c file openssl && \
    rm -rf /var/cache/yum

#############################################
# -------------------------------------------
# Start new stage for installing the database
# -------------------------------------------
#############################################

FROM base AS builder

# Copy DB install file
COPY $INSTALL_FILE_1 $CUSTOM_SQL $INSTALL_DIR/

# Install DB software rpm
RUN cd $INSTALL_DIR && \
    yum -y install $INSTALL_FILE_1 && \
    rm -rf /var/cache/yum && \
    rm -f $INSTALL_FILE_1 && \
    rm -rf $ORACLE_HOME/demo && \
    rm -rf $ORACLE_HOME/dmu && \
    rm -rf $ORACLE_HOME/javavm && \
    rm -rf $ORACLE_HOME/md && \
    rm -rf $ORACLE_HOME/nls/demo && \
    rm -rf $ORACLE_HOME/odbc && \
    rm -rf $ORACLE_HOME/rdbms/demo && \
    rm -rf $ORACLE_HOME/R && \
    rm -rf $ORACLE_HOME/instantclient && \
    rm -rf $ORACLE_HOME/inventory && \
    rm -rf $ORACLE_HOME/deinstall && \
    rm -r  $ORACLE_HOME/lib/ra_aix_ppc64.zip && \
    rm -r  $ORACLE_HOME/lib/ra_hpux_ia64.zip && \
    rm -r  $ORACLE_HOME/lib/ra_solaris*.zip && \
    rm -f  $ORACLE_HOME/lib/ra_windows64.zip && \
    rm -f  $ORACLE_HOME/lib/ra_zlinux64.zip && \
    rm -rf $ORACLE_HOME/crs && \
    rm -f  $ORACLE_HOME/bin/asmcmd && \
    rm -f  $ORACLE_HOME/bin/asmcmdcore && \
    rm -f  $ORACLE_HOME/bin/bdschecksw && \
    rm -f  £ORACLE_HOME/bin/dbv && \
    rm -f  $ORACLE_HOME/bin/ldap* && \
    rm -f  $ORACLE_HOME/bin/dbfs_client && \
    rm -f  $ORACLE_HOME/bin/afdboot && \
    rm -f  $ORACLE_HOME/bin/exp && \
    rm -f  $ORACLE_HOME/bin/imp && \
    rm -f  $ORACLE_HOME/bin/*.exe && \
    rm -f  $ORACLE_HOME/bin/lcsscan && \
    rm -f  $ORACLE_HOME/bin/dgmgrl && \
    rm -f  $ORACLE_HOME/bin/nid && \
    rm -f  $ORACLE_HOME/bin/orion && \
    rm -f  $ORACLE_HOME/bin/procob && \
    rm -f  $ORACLE_HOME/bin/setasmgid && \
    rm -f  $ORACLE_HOME/bin/wrap && \
    rm -f  $ORACLE_HOME/bin/*0 && \
    rm -f  $ORACLE_HOME/bin/tnsping && \
    rm -f  $ORACLE_HOME/bin/tkprof && \
    rm -f  $ORACLE_HOME/bin/srvctl && \
    rm -f  $ORCALE_HOME/bin/wrc && \
    rm -rf $ORACLE_HOME/sdk && \
    strip --remove-section=.comment $ORACLE_HOME/bin/oracle && \
    strip --remove-section=.comment $ORACLE_HOME/bin/rman && \
    strip --remove-section=.comment $ORACLE_HOME/bin/tnslsnr

#############################################
# -------------------------------------------
# Start new layer for database runtime
# -------------------------------------------
#############################################

FROM base

COPY --chown=oracle:oinstall --from=builder $ORACLE_BASE $ORACLE_BASE
COPY --chown=oracle:oinstall --from=builder $INSTALL_DIR $INSTALL_DIR
COPY --from=builder /etc/init.d/oracle-xe-18c /etc/init.d/oracle-xe-18c

RUN $ORACLE_BASE/oraInventory/orainstRoot.sh && \
    $ORACLE_HOME/root.sh && \
    mkdir -p $ORACLE_BASE/scripts/setup && \
    mkdir $ORACLE_BASE/scripts/startup && \
    ln -s $ORACLE_BASE/scripts /docker-entrypoint-initdb.d && \
    mkdir -p $ORACLE_BASE/oradata $ORACLE_BASE/diag $ORACLE_BASE/fast_recovery_area $ORACLE_BASE/tools /home/oracle && \
    chown -R oracle:oinstall $ORACLE_BASE/oradata $ORACLE_BASE/diag $ORACLE_BASE/fast_recovery_area $ORACLE_BASE/tools /home/oracle && \
    mv $INSTALL_DIR/$RUN_FILE $ORACLE_BASE/ && \
    mv $INSTALL_DIR/$PWD_FILE $ORACLE_BASE/ && \
    mv $INSTALL_DIR/$CHECK_DB_FILE $ORACLE_BASE/ && \
    mv $INSTALL_DIR/$CONF_FILE /etc/sysconfig/ && \
    unzip $INSTALL_DIR/$CUSTOM_SQL -d $ORACLE_BASE/scripts/setup && \
    ln -s $ORACLE_BASE/$PWD_FILE / && \
    cd $HOME && \
    rm -rf $INSTALL_DIR && \
    target_txt=$(cat /etc/security/limits.d/oracle-database-preinstall-18c.conf | grep -e 'oracle *hard *memlock*') && \
    sed -i "/^$target_txt/ c#$target_txt" /etc/security/limits.d/oracle-database-preinstall-18c.conf && \
    chmod ug+x $ORACLE_BASE/*.sh
    

WORKDIR /home/oracle

# Adding VOLUMES for oradata and diag directory
VOLUME ["$ORACLE_BASE/oradata"]
VOLUME ["$ORACLE_BASE/diag"]
VOLUME ["$ORACLE_BASE/fast_recovery_area"]
VOLUME ["$ORACLE_BASE/tools"]
EXPOSE 1521 
HEALTHCHECK --interval=1m --start-period=5m \
   CMD "$ORACLE_BASE/$CHECK_DB_FILE" >/dev/null || exit 1

CMD exec $ORACLE_BASE/$RUN_FILE

