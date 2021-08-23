# Docker Desktop (DD)

Reference:
* DD: https://www.docker.com/products/docker-desktop
* HPCC Cloud Deployment: https://hpccsystems.com/training/documentation/Containerized-Platform

## Resource
For this project it'd better to have at least 4 CPU, 8GB Memory and 60+ GB disk. You can set these in Settings/Resources/ADVANCED

## Share and HPCC storage
Create a share in Settings/Resources/ADVANCED/FILE SHARING

For example
```code
C:\hpcc-data
```
Under C:\hpcc-data create following sub-directories
```code
dalistorage
dropzone
hpcc-data
queries
sasha
```
## Deploy storage
* Make sure Kubernetes is started. To verify run "kubectl get nodes"
* Download HPCC helm-chart: git clonet https://github.com/hpcc-systems/helm-chart. Checkout the version: git checkout <version>

To Deploy storage go to <helm-chart>/helm and run
```code
helm install hpcc-localfile examples/local/hpcc-localfile --set common.hostpath=/c/hpcc-data
```
To verify
```code
kubectl get pvc
```


You will need to provide "/c/hpcc-data" when deploy storage in Kubernetes. 

