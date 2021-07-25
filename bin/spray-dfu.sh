#!/bin/bash

usage()
{
  cat <<EOF 

  ./spray-dfu.sh -n <pod name> -i <eclwatch cluster ip> -d <dateset name>
     <options>:
       -i <value> : eclwatch cluster ip or other ip
       -d <value> : dataset name 
       -n <value> : pod name
       -p <value> : eclwatch port. The default is 8010
       -s <value> : multiple source files separated by comma.
     
EOF
  exit 1
}
podName=
#ip=10.0.46.82
ip=10.0.183.76
port=8010
dstName="~ahs224::cw"
srcFiles=/var/lib/HPCCSystems/mydropzone/ahsORnot/ahs/*.bmp,/var/lib/HPCCSystems/mydropzone/ahsORnot/not/*.bmp 
while getopts ":d:i:n:p:s:" opts; do
  case "${opts}" in
    d)
      dstName="${OPTARG}"
      ;;
    n)
      podName="${OPTARG}"
      ;;
    i)
      ip="${OPTARG}"
      ;;
    p)
      port="${OPTARG}"
      ;;
    s)
      srcFiles="${OPTARG}"
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z "$podName" ]
then
  echo "Missing pod name"
  usage
fi
if [ -z "$dstName" ]
then
  echo "Missing dataset name"
  usage
fi
if [ -z "$ip" ]
then
  echo "eclwatch ip"
  usage
fi

echo "
kubectl exec -t $podName -- /opt/HPCCSystems/bin/dfuplus action=spray nolocal=true srcip=127.0.0.1 srcfile=${srcFiles} dstname=${dstName} dstcluster=data overwrite=1 prefix=FILENAME,FILESIZE nosplit=1 server=${ip}:${port} 
"
kubectl exec -t $podName -- /opt/HPCCSystems/bin/dfuplus action=spray nolocal=true srcip=127.0.0.1 srcfile=${srcFiles} dstname=${dstName} dstcluster=data overwrite=1 prefix=FILENAME,FILESIZE nosplit=1 server=${ip}:${port}
