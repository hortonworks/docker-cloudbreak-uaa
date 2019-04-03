FROM openjdk:8u141-jre
MAINTAINER Hortonworks

ENV UAA_CONFIG_PATH /uaa
ENV CATALINA_HOME /tomcat

ADD run.sh /tmp/
ADD conf/dev.yml /uaa/uaa.yml
RUN chmod +x /tmp/run.sh

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz
RUN wget -qO- https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz.md5 | md5sum -c -

RUN tar zxf apache-tomcat-8.0.28.tar.gz
RUN rm apache-tomcat-8.0.28.tar.gz

RUN mkdir /tomcat
RUN mv apache-tomcat-8.0.28/* /tomcat
RUN rm -rf /tomcat/webapps/*

ADD dist/cloudfoundry-identity-uaa-4.19.0.war /tomcat/webapps/
RUN mv /tomcat/webapps/cloudfoundry-identity-uaa-4.19.0.war /tomcat/webapps/ROOT.war

RUN mkdir -p /tomcat/webapps/ROOT && cd /tomcat/webapps/ROOT && unzip ../ROOT.war
ADD conf/log4j.properties /tomcat/webapps/ROOT/WEB-INF/classes/log4j.properties
RUN rm -rf /tomcat/webapps/ROOT.war

#VOLUME ["/uaa"]

# add jmx exporter
ADD dist/jmx_prometheus_javaagent-0.10.jar /jmx_prometheus_javaagent.jar
ADD conf/jmx-config.yaml /jmx-config.yaml

EXPOSE 8080

CMD ["/tmp/run.sh"]
