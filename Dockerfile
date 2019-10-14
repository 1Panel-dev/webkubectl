FROM ubuntu:18.04

USER root

ARG ARCH=amd64

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
ENV KUBECTL_VERSION v1.16.1
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates jq iproute2 vim-tiny less bash-completion unzip sysstat acl && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    curl -sLf https://github.com/tsl0922/ttyd/releases/download/1.5.2/ttyd_linux.x86_64 > /usr/bin/ttyd && \
    chmod +x /usr/bin/ttyd && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV LOGLEVEL_VERSION v0.1.2

COPY start-webkubectl.sh /
RUN chmod +x /start-webkubectl.sh
COPY start-session.sh /
RUN chmod +x /start-session.sh
COPY init-kubectl.sh /
RUN chmod +x /init-kubectl.sh
CMD ["sh","/start-webkubectl.sh"]