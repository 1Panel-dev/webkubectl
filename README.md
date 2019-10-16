# ![](https://raw.githubusercontent.com/webkubectl/gotty/master/resources/favicon.png) Web Kubectl - Run kubectl command in web browser

![License](https://img.shields.io/badge/License-Apache%202.0-red)
![Dockerized](https://img.shields.io/badge/Dockerized-yes-brightgreen)
![Version](https://img.shields.io/badge/Version-v1.0-yellow)
![Total visitor](https://visitor-count-badge.herokuapp.com/total.svg?repo_id=webkubectl-webkubectl)
![Visitors in today](https://visitor-count-badge.herokuapp.com/today.svg?repo_id=webkubectl-webkubectl)

![terminal](https://raw.githubusercontent.com/webkubectl/web-resources/master/terminal.png)

# Advantage
-  **Support multiple user and multiple Kubernetes clusters**：A deployment of Web Kubectl can be used for a team, all of the team members can use Web Kubectl simultaneously although they are connecting different Kubernetes clusters.
-  **Session isolation**：All of the online sessions are isolated, each session has its own namespace and storage which is invisible to the others.
-  **Support Kubernetes config file and token**：You can provide Kubernetes config file or token to connect Kubernetes cluster via Web Kubectl.
-  **Easy to use and integrate**：You can simply use the index page for a quick start, or integrate with your application using api.

# Architecture
Web Kubectl use [webkubectl/gotty](https://github.com/webkubectl/gotty) to run a JavaScript based terminal on web browsers.<br>
When opens a new connection, a new Linux namespace will be created for the session, this make sure all sessions are isolated, each session has its own namespace and storage, after the connection closed, the namespace and storage is deleted.


# Installation

```sh
$ docker run --name="webkubectl" -p 8080:8080 -d --privileged webkubectl/webkubectl
```

Advanced environment variables

| ENV | Type | Default Value | Description|
| :--- | :---  | :---| :---|
| SESSION_STORAGE_SIZE | string | 10M |  the storage size limit for single connection |
| KUBECTL_INSECURE_SKIP_TLS_VERIFY | bool | true | ignore certification errors for kubectl |
| WELCOME_BANNER | string | Welcome to Web Kubectl, try kubectl --help. |   the welcome banner after web terminal opened |

# Usage

## Use index page
Open below url in web browser.
```sh
http://<webkubectl-address>:<port>
```
In the opened page you can manage your own kubernetes config files or tokens which are stored in local storage, then choose a session and click connect to use kubectl command in web terminal.

![index](https://raw.githubusercontent.com/webkubectl/web-resources/master/index.png)

## Use API
#### Get token by Kubernetes API server address and token

```sh
$ curl http://<webkubectl-address>:<port>/api/kube-token -X POST -d '{"name":"gks-hk-dev","apiServer":"https://k8s-cluster:6443","token":"token-content"}'
#response
$ {"success":true,"token":"mkolj4hgbutfgy1thgp1","message":""}
```
Request Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| name | string | connection name |
| apiServer | string | API server address |
| token | string | Kubernetes token |

Response Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| success | bool | the request is proceeded successfully or not |
| token | string | token used to open terminal |
| message | string | error message if success is false |

#### Get token by Kubernetes config file

```sh
$ curl http://<webkubectl-address>:<port>/api/kube-config -X POST -d '{"name":"k8s-cluster-bj1","kubeConfig":"<Kubernetes config file content base64 encoded>"}'
#response
$ {"success":true,"token":"mkolj4hgbutfgy1thgp1","message":""}
```
Request Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| name | string | connection name |
| kubeConfig | string | Kubernetes config file content base64 encoded |

Response Json <br>

| key | Type | Description|
| :--- | :--- | :---|
| success | bool | the request is proceeded successfully or not |
| token | string | token used to open terminal |
| message | string | error message if success is false |

#### Open web terminal with token

You can get a token from above API response, with which we can open web terminal in browser.

```sh
http://<webkubectl-address>:<port>/terminal/?token=<token fetched from api>
```

# Security 
-  **Token validation**：The token fetched from api will be invalid immediately after it's used once, and it expires after 5 minutes if not used. 
-  **Authentication**：By default all resources can be accessed without any authentication, to restrict anonymous access, you can enable the  basic authentication of gotty, see [how to](https://github.com/yudai/gotty#options).
-  **SSL/TLS**：By default all traffic between the server and clients are NOT encrypted, we recommend you enable SSL/TLS option of gotty, see [how to](https://github.com/yudai/gotty#options). Alternatively you can deploy Web Kubectl behind a proxy and enable SSL/TLS for the proxy, please note that the proxy should support WebSocket protocol.

# License

Copyright (c) 2014-2019 FIT2CLOUD 飞致云<br>

[https://www.fit2cloud.com](https://www.fit2cloud.com)<br>

Web Kubectl is licensed under the Apache License, Version 2.0.
