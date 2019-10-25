#!/bin/bash

echo "Environment variables:"
env

echo "export TERM=xterm" >> /root/.bashrc
echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc
echo 'source <(kubectl completion bash)' >> /root/.bashrc

if [ ${KUBECTL_INSECURE_SKIP_TLS_VERIFY} == "true" ];then
    echo "alias kubectl='kubectl --insecure-skip-tls-verify=true'" >> /root/.bashrc
fi


gotty ${GOTTY_OPTIONS} /opt/webkubectl/start-session.sh