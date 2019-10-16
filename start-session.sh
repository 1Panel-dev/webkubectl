#!/bin/bash
set -e

arg=$1

if [ -z "${arg}" ]; then
    echo No Args provided
    echo Terminal will exit.
    sleep 10
    exit 1
fi

unshare --fork --pid --mount-proc --mount /init-kubectl.sh ${arg}