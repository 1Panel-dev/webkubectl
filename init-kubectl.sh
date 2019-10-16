#!/bin/bash
set -e

arg1=$1
arg2=$2

mkdir -p /nonexistent
mount -t tmpfs tmpfs /nonexistent
cd /nonexistent

mkdir -p .kube

if [ -z "${arg2}" ]; then
    echo $(printf "%s" $arg1| base64 -d) > .kube/config
else
    export HOME=/nonexistent
    kubectl config set-credentials webkubectl-user --token=${arg2}
    kubectl config set-cluster kubernetes --server=${arg1} --insecure-skip-tls-verify=true
    kubectl config set-context kubernetes --cluster=kubernetes --user=webkubectl-user
    kubectl config use-context kubernetes
fi


chmod 666 .kube/config

exec su -s /bin/bash nobody