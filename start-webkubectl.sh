#!/bin/bash

if [ ${KUBECTL_INSECURE_SKIP_TLS_VERIFY} == "true" ];then
    echo KUBECTL_INSECURE_SKIP_TLS_VERIFY=${KUBECTL_INSECURE_SKIP_TLS_VERIFY}
    mv /usr/bin/kubectl /usr/bin/kubectlo
    echo "alias kubectl='kubectlo --insecure-skip-tls-verify=true'" >> /root/.bashrc
fi


gotty --port 8080 --permit-write --permit-arguments /start-session.sh