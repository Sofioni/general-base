# This is the general base for all: non-contrail specfic like external and for contrail specific

FROM omermajeed/base-image:7.4.164
ARG CONTAINER_LINUX_DISTR=redhat
ARG CONTAINER_LINUX_DISTR_VER=7.4

ARG GENERAL_EXTRA_RPMS=""
ARG YUM_ENABLE_REPOS=""

# this copy should be before yum install
COPY *.repo /etc/yum.repos.d/

RUN YUM_ENABLE_REPOS=$(echo $YUM_ENABLE_REPOS | tr -d '"') && \
    if [[ -n "$YUM_ENABLE_REPOS" ]] ; then \
        echo "INFO: contrail-general-base: enable repos $YUM_ENABLE_REPOS" && \
        yum-config-manager --enable $YUM_ENABLE_REPOS ; \
        yum clean metadata ; \
    fi && \
    yum update -y && \
    yum install -y yum-plugin-priorities iproute less && \
    GENERAL_EXTRA_RPMS=$(echo $GENERAL_EXTRA_RPMS | tr -d '"' | tr ',' ' ') && \
    if [[ -n "$GENERAL_EXTRA_RPMS" ]] ; then \
        echo "INFO: contrail-general-base: install $GENERAL_EXTRA_RPMS" && \
        yum install -y $GENERAL_EXTRA_RPMS ; \
    fi

COPY *.sh /
COPY license.txt /licenses/

CMD ["/usr/bin/tail","-f","/dev/null"]

#USER sofioni
MAINTAINER omer.majeed@sofioni.com
LABEL sofioni.tf-vpp.service=general-base
LABEL sofioni.tf-vpp.container.name=general-base
LABEL build-date=20190320
LABEL name=general-base \
      vendor="Sofioni" \
      version="1.0" \
      release="1" \
      summary="container acting as general agent" \
      description="forms the basis for the other containers"
