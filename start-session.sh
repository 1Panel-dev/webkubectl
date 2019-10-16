#!/bin/bash
set -e

all=$*

if [ -z "${all}" ]; then
    echo No Args provided
    echo Terminal will exit.
    exit 1
fi

if [[ $all == ERROR:* ]]; then
    echo ${all}
    exit 1
fi

unshare --fork --pid --mount-proc --mount /init-kubectl.sh ${all}