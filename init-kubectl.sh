#!/bin/bash
set -e

if [ "${WELCOME_BANNER}" ]; then
    echo ${WELCOME_BANNER}
fi

KUBECONFIG_INPUT=$1
OBJECT_NAME=$2 # eg: pod name or deployment name
OBJECT_NAMESPACE=$3 # eg: mentored
USE_DEPLOY_NAME=$4 # eg: true or false

mkdir -p /nonexistent
mount -t tmpfs -o size=${SESSION_STORAGE_SIZE} tmpfs /nonexistent
cd /nonexistent
cp /root/.bashrc ./
cp /etc/vim/vimrc.local .vimrc
echo 'source /opt/kubectl-aliases/.kubectl_aliases' >> .bashrc
echo -e 'PS1="> "\nalias ll="ls -la"' >> .bashrc
mkdir -p .kube

export HOME=/nonexistent

echo $KUBECONFIG_INPUT| base64 -d > .kube/config

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


# Check OBJECT_NAMESPACE and define it with a default value if is empty
if [ -z "${OBJECT_NAMESPACE}" ]; then
    OBJECT_NAMESPACE="mentored"
fi
# Run 

# if OBJECT_NAMESPACE is not empty
if [ -z "${OBJECT_NAME}" ]; then
    exec su -s /bin/bash nobody
elif [ "${USE_DEPLOY_NAME}" == "true" ]; then
    # If USE_DEPLOY_NAME is true, then use OBJECT_NAME as the deployment name
    kubectl exec -n $OBJECT_NAMESPACE -it --tty deploy/$OBJECT_NAME -- /bin/bash
else
    kubectl exec -n $OBJECT_NAMESPACE -it --tty $OBJECT_NAME -- /bin/bash
fi