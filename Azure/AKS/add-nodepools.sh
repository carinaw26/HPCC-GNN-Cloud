#!/bin/bash
WORK_DIR=$(dirname $0)
source ${WORK_DIR}/configuration
[[ -n "$1" ]] && source $1

index=1
for np in "${node_pools[@]}"
do
  echo "add nodepool $index ..."
  index=$(expr $index + 1)
  az aks nodepool add $(eval echo ${np})
done
