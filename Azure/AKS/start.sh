#!/bin/bash
WORK_DIR=$(dirname $0)
source ${WORK_DIR}/configuration
[[ -n "$1" ]] && source $1

error ()
{
  echo "$1"
  exit -1
}
run ()
{
  ${WORK_DIR}/create-resource-group.sh $1
  [[ $? -ne 0 ]] && error "Failed to create resource group"
  ${WORK_DIR}/create-aks.sh $1
  [[ $? -ne 0 ]] && error "Failed to create AKS"
  ${WORK_DIR}/add-nodepools.sh $1
  [[ $? -ne 0 ]] && error "Failed to add node pools"
  az aks nodepool delete -g ${RESOURCE_GROUP} --cluster-name ${AKS_NAME} -n ${INIT_NP_NAME}
}

time run $1
