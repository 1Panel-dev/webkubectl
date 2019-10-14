FROM ubuntu:18.04
ARG ARCH=amd64
ENV DOCKER_URL_amd64=https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 \
    DOCKER_URL_arm64=https://github.com/rancher/docker/releases/download/v1.10.3-ros1/docker-1.10.3_arm64 \
    DOCKER_URL=DOCKER_URL_${ARCH}

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
ENV KUBECTL_VERSION v1.16.1
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates jq iproute2 vim-tiny less bash-completion unzip sysstat acl && \
    curl -sLf ${!DOCKER_URL} > /usr/bin/docker && \
    chmod +x /usr/bin/docker && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    curl -sLf https://github.com/tsl0922/ttyd/releases/download/1.5.2/ttyd_linux.x86_64 > /usr/bin/ttyd && \
    chmod +x /usr/bin/ttyd && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENV LOGLEVEL_VERSION v0.1.2

RUN curl -sLf https://github.com/rancher/loglevel/releases/download/${LOGLEVEL_VERSION}/loglevel-${ARCH}-${LOGLEVEL_VERSION}.tar.gz | tar xvzf - -C /usr/bin
RUN curl -sL https://github.com/rancher/share-mnt/releases/download/v1.0.4/share-mnt-${ARCH}.tar.gz | tar xvzf - -C /usr/bin
ENV KUBEPROMPT_VERSION v1.0.6

RUN curl -sL https://github.com/c-bata/kube-prompt/releases/download/${KUBEPROMPT_VERSION}/kube-prompt_${KUBEPROMPT_VERSION}_linux_${ARCH}.zip > /usr/bin/kube-prompt.zip && unzip /usr/bin/kube-prompt.zip -d /usr/bin
ARG VERSION=dev
LABEL io.cattle.agent true
ENV DOCKER_API_VERSION 1.24
ENV AGENT_IMAGE rancher/rancher-agent:${VERSION}
ENV SSL_CERT_DIR /etc/kubernetes/ssl/certs
COPY start-webkubectl.sh /
RUN chmod +x /start-webkubectl.sh
COPY start-session.sh /
RUN chmod +x /start-session.sh
COPY init-kubectl.sh /
RUN chmod +x /init-kubectl.sh
CMD ["sh","/start-webkubectl.sh"]