## Azure Storage Setup
###Checkout HPCC Helm Chart
Download hpcc-chart.git if haven't.
```code
git clone https://github.com/hpcc-systems/helm-chart.git
cd helm-chart
git checkout <version> # The version should match HPCC Platform Docker image version, for example, 8.2.10

```

### Create Storage Account and Shares
- Uncomment the "shareName" commands, "secretName", and "secretNamespace" in the values.yaml file directory: helm-chart/example/azure/hpcc-azurefile. You may want to update share size based on the data you will process and how many workunits you want to keep. A sample values.yaml is provided for 5000 images files and workunits are kept for a 8 weeks intern project. 
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
