IMPORT STD;
EXPORT AHS_File_Image := MODULE
 EXPORT imageRecord := RECORD
  STRING filename;
//first 4 bytes contain the length of the image data
  UNSIGNED8  RecPos{virtual(fileposition)};
  DATA   image;   
 END;
 EXPORT trainImageData := DATASET('~trainahs256::cw',imageRecord,FLAT);
 EXPORT testImageData := DATASET('~testahs6::cw',imageRecord,FLAT);
 //Add RecID and Dependent Data
 EXPORT imageRecordPlus := RECORD
   UNSIGNED1 RecID; 
   UNSIGNED1 YType;
   imageRecord;
 END;
 
  EXPORT mytraindata := PROJECT(trainImageData, 
	                  TRANSFORM(imageRecordPlus,
	                  SELF.RecID := COUNTER,
					  SELF.YType := IF(STD.STR.Find(LEFT.filename,'ahs')<> 0,1,0),;
					  SELF.Image := LEFT.IMAGE[55..], // tried 51, 54, 109
					  SELF := LEFT)):PERSIST('~GNNTutorial::AHS:Train'); 

  EXPORT mytestdata := PROJECT(testImageData, 
	                  TRANSFORM(imageRecordPlus,
	                  SELF.RecID := COUNTER,
					  SELF.YType := IF(STD.STR.Find(LEFT.filename,'ahs')<> 0,1,0),;
					  SELF.Image := LEFT.IMAGE[55..], // tried 51, 54, 109
					  SELF := LEFT)):PERSIST('~GNNTutorial::AHS:Test'); 
	END;
