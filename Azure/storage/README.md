## Azure Storage Setup
###Checkout HPCC Helm Chart
```code
git clone https://github.com/hpcc-systems/helm-chart.git
cd helm-chart
git checkout 8.2.6
```
We are currently using 8.6. You can use a different version as long as it matches the Docker Image version

### Create Storage Account and Shares
- Uncomment the "shareName" commands, "secretName", and "secretNamespace" in the values.yaml file directory: helm-chart/example/azure/hpcc-azurefile
- Edit env-sa
file directory: helm-chart/example/azure/sa/env-sa

```code
SUBSCRIPTION=us-hpccplatform-dev
STORAGE_ACCOUNT_NAME=gnncarina
SA_RESOURCE_GROUP=gnn-carina-sa
SA_LOCATION=canadacentral
```

- Create storage account
directory: /Users/carinawang/work/intern2021/hpcc/helm-chart/helm/examples/azure/sa

run:
```code
./create-sa.sh
```

- Everytime we create a new AKS, we need to generate a secret for the storage account
directory: /Users/carinawang/work/intern2021/hpcc/helm-chart/helm/examples/azure/sa
run: 
```code
./create-secret.sh
```
- Create storage
```code
helm install azstorage hpcc-azurefile/
```

check with:
```code
kubectl get pvc
``` 