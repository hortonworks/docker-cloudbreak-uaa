#!/bin/bash

: ${EXPOSE_JMX_METRICS:=false}
: ${EXPOSE_JMX_METRICS_PORT:=20105}
: ${EXPOSE_JMX_METRICS_CONFIG:=/jmx-config.yaml}
: ${EXPOSE_JMX_BIND_ADDRESS:=0.0.0.0}

[ -n "$UAA_CONFIG_URL" ] && curl -Lo /uaa/uaa.yml $UAA_CONFIG_URL

if [ "$EXPOSE_JMX_METRICS" == "true" ]; then
  export CATALINA_OPTS="$CATALINA_OPTS -javaagent:/jmx_prometheus_javaagent.jar=$EXPOSE_JMX_BIND_ADDRESS:$EXPOSE_JMX_METRICS_PORT:$EXPOSE_JMX_METRICS_CONFIG"
fi

($CATALINA_HOME/bin/catalina.sh run) & JAVAPID=$!
trap "kill $JAVAPID; wait $JAVAPID" SIGINT SIGTERM
wait $JAVAPID
