#!/bin/bash

WORK_DIR=$(dirname $0)
source ${WORK_DIR}/configuration
[[ -n "$1" ]] && source $1

if [[ -z "$RESOURCE_GROUP" ]]
then
  echo "Missing resource group"
  exit 1
fi

rc=$(az group exists --name ${RESOURCE_GROUP})
if [ "$rc" != "true" ]
then
  echo "Create resource group: $RESOURCE_GROUP ..."
  az group create --name $RESOURCE_GROUP --location $REGION --tags $(eval echo ${TAGS} )
fi
