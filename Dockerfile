FROM java:7
MAINTAINER SequenceIQ

ENV UAA_CONFIG_PATH /uaa
ENV CATALINA_HOME /tomcat

ADD run.sh /tmp/
ADD dev.yml /uaa/uaa.yml
RUN chmod +x /tmp/run.sh

RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz
RUN wget -qO- https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz.md5 | md5sum -c -

RUN tar zxf apache-tomcat-7.0.55.tar.gz
RUN rm apache-tomcat-7.0.55.tar.gz

RUN mkdir /tomcat
RUN mv apache-tomcat-7.0.55/* /tomcat
RUN rm -rf /tomcat/webapps/*

ADD cloudfoundry-identity-uaa-1.8.1.war /tomcat/webapps/
RUN mv /tomcat/webapps/cloudfoundry-identity-uaa-1.8.1.war /tomcat/webapps/ROOT.war

VOLUME ["/uaa"]

EXPOSE 8080

CMD ["/tmp/run.sh"]
