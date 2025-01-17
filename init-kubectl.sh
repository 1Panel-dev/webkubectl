#!/bin/bash
set -e

if [ "${WELCOME_BANNER}" ]; then
    echo ${WELCOME_BANNER}
fi

arg1=$1
arg2=$2
arg3=$3

mkdir -p /nonexistent
mount -t tmpfs -o size=${SESSION_STORAGE_SIZE} tmpfs /nonexistent
cd /nonexistent
cp /root/.bashrc ./
cp /etc/vim/vimrc.local .vimrc
echo 'source /opt/kubectl-aliases/.kubectl_aliases' >> .bashrc
echo -e 'PS1="> "\nalias ll="ls -la"' >> .bashrc
mkdir -p .kube

export HOME=/nonexistent

echo $arg1| base64 -d > .kube/config

if [ ${KUBECTL_INSECURE_SKIP_TLS_VERIFY} == "true" ];then
    {
        clusters=`kubectl config get-clusters | tail -n +2`
        for s in ${clusters[@]}; do
            {
                echo `kubectl config set-cluster ${s} --insecure-skip-tls-verify=true` > /dev/null 2>&1
                echo `kubectl config unset clusters.${s}.certificate-authority-data` > /dev/null 2>&1
            } || {
                echo err > /dev/null 2>&1
            }
        done
    } || {
        echo err > /dev/null 2>&1
    }
fi

chown -R nobody:nogroup .kube

export TMPDIR=/nonexistent

envs=`env`
for env in ${envs[@]}; do
    if [[ $env == GOTTY* ]];
    then
        unset ${env%%=*}
    fi
done

unset WELCOME_BANNER PPROF_ENABLED KUBECTL_INSECURE_SKIP_TLS_VERIFY SESSION_STORAGE_SIZE KUBECTL_VERSION


# Check arg3 and define it with a default value if is empty
if [ -z "${arg3}" ]; then
    arg3="mentored"
fi
# Run 

# if arg3 is not empty
if [ -z "${arg2}" ]; then
    exec su -s /bin/bash nobody
else
    kubectl exec -n $arg3 -it --tty $arg2 -- /bin/bash
fi