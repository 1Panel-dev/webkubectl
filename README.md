[中文 README.md](https://github.com/webkubectl/webkubectl/blob/master/README.zh_CN.md)

# ![](https://raw.githubusercontent.com/webkubectl/gotty/master/resources/favicon.png) Web Kubectl - Run kubectl command in web browser

![License](https://img.shields.io/badge/License-Apache%202.0-red)
![Dockerized](https://img.shields.io/badge/Dockerized-yes-brightgreen)
![Version](https://img.shields.io/badge/Version-v1.5-yellow)
[![Docker Pulls](https://img.shields.io/docker/pulls/webkubectl/webkubectl.svg)](https://hub.docker.com/r/webkubectl/webkubectl)
![HitCount](http://hits.dwyl.io/webkubectl/webkubectl.svg)

![webkubectl](https://raw.githubusercontent.com/webkubectl/web-resources/master/webkubectl.gif)

# Benefit

Web Kubectl helps you to manage kubernetes credentials and run kubectl command in web browser, so that you don't have to install kubectl on your local PC or some other servers, furthermore Web Kubectl can be used for a team.

# Advantage
-  **Support multiple user and multiple Kubernetes clusters**：One deployment of Web Kubectl can be used for a team, all of the team members can use Web Kubectl simultaneously although they are connecting different Kubernetes clusters or different privileges.
-  **Session isolation**：All of the online sessions are isolated, each session has its own namespace and storage which is invisible to the others.
-  **Support kubeconfig file and bearer token**：You can provide kubeconfig file or bearer token to connect Kubernetes cluster through Web Kubectl.
-  **Easy to use and integrate**：You can simply use the index page for a quick start, or integrate with your application using api.
-  **Manage Kubernetes clusters in VPC**：Through Web Kubectl you can manage the Kubernetes clusters in VPC which is unreachable from you laptop.
```sh
_______________________________________________________________________
|   Local Network     |          DMZ           |      VPC/Datacenter  |
|                     |                        |                      |
|                     |    _______________     |   ----------------   |
|   ---------------   |    |             |  /~~~~~>| Kubernetes A |   |
|   | Your Laptop |~~~~~~~>| Web Kubectl | /   |   ----------------   |
|   ---------------   |    |             | \   |                      |
|                     |    ---------------  \  |   ----------------   |
|                     |                      \~~~~>| Kubernetes B |   |
|                     |                        |   ----------------   |
-----------------------------------------------------------------------
```

# Architecture
Web Kubectl use [webkubectl/gotty](https://github.com/webkubectl/gotty) to run a JavaScript based terminal on web browsers.<br>
When opens a new session, a temporary Linux namespace will be created for the session, this make sure all sessions are isolated, each session has its own namespace and storage, meanwhile .kube/config file is generated for current session.<br>
When session terminated, the provisioned namespace and storage are deleted.

# Installation

```sh
$ docker run --name="webkubectl" -p 8080:8080 -d --privileged webkubectl/webkubectl
```

Advanced environment variables

| ENV | Type | Default Value | Description|
| :--- | :---  | :---| :---|
| SESSION_STORAGE_SIZE | string | 10M |  Storage size limit for single connection |
| KUBECTL_INSECURE_SKIP_TLS_VERIFY | bool | true | whether to skip tls verify |
| GOTTY_OPTIONS | string | --port 8080 --permit-write --permit-arguments |   Gotty options, see [more](https://github.com/webkubectl/gotty/blob/master/GOTTY_USAGE.md#options) |
| WELCOME_BANNER | string | Welcome to Web Kubectl, try kubectl --help. |   Welcome banner after web terminal opened |

# Usage

## Use index page
Open below url in web browser.
```sh
http://<webkubectl-address>:<port>
```
In the opened page you can manage your own kubeconfig files or bearer tokens which are stored in local storage, then choose a session and click connect to use kubectl command in web terminal.

![index](https://raw.githubusercontent.com/webkubectl/web-resources/master/index.jpg)

![terminal](https://raw.githubusercontent.com/webkubectl/web-resources/master/terminal.jpg)

## Use API
#### Get token by Kubernetes API server address and bearer token

```sh
$ curl http://<webkubectl-address>:<port>/api/kube-token -X POST -d '{"name":"gks-hk-dev","apiServer":"https://k8s-cluster:6443","token":"token-content"}'
#response
$ {"success":true,"token":"mkolj4hgbutfgy1thgp1","message":""}
```
Request Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| name | string | session name |
| apiServer | string | API server address |
| token | string | Kubernetes bearer token |

Response Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| success | bool | the request is proceeded successfully or not |
| token | string | token used to open terminal |
| message | string | error message if success is false |

#### Get token by kubeconfig file

```sh
$ curl http://<webkubectl-address>:<port>/api/kube-config -X POST -d '{"name":"k8s-cluster-bj1","kubeConfig":"<kubeconfig file content base64 encoded>"}'
#response
$ {"success":true,"token":"mkolj4hgbutfgy1thgp1","message":""}
```
Request Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| name | string | session name |
| kubeConfig | string | kubeconfig file content base64 encoded |

Response Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| success | bool | the request is proceeded successfully or not |
| token | string | token used to open terminal |
| message | string | error message if success is false |

#### Open web terminal with token fetched from API

```sh
http://<webkubectl-address>:<port>/terminal/?token=<token fetched from api>
```

# Security 
-  **Token validation**：The token fetched from api will be invalid immediately after it's used once, and it expires after 5 minutes if not used. 
-  **Authentication**：By default all resources can be accessed without any authentication, to restrict anonymous access, you can enable the  basic authentication of gotty, see [how to](https://github.com/webkubectl/gotty/blob/master/GOTTY_USAGE.md#options).
-  **SSL/TLS**：By default all traffic between the server and clients are NOT encrypted, we recommend you enable SSL/TLS option of gotty, see [how to](https://github.com/webkubectl/gotty/blob/master/GOTTY_USAGE.md#options). Alternatively you can deploy Web Kubectl behind a proxy and enable SSL/TLS for the proxy, please note that the proxy should support WebSocket protocol.

# Dependencies 
-  [webkubectl/gotty](https://github.com/webkubectl/gotty)

# License

Copyright (c) 2014-2019 FIT2CLOUD 飞致云<br>

[https://www.fit2cloud.com](https://www.fit2cloud.com)<br>

Web Kubectl is licensed under the Apache License, Version 2.0.

---
# Alternatives
-  [https://github.com/fanux/fist/tree/master/terminal](https://github.com/fanux/fist/tree/master/terminal): Another web terminal to run kubectl.
-  [https://github.com/rancher](https://github.com/rancher): In the cluster view of Rancher, a web based kubectl can be launched, but we didn't find the source code. 

# Advertisement

> ### [KubeOperator](https://kubeoperator.io/)
> KubeOperator is an open source project, a web based application enable you to deploy and manage production ready Kubernetes clusters on VMware, Openstack, virtual machines and physical machines in LAN network without internet connectivity.<br>
> [https://kubeoperator.io](https://kubeoperator.io)<br>
> [https://github.com/kubeoperator/kubeoperator](https://github.com/kubeoperator/kubeoperator)