FROM public.ecr.aws/lambda/java:11

ARG FIREFOX_VERSION=100.0
ARG FIREFOXDRIVER_VERSION=0.31.0

RUN yum install -y libidn
RUN yum install -y gzip
RUN yum install -y wget
RUN yum install -y tar
RUN yum install -y p7zip \
    p7zip-full \
    unace \
    zip \
    unzip \
    bzip2

RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2
RUN bunzip2 /tmp/firefox.tar.bz2
RUN tar xvf /tmp/firefox.tar
RUN mv firefox /opt/firefox-$FIREFOX_VERSION
RUN ln -s /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

RUN yum install -y gtk3
RUN yum install -y alsa-lib
RUN yum install -y dbus-glib

#AWS Lambda documentation https://gallery.ecr.aws/lambda/java 

COPY build/classes/java/main ${LAMBDA_TASK_ROOT}
COPY build/dependency/* ${LAMBDA_TASK_ROOT}/lib/

# GECKODRIVER URL: https://github.com/mozilla/geckodriver/releases/download/v0.31.0/geckodriver-v0.31.0-linux64.tar.gz

COPY src/main/resources/lib/geckodriver ${LAMBDA_TASK_ROOT}/lib/

CMD [ "com.test.TestHandler::handleRequest" ]
