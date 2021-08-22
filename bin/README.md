# Utility files
## Upload and Spray
To upload a directory to landingzone on cloud:
```code
./cp2landingzone.sh <source directory> <pod name>
```

To spray from ECL Watch:
Go to the Landing Zones
1. Select the files
2. Click "BLOB"
3. Set the Target Name (e.g. ~ahstest4::cw)
4. Set the BLOB Prefix as "FILENAME,FILESIZE"
5. Click "Overwrite"
6. Click "Spray"

To upload from Command Line:
```code
kubectl cp <folder name> <dfuserver> <pod name>:/var/lib/HPCCSystems/mydropzone/
```
To spray
```code
./spray-dfu.sh -d <dataset name> -n <dfuserver name> -s <source files name or patten in landingzone>
```