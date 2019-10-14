#!/bin/bash
set -e

config=$1

if [ -z "${config}" ]; then
    echo No config provided
    exit 1
fi

export TERM=screen-256color

unshare --fork --pid --mount-proc --mount init-kubectl.sh ${config}