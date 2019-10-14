#!/bin/bash
set -e

config=$1

mkdir -p /nonexistent
#mount -t tmpfs tmpfs /nonexistent
cd /nonexistent

mkdir -p .kube

echo ${config} > .kube/config

chmod 666 .kube/config

exec su -s /bin/bash nobody