# Create a AKS with Spot Instance

## Introduction
Using spot instances can reduce costs. Beware the spot instance node may be evicted so it may not be safe to use in a production environment unless proper recovery procedures are in place. Normally spot instances are suitable for development and testing.

Reference https://docs.microsoft.com/en-us/azure/aks/spot-node-pool

## Prepare Configuration file
Edit configuration file at least for following:
```code
SUBSCRIPTION
RESOURCE_GROUP
REGION
TAGS # The default tags are for LexisNexis 
```
## Create AKS
./start.sh

Since Spot Instance Node Pool is used remember to add "placements" in hpcc/values.yaml
See following "ADD toleration ..." section for detail

## Delete AKS
./delete-aks.sh


## Manage Existing AKS
```code
az aks get-credentials --resource-group {resource group name} --name {aks name} --admin
```
Example
```code
az aks get-credentials --resource-group spot-gnn-carina --name aks-spot-gnn-carina-canadacentral --admin
```
To verify:
```code
kubectl config current-context
kubectl get nodes
```

## Some details about AKS creation

### Create Kuberentes with Spot Instance
The spot instance can only be used in user mode node pool. The system node pool cannot have spot instances.

Normally add the following to create the node pool with spot instances:
```code
   --priority Spot \
   --eviction-policy Delete \
   --spot-max-price -1 \
   --mode user \
```

### Taint system node pool
In multiple node pools setup we usually don't want user application deployed in system node pool. But adding taint to default system node pool may not be easy. We can create another system node pool and delete the origial system node.


### Add "toloerations" to use the spot instance node pool
The spot instance node will be tainted automatically with: "kubernetes.azure.com/scalesetpriority=spot:NoSchedule" <br/>
To allow the HPCC cluster to be deployed to spot instance node pool add these in values.yaml:
```code
placements:
  - pods: ["all"]
    placement:
      tolerations:
        - key: "kubernetes.azure.com/scalesetpriority"
          operator: "Equal"
          value: "spot"
          effect: "NoSchedule"
```
