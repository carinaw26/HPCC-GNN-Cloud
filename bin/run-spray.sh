#!/bin/bash

#./spray-dfu.sh -n <pod name> -i <eclwatch cluster ip> -d <dateset name>
#    <options>:
#      -i <value> : eclwatch cluster ip or other ip
#      -d <value> : dataset name
#      -n <value> : pod name
#      -p <value> : eclwatch port. The default is 8010
#      -s <value> : multiple source files separated by comma.

#dir_list="s123450 s123451 s123452 s123453 s123454 s123455 s123456 s123457 x1 x2 x3 x4"
#dir_indexs="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20"
#dir_indexs="0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18"
dir_indexs="19 20 21 22"
#dir_indexs="2 3"
#ahsORnot3/ahs-0   ahsORnot3/ahs-11  ahsORnot3/ahs-14  ahsORnot3/ahs-17  ahsORnot3/ahs-2   ahsORnot3/ahs-4  ahsORnot3/ahs-7
#ahsORnot3/ahs-1   ahsORnot3/ahs-12  ahsORnot3/ahs-15  ahsORnot3/ahs-18  ahsORnot3/ahs-20  ahsORnot3/ahs-5  ahsORnot3/ahs-8
#ahsORnot3/ahs-10  ahsORnot3/ahs-13  ahsORnot3/ahs-16  ahsORnot3/ahs-19  ahsORnot3/ahs-3   ahsORnot3/ahs-6  ahsORnot3/ahs-9
ip=10.0.181.58
podName=dfuserver-7749fcd8fc-xhsqr
for index in  ${dir_indexs}
do
  echo "./spray-dfu.sh -n $podName \
	               -i $ip \
		       -d ~ahs-${index}::cw \
		       -s /var/lib/HPCCSystems/mydropzone/ahsORnot3/ahs-${index}/*.bmp"
  ./spray-dfu.sh -n $podName \
	         -i $ip \
		 -d ~ahs-${index}::cw \
		 -s /var/lib/HPCCSystems/mydropzone/ahsORnot3/ahs-${index}/*.bmp
  sleep 30
done

