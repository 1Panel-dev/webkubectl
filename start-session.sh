#!/bin/bash
set -e

config=$1
#config="config content"

if [ -z "${config}" ]; then
    echo No kube-config file provided
    echo Terminal will exit.
    sleep 10
    exit 1
fi

unshare --fork --pid --mount-proc --mount /init-kubectl.sh ${config}