FROM tomcat:9.0.34-jdk14-openjdk-slim-buster
MAINTAINER Cloudera

ENV UAA_CONFIG_PATH /uaa

ADD run.sh /tmp/
ADD conf/dev.yml /uaa/uaa.yml
RUN chmod +x /tmp/run.sh

RUN apt-get update -y && apt-get install -y unzip
RUN rm -rf $CATALINA_HOME/webapps/*

ADD dist/cloudfoundry-identity-uaa-74.17.0.war $CATALINA_HOME/webapps/
RUN mv $CATALINA_HOME/webapps/cloudfoundry-identity-uaa-74.17.0.war $CATALINA_HOME/webapps/ROOT.war

RUN mkdir -p $CATALINA_HOME/webapps/ROOT && cd $CATALINA_HOME/webapps/ROOT && unzip ../ROOT.war
ADD conf/log4j2.properties $CATALINA_HOME/webapps/ROOT/WEB-INF/classes/log4j2.properties
RUN rm -rf $CATALINA_HOME/webapps/ROOT.war

#VOLUME ["/uaa"]

# add jmx exporter
ADD dist/jmx_prometheus_javaagent-0.10.jar /jmx_prometheus_javaagent.jar
ADD conf/jmx-config.yaml /jmx-config.yaml

EXPOSE 8080

CMD ["/tmp/run.sh"]
