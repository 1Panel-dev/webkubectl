FROM golang:1.16-alpine as gotty-build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=on

WORKDIR /tmp
COPY gotty gotty
RUN apk add --update git make && \
  cd gotty && \
  make gotty && cp gotty / && ls -l /gotty && /gotty -v



FROM alpine:latest

USER root

COPY --from=gotty-build /gotty /usr/bin/
RUN ARCH=$(uname -m) && case $ARCH in aarch64) ARCH="arm64";; x86_64) ARCH="amd64";; esac && echo "ARCH: " $ARCH && \
    echo > /etc/apk/repositories && echo -e "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main\nhttps://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
    apk update && apk upgrade && apk add --update --no-cache bash bash-completion curl git wget openssl iputils busybox-extras vim && sed -i "s/nobody:\//nobody:\/nonexistent/g" /etc/passwd && \
    curl -sLf https://storage.googleapis.com/kubernetes-release/release/v1.22.1/bin/linux/${ARCH}/kubectl > /usr/bin/kubectl && chmod +x /usr/bin/kubectl && \
    git clone --branch master --depth 1 https://github.com/ahmetb/kubectl-aliases /opt/kubectl-aliases && chmod -R 755 /opt/kubectl-aliases && \
    git clone --branch 0.21.0 --depth 1 https://github.com/junegunn/fzf /opt/fzf && chmod -R 755 /opt/fzf && /opt/fzf/install && ln -s /opt/fzf/bin/fzf /usr/local/bin/fzf && \
    ARCH=$(uname -m) && case $ARCH in aarch64) ARCH="arm64";; x86_64) ARCH="x86_64";; esac && echo "ARCH: " $ARCH && \
    cd /tmp/ && wget https://github.com/derailed/k9s/releases/download/v0.24.14/k9s_Linux_${ARCH}.tar.gz && tar -xvf k9s_Linux_${ARCH}.tar.gz && chmod +x k9s && mv k9s /usr/bin && \
    KUBECTX_VERSION=v0.9.4 && wget https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubens_${KUBECTX_VERSION}_linux_${ARCH}.tar.gz && tar -xvf kubens_${KUBECTX_VERSION}_linux_${ARCH}.tar.gz && chmod +x kubens && mv kubens /usr/bin && \
    wget https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_linux_${ARCH}.tar.gz && tar -xvf kubectx_${KUBECTX_VERSION}_linux_${ARCH}.tar.gz && chmod +x kubectx && mv kubectx /usr/bin && \
    curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && \
    chmod +x /usr/bin/gotty && chmod 555 /bin/busybox && \
    apk del git curl && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* && \
    chmod -R 755 /tmp && mkdir -p /opt/webkubectl

COPY vimrc.local /etc/vim
COPY start-webkubectl.sh /opt/webkubectl
COPY start-session.sh /opt/webkubectl
COPY init-kubectl.sh /opt/webkubectl
RUN chmod -R 700 /opt/webkubectl /usr/bin/gotty


ENV SESSION_STORAGE_SIZE=10M
ENV WELCOME_BANNER="Welcome to Web Kubectl, try kubectl --help."
ENV KUBECTL_INSECURE_SKIP_TLS_VERIFY=true
ENV GOTTY_OPTIONS="--port 8080 --permit-write --permit-arguments"

CMD ["sh","/opt/webkubectl/start-webkubectl.sh"]
