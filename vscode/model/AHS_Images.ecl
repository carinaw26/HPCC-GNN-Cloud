IMPORT $;

#OPTION('outputLimit',100);
$.AHS_File_Image.trainImageData;
$.AHS_File_Image.testImageData;
$.AHS_File_Image.mytraindata;
$.AHS_File_Image.mytestdata;
//imagerecord := $.AHS_File_Image.imageRecordPlus;

plusrecs := $.AHS_File_Image.mytraindata;
totalImages := COUNT(plusrecs);
img := plusrecs[1].image;
numOfValue := LENGTH(img);

OUTPUT('Total images:' + totalImages);
OUTPUT('Num of values in each image' + numOfValue);

