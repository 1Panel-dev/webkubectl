# ![](https://raw.githubusercontent.com/webkubectl/gotty/master/resources/favicon.png) Web Kubectl - Use kubectl command in web browser



![Total visitor](https://visitor-count-badge.herokuapp.com/total.svg?repo_id=webkubectl-webkubectl)
![Visitors in today](https://visitor-count-badge.herokuapp.com/today.svg?repo_id=webkubectl-webkubectl)

# Installation

```sh
$ docker run --name="webkubectl" -p 8080:8080 -d --privileged webkubectl/webkubectl
```
# Usage

## User embedded page
Open this in web browser.
```sh
http://<webkubectl-address>:<port>
```
You can add/delete kubernetes config file or token, then chose a session and click connect to use kubectl command in web terminal.
