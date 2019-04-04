#!/bin/bash

: ${EXPOSE_JMX_METRICS:=false}
: ${EXPOSE_JMX_METRICS_PORT:=20105}
: ${EXPOSE_JMX_METRICS_CONFIG:=/jmx-config.yaml}
: ${EXPOSE_JMX_BIND_ADDRESS:=0.0.0.0}
: ${TRUSTED_CERT_DIR:=/certs}

echo "Importing certificates to the default Java certificate  trust store."

if [ -d "$TRUSTED_CERT_DIR" ]; then
    for cert in $(ls -A "$TRUSTED_CERT_DIR"); do
        if [ -f "$TRUSTED_CERT_DIR/$cert" ]; then
            if keytool -import -alias "$cert" -noprompt -file "$TRUSTED_CERT_DIR/$cert" -keystore /etc/ssl/certs/java/cacerts -storepass changeit; then
                echo -e "Certificate added to default Java trust store with alias $cert."
            else
                echo -e "WARNING: Failed to add $cert to trust store.\n"
            fi
        fi
    done
fi

[ -n "$UAA_CONFIG_URL" ] && curl -Lo /uaa/uaa.yml $UAA_CONFIG_URL

if [ "$EXPOSE_JMX_METRICS" == "true" ]; then
  export CATALINA_OPTS="$CATALINA_OPTS -javaagent:/jmx_prometheus_javaagent.jar=$EXPOSE_JMX_BIND_ADDRESS:$EXPOSE_JMX_METRICS_PORT:$EXPOSE_JMX_METRICS_CONFIG"
fi

($CATALINA_HOME/bin/catalina.sh run) & JAVAPID=$!
trap "kill $JAVAPID; wait $JAVAPID" SIGINT SIGTERM
wait $JAVAPID
