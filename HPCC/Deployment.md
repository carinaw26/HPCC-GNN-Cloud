# Deploy HPCC Platform on Cloud

## Prerequisities

- Kubernetes cluster is ready 
  * [Azure](../Azure/AKS/README.md)
  * [Local](../Local/README.md)
- Storage is deployed
  * [Azure](../Azure/storage/README.md)
  * [Local](../Local/DD/README.md)


## HPCC Helm Chart
```code
git clone https://github.com/hpcc-systems/helm-chart.git
cd helm-char
git checkcout <version>
```
The <version> should match the Docker image version. For example, 8.2.10

## Update values.yaml
- Change ECLWatch service visibility to gloabl in the values.yaml file
- Since we're using spot instances, add this to the hpcc/values.yaml file:
```code
placements:
- pods: ["all"]
  placement:
    tolerations:
    - key: "kubernetes.azure.com/scalesetpriority"
      operator: "Equal"
      value:  "spot"
      effect: "NoSchedule"
```
- "thorworker" resources. You may need increase number of thorworker and cpu and memory. 
  Here are some suggestions for all images: 4500+ 
  * For one thor worker set cpu: 8 and memroy: 16GB
  * For two or more thor workers set cpu: 4 and memory 8GB

## Deploy
cd to helm directory
#### Local

``code
helm install hpcc hpcc --set global.image.version=<version> --set global.image.name=platform-gnn  -f examples/local/values-localfile.yaml
```
#### Azure

``code
helm install hpcc hpcc --set global.image.version=<version> --set global.image.name=platform-gnn  -f examples/azure/values-retained-azurefile.yaml
```
```
to verify
```code
kubectl get pods
```
get ECLWatch IP with:
```code
kubectl get service
```
- On your browser, copy and paste the ECLWatch IP with the port 8010 to see if you can access ECLWatch

