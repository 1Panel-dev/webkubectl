#!/bin/bash
set -e

arg1=$1
arg2=$2

mkdir -p /nonexistent
mount -t tmpfs -o size=${SESSION_STORAGE_SIZE} tmpfs /nonexistent
cd /nonexistent
cp /root/.bashrc ./
mkdir -p .kube

if [ -z "${arg2}" ]; then
    echo $arg1| base64 -d > .kube/config
else
    export HOME=/nonexistent
    echo `kubectl config set-credentials webkubectl-user --token=${arg2}` > /dev/null 2>&1
    echo `kubectl config set-cluster kubernetes --server=${arg1} --insecure-skip-tls-verify=true` > /dev/null 2>&1
    echo `kubectl config set-context kubernetes --cluster=kubernetes --user=webkubectl-user` > /dev/null 2>&1
    echo `kubectl config use-context kubernetes` > /dev/null 2>&1
fi


chmod 666 .kube/config

if [ "${WELCOME_BANNER}" ]; then
    echo ${WELCOME_BANNER}
fi

exec su -s /bin/bash nobody