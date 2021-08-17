#!/bin/bash

SRC=./original
DES=./ahsORnot13
[ -d $DES ] && rm -rf $DES
mkdir -p $DES
numPerGroup=21

max_limit=200
index=0
file_count=0
prefix=ahs
#mkdir -p $DES/ahs $DES/not
cur_dir=${prefix}-${index}

echo "Create ${DES}/${cur_dir}"
mkdir -p ${DES}/$cur_dir
ls -d -A ${SRC}/s* > work_dirs
while read d
do
  num=0
  ls -A ${d} | sort -R | grep ".bmp" > files
  while read f
  do
     file_count=$(expr $file_count \+ 1) 
     if [ $(expr $file_count \%  $max_limit) -eq 0 ]
     then
       index=$(expr $index \+ 1)
       cur_dir=${prefix}-${index}
       echo "Create ${DES}/${cur_dir}"
       mkdir -p ${DES}/${cur_dir}
     fi
     f2=$(echo $f | cut -d'.' -f1)
     cp ${d}/${f} ${DES}/${cur_dir}/${f2}-ahs.bmp 
     num=$(expr $num \+ 1)
     [ $num -gt $numPerGroup ] && break 

  done < ./files
done < ./work_dirs

file_count=$(find ${DES} -name *.bmp | wc -l)
index=$(ls -d -l ${DES}/* | wc -l)
index=$(expr $index \- 1)
cur_dir=${prefix}-${index}

ls -d -A ${SRC}/x* > work_dirs
while read d
do
  num=0
  ls -A ${d} | sort -R | grep ".bmp" > files
  while read f
  do
     file_count=$(expr $file_count \+ 1) 
     if [ $(expr $file_count \%  $max_limit) -eq 0 ]
     then
       index=$(expr $index \+ 1)
       cur_dir=${prefix}-${index}
       #echo "Create ${DES}/${cur_dir}"
       mkdir -p ${DES}/$cur_dir
     fi
     f2=$(echo $f | cut -d'.' -f1)
     cp ${d}/${f} ${DES}/${cur_dir}/${f2}-not.bmp 
     num=$(expr $num \+ 1)
     [ $num -gt $numPerGroup ] && break 
  done < ./files
done < ./work_dirs


exit

test_dir=${DES}-test
[ -d $test_dir ] && rm -rf $test_dir
mkdir -p ${test_dir}

ls -d -A ${DES}/* | while read d
do
  ls $d/ | sort -R | tail -4| while read f
  do
     echo "Move ${d}/${f} ${test_dir}/"
     mv ${d}/${f} ${test_dir}/
  done
done
