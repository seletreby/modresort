# Generated by IBM TransformationAdvisor
# Sat Mar 16 09:27:42 UTC 2019


#IMAGE: Get the base image for Liberty
FROM websphere-liberty:webProfile7

USER root
#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
COPY Dockerfile ./binary/application/* /config/apps/


#FEATURES: Install any features that are required
RUN apt-get update && apt-get dist-upgrade -y \
&& rm -rf /var/lib/apt/lists/* 
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense defaultServer


# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi

USER 1001
