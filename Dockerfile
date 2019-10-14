FROM centos:7
RUN yum install -y wget &&  \
    wget https://github.com/tsl0922/ttyd/releases/download/1.5.2/ttyd_linux.x86_64 && \
    chmod +x ttyd_linux.x86_64 && \
    mv ttyd_linux.x86_64 /usr/bin/ttyd

RUN wget https://dl.k8s.io/v1.13.3/kubernetes-client-linux-amd64.tar.gz && \
    tar zxvf kubernetes-client-linux-amd64.tar.gz && \
    cp kubernetes/client/bin/kubectl /usr/bin && \
    rm -rf kubernetes-client-linux-amd64.tar.gz kubernetes

COPY start-webkubectl.sh .
CMD ["sh","./start-webkubectl.sh"]