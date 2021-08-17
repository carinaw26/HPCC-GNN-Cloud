#!/bin/bash
WORK_DIR=$(dirname $0)
source ${WORK_DIR}/configuration
[[ -n "$1" ]] && source $1
#[[ -n "$STORAGE_DIR" ]] &&  source ${WORK_DIR}/../../Storage/${STORAGE_DIR}/configuration

# Create a Kubernetes Cluster
echo "az aks create  $(eval echo ${AKS_CREATE_OPTIONS}) "
az aks create  $(eval echo ${AKS_CREATE_OPTIONS})

# Register Kubernetes cluster to local configure file
az aks get-credentials \
   --resource-group ${RESOURCE_GROUP} \
   --name ${AKS_NAME} \
   --admin \
   --overwrite-existing

if [[ -n "$STORAGE_DIR" ]]
then
  echo "create secret $SECRET_NAME"
  account_key=$(cat ${KEY_DIR}/${SHARE_NAME}.key | cut -d':' -f2 | sed 's/[[:space:]]\+//g')
  kubectl create secret generic $SECRET_NAME \
    --from-literal=azurestorageaccountname=${STORAGE_ACCOUNT_NAME} \
    --from-literal=azurestorageaccountkey=${account_key}
fi
