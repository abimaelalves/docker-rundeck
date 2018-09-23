#
# Rundeck for CentOS 7 v2.0.1
# Autor: Fabiano Santos Florentino
#

FROM centos:latest

MAINTAINER Fabiano Florentino <fabiano.apk@gmail.com>

#
# CentOS KEY REPO
#
ADD conf/RPM-GPG-KEY-CentOS-7 /etc/pki/rpm-gpg/
ADD conf/RPM-GPG-KEY-EPEL /etc/pki/rpm-gpg/
ADD conf/RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/
ADD conf/BUILD-GPG-KEY-Rundeck.org.key /etc/pki/rpm-gpg/

RUN rpm --import "http://vault.centos.org/RPM-GPG-KEY-CentOS-7" \
    && rpm --import "https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL" \
    && rpm --import "https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7" \
    && rpm --import "http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key"

#
# Java 8
#
RUN yum -y update \
    && yum -y install epel-release \
    && yum -y update \
    && yum -y install java-1.8.0-openjdk \
    && yum clean all

#
# Rundeck
#
RUN yum -y install "http://repo.rundeck.org/latest.rpm" \
    && yum -y install rundeck \
    && yum clean all

ADD etc/* /etc/rundeck/

USER rundeck

EXPOSE 4440

VOLUME /etc/rundeck
VOLUME /var/rundeck/projects

CMD source /etc/rundeck/profile \
  && ${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}