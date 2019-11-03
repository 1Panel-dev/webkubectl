FROM golang:1.12-alpine as gotty-build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN apk add --update git && \
  mkdir -p /tmp/gotty && \
  export GOPATH=/tmp/gotty && go get -d github.com/webkubectl/gotty && \
  cd $GOPATH/src/github.com/webkubectl/gotty && go build && \
  cp gotty / && \
  ls /gotty



FROM ubuntu:18.04

USER root

ARG ARCH=amd64

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
ENV KUBECTL_VERSION v1.16.2
COPY --from=gotty-build /gotty /usr/bin/
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates jq iproute2 less bash-completion unzip sysstat acl net-tools lrzsz iputils-ping telnet dnsutils wget vim && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && chmod +x /usr/bin/kubectl && \
    chmod +x /usr/bin/gotty && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod 755 /tmp && mkdir -p /opt/webkubectl

COPY start-webkubectl.sh /opt/webkubectl
COPY start-session.sh /opt/webkubectl
COPY init-kubectl.sh /opt/webkubectl
RUN chmod -R 700 /opt/webkubectl


ENV SESSION_STORAGE_SIZE=10M
ENV WELCOME_BANNER="Welcome to Web Kubectl, try kubectl --help."
ENV KUBECTL_INSECURE_SKIP_TLS_VERIFY=true
ENV GOTTY_OPTIONS="--port 8080 --permit-write --permit-arguments"

CMD ["sh","/opt/webkubectl/start-webkubectl.sh"]