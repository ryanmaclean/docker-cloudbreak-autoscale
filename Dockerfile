FROM java:openjdk-8
MAINTAINER Hortonworks

# Install starter script for the Periscope application
COPY bootstrap/start_periscope_app.sh /start_periscope_app.sh

# Install zip
RUN apt-get update
RUN apt-get install zip

ENV VERSION 2.6.0-dev.10
# install the periscope app
ADD https://cloudbreak-maven.s3.amazonaws.com/releases/com/sequenceiq/periscope/$VERSION/periscope-$VERSION.jar /periscope.jar

# add jmx exporter
ADD jmx_prometheus_javaagent-0.10.jar /jmx_prometheus_javaagent.jar

# extract schema files
RUN ( unzip periscope.jar schema/* -d / ) || \
    ( unzip periscope.jar BOOT-INF/classes/schema/* -d /tmp/ && mv /tmp/BOOT-INF/classes/schema/ /schema/ )

WORKDIR /

ENTRYPOINT ["/start_periscope_app.sh"]
