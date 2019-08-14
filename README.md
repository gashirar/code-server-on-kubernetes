# code-server on Kubernetes

code-server is VS Code running on a remote server, accessible through the browser. https://github.com/cdr/code-server

*Sorry! Under Construction!*

Authentication default password is `P@ssw0rd`.  
You can overwrite password by environment variables.(`PASSWORD`)  

## How to use `code-server-on-kubernetes` image?

### local
This script pulls the image and runs Theia IDE on http://localhost:8443 with the current directory as a workspace.
```
docker run -it -p 8443:8443 -v "$(pwd):/home/coder:cached" gashirar/code-server-on-k8s:latest
```

### k8s cluster

Apply Helm Chart!
```
helm template . --set user=<YOURNAME> --set password=<YOURPASSWORD> --set namespace=<YOURNAMESPACE> --set loadBalancerSourceRanges={0.0.0.0/0} | kubectl apply -f -
```
