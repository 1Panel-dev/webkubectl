#!/bin/bash
set -e

arg=$1
all=$*

if [ -z "${arg}" ]; then
    echo No Args provided
    echo Terminal will exit.
    exit 1
fi

if [[ $all == ERROR:* ]]; then
    echo ${all#*ERROR:}
    exit 1
fi

unshare --fork --pid --mount-proc --mount /init-kubectl.sh ${arg}