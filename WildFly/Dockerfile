#=========================================================
#
# Author: Dirk Nachbar
#

# Use latest jboss/base-jdk:11 image as the base
FROM jboss/base-jdk:11

# Maintainer
# # ----------
MAINTAINER Dirk Nachbar <dirk.nachbar@trivadis.com>

# Set the WILDFLY_VERSION env variable
ARG WILDFLY_ADMIN_PWD=admin
ENV ADMIN_PWD=$WILDFLY_ADMIN_PWD
ENV WILDFLY_VERSION 16.0.0.Final
ENV WILDFLY_SHA1 287c21b069ec6ecd80472afec01384093ed8eb7d
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# Adding the Oracle JDBC Driver
# Adding cli script oracle-driver.cli for adding Oracle JDBC Driver to WildFly
# Adding script oracle-config.sh to execute cli script oracle-driver.cli
ADD ojdbc8.jar $JBOSS_HOME
ADD oracle-driver.cli $JBOSS_HOME/bin
ADD oracle-config.sh $JBOSS_HOME

#ADD node-info.war /opt/jboss/wildfly/standalone/deployments/

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Add an admin user to Wildfly
RUN /opt/jboss/wildfly/bin/add-user.sh admin $ADMIN_PWD --silent

# Execute the oracle-config.sh to add the Oracle JDBC Driver
RUN $JBOSS_HOME/oracle-config.sh

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

