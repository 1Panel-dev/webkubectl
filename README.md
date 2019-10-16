# ![](https://raw.githubusercontent.com/webkubectl/gotty/master/resources/favicon.png) Web Kubectl - Use kubectl command in web browser



![Total visitor](https://visitor-count-badge.herokuapp.com/total.svg?repo_id=webkubectl-webkubectl)
![Visitors in today](https://visitor-count-badge.herokuapp.com/today.svg?repo_id=webkubectl-webkubectl)

# Advantage
-  Support multiple user and multiple sessions：A deployment of Web Kubectl can be used for a team, all of the team members can use Web Kubectl simultaneously, although they have different sessions.
-  Isolation：All of the online sessions are isolated, each session has its own namespace and storage which is invisible to the others.
-  Easy to use：It's easy to use Web Kubectl in two ways, embedded page and api.

# Architecture
Web Kubectl use [webkubectl/gotty](https://github.com/webkubectl/gotty) to run a JavaScript based terminal on web browsers.<br>
When opens a new connection , a new Linux namespace will be created for the session, this make sure all sessions are isolated, each session has its own namespace and storage, after the connection closed, the namespace and storage is deleted.


# Installation

```sh
$ docker run --name="webkubectl" -p 8080:8080 -d --privileged webkubectl/webkubectl
```

Advance env variables

| env | type | defaults | Description|
| :--- | :---  | :---| :---|
| SESSION_STORAGE_SIZE | string | 10M |  the storage limit size for single connection |
| WELCOME_BANNER | string | Welcome to Web Kubectl, try kubectl --help. |   the welcome banner after web terminal opened |
| KUBECTL_INSECURE_SKIP_TLS_VERIFY | bool | true | ignore certification errors for kubectl |

# Usage

  ## Use embedded page
Open below url in web browser.
```sh
http://<webkubectl-address>:<port>
```
In this page you can manage kubernetes config files or tokens which are stored in local storage, then chose a session and click connect to use kubectl command in web terminal.

## integration with api


## License

Copyright (c) 2014-2019 FIT2CLOUD 飞致云

KubeOperator is licensed under the Apache License, Version 2.0.
