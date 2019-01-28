# Start with a base image containing Java runtime
FROM jboss/drools-workbench:latest

# Add Maintainer Info
MAINTAINER Atul Singh Chauhan

####### ENVIRONMENT ############
# Use demo and examples by default in this showcase image (internet connection required).
ENV KIE_SERVER_PROFILE standalone-full-drools
ENV JAVA_OPTS -Xms256m -Xmx2048m -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8

####### Drools Workbench CUSTOM CONFIGURATION ############
#ADD standalone-full-drools.xml $JBOSS_HOME/standalone/configuration/standalone-full-drools.xml

ADD standalone-full-drools.xml /opt/jboss/wildfly/standalone/configuration/standalone-full-drools.xml
#ADD drools-users.properties $JBOSS_HOME/standalone/configuration/drools-users.properties
ADD drools-users.properties /opt/jboss/wildfly/standalone/configuration/drools-users.properties
#ADD drools-roles.properties $JBOSS_HOME/standalone/configuration/drools-roles.properties
ADD drools-roles.properties /opt/jboss/wildfly/standalone/configuration/drools-roles.properties

# Added files are chowned to root user, change it to the jboss one.
USER root
RUN chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-drools.xml && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/drools-users.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/drools-roles.properties

# Switchback to jboss user
USER jboss

####### RUNNING DROOLS-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_drools-wb.sh"]

# Make port 8080 available to the world outside this container
#EXPOSE 8080
