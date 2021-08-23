# HPCC-GNN-Cloud

Processing student image data using Kubernetes on HPCC Cloud Native Platform
Training 4,000+ student images on HPCC GNN and TensorFlow Jupyter Notebook models 
Classifies images as "AHS" or "Not AHS"

## Contents

0. [Prerquisites](##Prequisities)
1. [Preprocess Image files](./Java/README.md)
2.  Cloud Setup
   * [Azure](./Azure/README.md)
   * [Local](./Local/README.md)
3. [HPCC Cloud Deployment](./HPCC/Deployment.md)
4. [Clienttools and GNN bundle setup](./HPCC/GNN/README.md)
5. Deveployment Environment Setup
   * [VSCode](./vscode/Setup.md)
6. [Upload and Spray Images files](./HPCC/Spray.md)
7. [GNN model development](./HPCC/GNN/Development.md)
8. Training and Testing 
   * [VSCode](./vscode/Run.md)
9. [Client Application](./ClientApplication.md)
10. [Tensorflow without HPCC/GNN](./jupyter/README.md)
11. Flowcharts; ./Flowcharts


## Prequisities)
* [Helm](https://helm.sh/docs/intro/install/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/). You should already have this if you installed Docker Desktop
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

The followings are for run TensorFlow locally without HPCC/GNN
- [TensorFlow](https://www.tensorflow.org/install)
- [Jupyter Nodebook](https://jupyter.org/install)
