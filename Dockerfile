FROM golang:1.12-alpine as gotty-build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

RUN apk add --update git && \
  mkdir -p /tmp/gotty && \
  export GOPATH=/tmp/gotty && go get -d github.com/webkubectl/gotty && \
  cd $GOPATH/src/github.com && mv webkubectl yudai && cd yudai/gotty && go build && \
  cp gotty && \
  ls /gotty



FROM ubuntu:18.04

USER root

ARG ARCH=amd64

RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh
ENV KUBECTL_VERSION v1.16.1
COPY --from=gotty-build /gotty /usr/bin/
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates jq iproute2 vim-tiny less bash-completion unzip sysstat acl && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    chmod +x /usr/bin/gotty && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



COPY start-webkubectl.sh /
RUN chmod +x /start-webkubectl.sh
COPY start-session.sh /
RUN chmod +x /start-session.sh
COPY init-kubectl.sh /
RUN chmod +x /init-kubectl.sh
CMD ["sh","/start-webkubectl.sh"]