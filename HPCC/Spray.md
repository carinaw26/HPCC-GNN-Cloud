# Upload Images and Spray

## Through EclWatch
### Upload
On EclWatch 
1. click "Files" icon, click "Landing Zones". 
2. Click "Upload" to upload your files
### Spray
On EclWatch 
1. click "Files" icon
2. click "Landing Zones".
3. From mydropzone select all the files you want to spray
4. click "BLOB"
   * File "Target Name" with format ~<name>::<your initial>. For example ~abstrain::cw
   * In "BLOB Prefix" fill: FILENAME,FILESIZE
   * mark "Overwrite"
   * press "Spray" button


## Through Command-line
### Upload
Find dfuserver pod name:
```code
kubectl get pod 
```
Upload your directory or files:
```code
kubectl cp <source dir or files> <dfuserver pod name>:/var/lib/HPCCSystems/mydropzone/
```

### Spray
Spray with dfuplus
```code
kubectl exec -t <pod name> -- /opt/HPCCSystems/bin/dfuplus action=spray nolocal=true srcip=127.0.0.1 srcfile=<source files name or pattern> dstname=<logic file name> dstcluster=data overwrite=1 prefix=FILENAME,FILESIZE nosplit=1 server=<eclwatch cluster ip>:8010
```
Where
- <pod name> is dfuserver pod name
- <source files or pattern> /var/lib/HPCCSystems/mydropzone/two_folders/ahs/*.bmp,/var/lib/HPCCSystems/mydropzone/two_folders/notahs/*.bmp
- <logic file name>: logic file name. For example "~ahs4839:cw"
- <eclwatch cluster ip>: internal eclwatch ip. It is OK if giving external eclwatch ip

There is a helper script bin/spray-dfu.sh
```code
./spray-dfu.sh -i 10.0.183.76 -d "~ahs4839::cw" -n dfuserver-5b7b876f99-prlcw -s /var/lib/HPCCSystems/mydropzone/two_folders/ahs/*.bmp,/var/lib/HPCCSystems/mydropzone/two_folders/notahs/*.bmp
```
run ./spray-dfu.sh --help for the usage

