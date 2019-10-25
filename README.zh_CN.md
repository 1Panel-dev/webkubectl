[英文 README.md](https://github.com/webkubectl/webkubectl/blob/master/README.md)

# ![](https://raw.githubusercontent.com/webkubectl/gotty/master/resources/favicon.png) Web Kubectl - 在Web浏览器中运行kubectl命令

![License](https://img.shields.io/badge/License-Apache%202.0-red)
![Dockerized](https://img.shields.io/badge/Dockerized-yes-brightgreen)
![Version](https://img.shields.io/badge/Version-v1.3-yellow)
![HitCount](http://hits.dwyl.io/webkubectl/webkubectl.svg)

![webkubectl](https://raw.githubusercontent.com/webkubectl/web-resources/master/webkubectl.gif)

# 好处

Web Kubectl可以管理您本地的kubernetes凭据，并在Web浏览器中运行kubectl命令，从而不必在本地PC或其他服务器上安装kubectl，并且Web Kubectl也适用于团队多人同时使用，此外还可以使用API集成到您自己的应用中。

# 优势
-  **支持多用户和多个Kubernetes集群**：一个Web Kubectl部署可用于一个团队，尽管团队各个成员都在同时连接不同的Kubernetes集群、使用不同的Kubernetes权限。
-  **会话隔离**：所有的在线会话都是隔离的，每个会话都有自己的名称空间和存储空间，对其他存储空间不可见。
-  **支持Kubernetes config文件和token**：您可以提供Kubernetes config文件或token以通过Web Kubectl连接Kubernetes集群。
-  **易于使用和集成**：使用Web Kubectl首页可以快速入门，或者使用API与您的应用集成。

# 架构
Web Kubectl 使用[webkubectl/gotty](https://github.com/webkubectl/gotty)在Web浏览器中运行基于JavaScript的Shell终端。<br>
当打开一个新会话时，将为该会话创建一个临时Linux名称空间，以确保所有会话都是隔离的，每个会话都有自己的名称空间和存储，同时为当前会话生成.kube / config文件。 <br>
会话结束后，临时名称空间和存储将被删除。


# 安装

```sh
$ docker run --name="webkubectl" -p 8080:8080 -d --privileged webkubectl/webkubectl
```

高级环境变量

| ENV | Type | Default Value | Description|
| :--- | :---  | :---| :---|
| SESSION_STORAGE_SIZE | string | 10M |  单会话的存储大小限制 |
| KUBECTL_INSECURE_SKIP_TLS_VERIFY | bool | true | kubectl命令是否跳过tls验证 |
| GOTTY_OPTIONS | string | --port 8080 --permit-write --permit-arguments | [查看](https://github.com/webkubectl/gotty/blob/master/GOTTY_USAGE.md#options) Gotty Options |
| WELCOME_BANNER | string | Welcome to Web Kubectl, try kubectl --help. |   Web终端打开后的欢迎横幅 |

# 使用

## 使用首页
在浏览器中打开下方的网址。
```sh
http://<webkubectl-address>:<port>
```
在打开的页面中，您可以管理您自己的kubernetes config文件或token凭据，这些凭据存储在您本地浏览器的Local Storage中。然后选择一个会话，单击“连接”在弹出的Web终端中使用kubectl命令。

![index](https://raw.githubusercontent.com/webkubectl/web-resources/master/index.jpg)

![terminal](https://raw.githubusercontent.com/webkubectl/web-resources/master/terminal.jpg)

## 使用 API
#### 通过Kubernetes API Server地址和Token获取终端Token

```sh
$ curl http://<webkubectl-address>:<port>/api/kube-token -X POST -d '{"name":"gks-hk-dev","apiServer":"https://k8s-cluster:6443","token":"token-content"}'
#response
$ {"success":true,"token":"mkolj4hgbutfgy1thgp1","message":""}
```
请求参数 <br>

| 参数名 | 参数类型 | 参数描述|
| :--- | :--- | :---|
| name | string | 会话名称 |
| apiServer | string | Kubernetes API Server地址 |
| token | string | Kubernetes Token |

响应结果 <br>

| 参数名 | 参数类型 | 参数描述|
| :--- | :--- | :---|
| success | bool | 请求处理成功为true，否则false |
| token | string | 打开终端时使用的Token |
| message | string | 错误信息 |

#### 通过Kubernetes config文件获取终端Token

```sh
$ curl http://<webkubectl-address>:<port>/api/kube-config -X POST -d '{"name":"k8s-cluster-bj1","kubeConfig":"<Kubernetes config file content base64 encoded>"}'
#response
$ {"success":true,"token":"mkolj4hgbutfgy1thgp1","message":""}
```
请求参数 <br>

| 参数名 | 参数类型 | 参数描述|
| :--- | :--- | :---|
| name | string | 会话名称 |
| kubeConfig | string | Base64加密后的Kubernetes config文件内容 |

响应结果 <br>

| 参数名 | 参数类型 | 参数描述|
| :--- | :--- | :---|
| success | bool | 请求处理成功为true，否则false |
| token | string | 打开终端时使用的Token |
| message | string | 错误信息 |

#### 使用终端Token

```sh
http://<webkubectl-address>:<port>/terminal/?token=<调用API获取的终端Token>
```

# 安全 
-  **终端Token验证**：从API提取的终端Token使用一次后将立即失效，如果一直不使用，则在5分钟后过期。
-  **Authentication**：默认情况下，无需进行任何身份验证即可访问所有资源，若要限制匿名访问，可以启用getty的基本身份验证，请参见[操作方法](https://github.com/yudai/gotty#options)。
-  **SSL/TLS**：默认情况下，服务器与客户端之间的所有流量均未加密，我们建议您启用getty的SSL / TLS选项，请参见[操作方法](https://github.com/yudai/gotty#options)。或者，您可以在代理后面部署Web Kubectl并为该代理启用SSL / TLS，请注意，您的代理需要支持WebSocket协议。

# Alternatives
-  [https://github.com/fanux/fist/tree/master/terminal](https://github.com/fanux/fist/tree/master/terminal): 另一个可在Web终端运行kubectl的项目。
-  [https://github.com/rancher](https://github.com/rancher): 在Rancher的集群视图中，可以启动基于Web的kubectl，但是我们没有找到源代码。 

# 许可

Copyright (c) 2014-2019 FIT2CLOUD 飞致云<br>

[https://www.fit2cloud.com](https://www.fit2cloud.com)<br>

Web Kubectl is licensed under the Apache License, Version 2.0.

# 广告

### [KubeOperator](https://kubeoperator.io/)

KubeOperator 是一个开源项目，在离线网络环境下，通过可视化 Web UI 在 VMware、Openstack 或者物理机上部署和管理生产级别的 Kubernetes 集群。

[https://kubeoperator.io](https://kubeoperator.io)

[https://github.com/kubeoperator/kubeoperator](https://github.com/kubeoperator/kubeoperator)