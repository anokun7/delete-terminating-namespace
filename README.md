# delete-terminating-namespace
Script to delete kubernetes namespaces that are stuck in a never-ending "Terminating" status

Ensure that you can authenticate to the kubernetes cluster as a cluster admin. This will need you to have the appropriate kube config setup etc.
```
 anoopkumar »» kubectl get ns                                                                                            
NAME              STATUS        AGE
default           Active        101d
kube-node-lease   Active        101d
kube-public       Active        101d
kube-system       Active        101d
kubeless          Active        3d15h
noop              Active        101d
test-1            Terminating   100d
test-2            Terminating   20d
test-3            Terminating   17d
test-4            Terminating   13d
test-5            Terminating   10d
tls               Active        56d
weave             Active        5d1h
 anoopkumar »»
 ```
 Follow the steps below to delete any and all namespaces that refuse to get deleted even after removing all objects within them. [The `test-*` namespaces in the output above are an example of such namespaces that refuse to get cleaned up]
 
 1. Run the kubernetes api proxy:
 ```
  anoopkumar »» kubectl proxy -p 8080 &
 ```
 
 2. Clone and run the script in this repo:
 ```
  anoopkumar »» git clone git@github.com:anokun7/delete-terminating-namespace.git
  anoopkumar »» delete-terminating-namespace/delete-ns.sh
Cleaning up test-1 namespace ...
Cleaning up test-2 namespace ...
Cleaning up test-3 namespace ...
Cleaning up test-4 namespace ...
Cleaning up test-5 namespace ...
... Done!
  anoopkumar »» 
```
Confirm that the lingering namespaces have been cleaned up.
```
 anoopkumar »» kubectl get ns                                                                                            
NAME              STATUS        AGE
default           Active        101d
kube-node-lease   Active        101d
kube-public       Active        101d
kube-system       Active        101d
kubeless          Active        3d15h
noop              Active        101d
tls               Active        56d
weave             Active        5d1h
 anoopkumar »»
 ```
 


