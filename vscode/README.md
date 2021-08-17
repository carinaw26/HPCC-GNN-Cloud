# HPCC-GNN-Cloud
```code
Processing student image data using Kubernetes on HPCC Cloud Native Platform
Training 4,000+ student images on HPCC GNN and TensorFlow Jupyter Notebook models 
Classifies images as "AHS" or "Not AHS"
```
## Kubernetes Setup
Create AKS cluster on Azure
Deployed HPCC
Follow the README.md file in the AKS folder
### Use AKS Created by Others
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
## Deploy HPCC
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
hpcc/helm-chart/helm
run:
```code
helm install hpcc hpcc/ --set global.image.version=8.2.6 --set global.image.name=platform-gnn -f examples/azure/values-retained-azurefile.yaml
```
check with:
```code
kubectl get pod
```
get ECLWatch IP with:
```code
kubectl get service
```
- On your browser, copy and paste the ECLWatch IP with the port 8010 to see if you can access ECLWatch
- Upload images in the bin directory

To get your dfuserver pod name:
```code
kubectl get pods
```
Then run:
```code
./cp2landingzone.sh /Users/carinawang/work/intern2021/images/two_folders dfuserver-5b7b876f99-prlcw
``` 

## Spray
```code
./spray-dfu.sh -i 20.200.81.221 -d "~ahs4839::cw" -n dfuserver-5b7b876f99-prlcw -s /var/lib/HPCCSystems/mydropzone/two_folders/ahs/*.bmp,/var/lib/HPCCSystems/mydropzone/two_folders/notahs/*.bmp 
```
- In launch.json (vscode workspace), update the ECLWatch IP
- In the AHS_File_Image.ecl file, update the new dataset name in this line:
```code
EXPORT trainImageData := DATASET('~ahs4839::cw',imageRecord,FLAT);
```

- To change the thor slave number, go to helm-chart/hpcc/values.yaml

Change the numWorkers:
```code
thor:
- name: thor
  prefix: thor
  numWorkers: 2
  maxJobs: 4
  maxGraphs: 2
```
- To check how many epochs:
AHS_GNN_TL3.ecl
```code
mod2 := GNNI.Fit(mod, tensTrain, Ytrain, batchSize := 32, numEpochs := 10);
OUTPUT(mod2, NAMED('mod2'));
```
- ECL sumbit the AHS_Images.ecl file
- Train the Model
ECL submit AHS_GNN_TL3.ecl

- Everytime you change the number of thor slaves, shut down the previous cluster by running:
```code
helm delete hpcc
```
Make sure to run kubectl get pods and kubectl get service to check that there are no hpcc resources left running.

Then, change the numWorkeres in the values.yaml file
Finally, run helm install again at /Users/carinawang/work/intern2021/hpcc/helm-chart/helm:
```code
helm install hpcc hpcc/ --set global.image.version=8.2.8 --set global.image.name=platform-gnn -f examples/azure/values-retained-azurefile.yaml
```
Finally, run the AHS_GNN_TL3.ecl file

On ECLWatch under Workunits, you can view the progress. To check the specific accuracy percentage, run kubectl logs thorworker-w20210810-164813-graph3-2nkg6 

To find the thor slave pod name, run kubectl get pod and copy/paste any of the thorworker names

When running this command, there will be an overwhelming number of results. To narrow it down, run:

```code
kubectl logs thorworker-w20210810-164813-graph3-2nkg6 | grep ====
```


How to change the number of thor workers:
run:
```code
helm delete hpcc
```
run:
```code
kubectl get service 
kubectl get pods
```
There should only be 1 kubernetes service left after running get service.
After running get pods, there should be nothing left.
To delete a pod:
```code
kubectl delete job --all
```
Then, you can change the numWorkers in hpcc/values.yaml
Helm Install HPCC (/Users/carinawang/work/intern2021/hpcc/helm-chart/helm)
```code
helm install hpcc hpcc/ --set global.image.version=8.2.6 --set global.image.name=platform-gnn -f examples/azure/values-retained-azurefile.yaml
```
Run kubectl get pods. Wait for everything to be ready.
Run kubectl get service. Copy and paste the ECL Watch IP into launch.json
Save the file then run AHS_GNN_TL3.ecl
## GNN Tutorial

## AHS Image Classification
### Image preparation

### CNN Model
