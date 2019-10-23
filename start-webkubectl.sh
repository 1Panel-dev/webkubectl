#!/bin/bash

echo KUBECTL_INSECURE_SKIP_TLS_VERIFY=${KUBECTL_INSECURE_SKIP_TLS_VERIFY}

echo "export TERM=xterm" >> /root/.bashrc
echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc
echo 'source <(kubectl completion bash)' >> /root/.bashrc

if [ ${KUBECTL_INSECURE_SKIP_TLS_VERIFY} == "true" ];then
    echo "alias kubectl='kubectl --insecure-skip-tls-verify=true'" >> /root/.bashrc
fi


gotty ${GOTTY_OPTIONS} /start-session.sh