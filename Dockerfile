FROM golang:1.12-alpine as gotty-build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN apk add --update git make && \
  go get -d github.com/webkubectl/gotty && \
  go get -u github.com/golang/dep/cmd/dep && cd $GOPATH/src/github.com/webkubectl/gotty && \
  make gotty && cp gotty / && ls -l /gotty && /gotty -v



FROM ubuntu:18.04

USER root

ARG ARCH=amd64

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
ENV KUBECTL_VERSION v1.16.2
ENV K9S_VERSION 0.9.3
COPY --from=gotty-build /gotty /usr/bin/
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates jq iproute2 less bash-completion unzip sysstat acl net-tools iputils-ping telnet dnsutils wget vim git && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && chmod +x /usr/bin/kubectl && \
    git clone https://github.com/ahmetb/kubectx /opt/kubectx && chmod -R 755 /opt/kubectx && ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    git clone --depth 1 https://github.com/ahmetb/kubectl-aliases /opt/kubectl-aliases && chmod -R 755 /opt/kubectl-aliases && \
    git clone --depth 1 https://github.com/junegunn/fzf /opt/fzf && chmod -R 755 /opt/fzf && /opt/fzf/install && ln -s /opt/fzf/bin/fzf /usr/local/bin/fzf && \
    mkdir -p /tmp/k9s && cd /tmp/k9s && wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_${K9S_VERSION}_Linux_x86_64.tar.gz && tar -xvf k9s_${K9S_VERSION}_Linux_x86_64.tar.gz && chmod +x k9s && mv k9s /usr/bin && \
    chmod +x /usr/bin/gotty && \
    DEBIAN_FRONTEND=noninteractive apt-get --purge remove -y git && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod -R 755 /tmp && mkdir -p /opt/webkubectl

COPY vimrc.local /etc/vim
COPY start-webkubectl.sh /opt/webkubectl
COPY start-session.sh /opt/webkubectl
COPY init-kubectl.sh /opt/webkubectl
RUN chmod -R 700 /opt/webkubectl


ENV SESSION_STORAGE_SIZE=10M
ENV WELCOME_BANNER="Welcome to Web Kubectl, try kubectl --help."
ENV KUBECTL_INSECURE_SKIP_TLS_VERIFY=true
ENV GOTTY_OPTIONS="--port 8080 --permit-write --permit-arguments"

CMD ["sh","/opt/webkubectl/start-webkubectl.sh"]