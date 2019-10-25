#!/bin/bash
set -e

all=$*

if [ -z "${all}" ]; then
    echo No Args provided
    echo Terminal will exit.
    sleep 1
    exit 1
fi

if [[ $all == ERROR:* ]]; then
    echo ${all}
    sleep 1
    exit 1
fi

unshare --fork --pid --mount-proc --mount /opt/webkubectl/init-kubectl.sh ${all}