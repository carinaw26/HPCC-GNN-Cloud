#!/bin/bash

WORK_DIR=$(dirname $0)
source ${WORK_DIR}/configuration
[[ -n "$1" ]] && source $1

# Set subscription
az account set --subscription $SUBSCRIPTION

# Create Resource Group
rc=$(az group exists --name ${RESOURCE_GROUP})
if [ "$rc" = "true" ]
then
    echo "Delete Resource group ${RESOURCE_GROUP}."
    time az group delete --name ${RESOURCE_GROUP} --yes
fi
AKS_CONTEXT=${AKS_NAME}-admin
kubectl config get-contexts | grep -q ${AKS_CONTEXT}
if [ $? -eq 0 ]
then
  kubectl config delete-context $AKS_CONTEXT
  kubectl config delete-cluster $AKS_NAME
fi
