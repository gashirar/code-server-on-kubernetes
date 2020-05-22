# code-server on Kubernetes

code-server is VS Code running on a remote server, accessible through the browser. https://github.com/cdr/code-server

Authentication default password is `P@ssw0rd`.
You can overwrite password by environment variables.(`PASSWORD`)

## How to use `code-server-on-kubernetes` image?

### local
This script pulls the image and runs Theia IDE on https://localhost:8443 with the current directory as a workspace.
```
docker run -it -p 127.0.0.1:8080:8080 -v "$PWD:/home/coderi/project" -u "$(id -u):$(id -g)" gashirar/code-server-on-k8s:latest
```

### k8s cluster

Apply Helm Chart!
```
helm template . --set user=<YOURNAME> --set password=<YOURPASSWORD> --set namespace=<YOURNAMESPACE> | kubectl apply -f -
```
