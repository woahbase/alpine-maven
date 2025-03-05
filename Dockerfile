# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG VERSION
#
ENV \
    LANG=C.UTF-8 \
    MAVEN_CONFIG="${S6_USERHOME:-/home/alpine}/.m2" \
    MAVEN_HOME=/usr/share/maven \
    MAVEN_VERSION=${VERSION}
#
RUN set -xe \
    && apk add -uU --no-cache \
        curl \
        ca-certificates \
        tzdata \
    && curl \
        -o /tmp/apache-maven-${VERSION}-bin.tar.gz \
        -jSLN "https://www.apache.org/dist/maven/maven-${VERSION%%.*}/${VERSION}/binaries/apache-maven-${VERSION}-bin.tar.gz" \
    && mkdir -p ${MAVEN_HOME}/ref \
    && tar \
        -C ${MAVEN_HOME} \
        --strip-components=1 \
        -xzf /tmp/apache-maven-${VERSION}-bin.tar.gz \
    && ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn \
    && apk del --purge curl \
    && rm -rf /var/cache/apk/* /tmp/*
#
# VOLUME /home/${S6_USER:-alpine}/ /home/${S6_USER:-alpine}/project/ # specify at runtime
# WORKDIR /home/${S6_USER:-alpine}/project/
#
ENTRYPOINT ["/usershell"]
CMD ["mvn", "--version"]
