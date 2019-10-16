#!/bin/bash
set -e

arg=$1

error=$5

if [ -z "${arg}" ]; then
    echo No Args provided
    echo Terminal will exit.
    exit 1
fi

if [ -n "${error}" ]; then
    echo ${error}
    exit 1
fi

unshare --fork --pid --mount-proc --mount /init-kubectl.sh ${arg}