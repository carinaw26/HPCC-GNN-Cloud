#!/bin/bash
usage()
{
   echo "cp2landingzone.sh <source> <pod name>" 
   exit 1
}
if [ -z "$1" ]
then
  echo "Missing source"
  usage
fi
source=$1

if [ -z "$2" ]
then
  echo "Missing pod name"
  usage
fi
pod_name=$2
kubectl cp ${source} ${pod_name}:/var/lib/HPCCSystems/mydropzone/
## 
