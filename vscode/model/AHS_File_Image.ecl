IMPORT STD;
EXPORT AHS_File_Image := MODULE
 EXPORT imageRecord := RECORD
  STRING filename;
//first 4 bytes contain the length of the image data
  UNSIGNED8  RecPos{virtual(fileposition)};
  DATA   image;   
 END;
 //EXPORT imageData := DATASET('~imagedb::bmf',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahs224::cw',imageRecord,FLAT);
 EXPORT trainImageData := DATASET('~ahs4579::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahstrain420::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahstrain369::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahs4545::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahs4579::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahs4839::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahstrain4000::cw',imageRecord,FLAT);
 //EXPORT trainImageData := DATASET('~ahstrain7::cw',imageRecord,FLAT);
 EXPORT testImageData := DATASET('~ahstest23::cw',imageRecord,FLAT);
 //EXPORT testImageData := DATASET('~ahstest30::cw',imageRecord,FLAT);
 //EXPORT imageData := DATASET('~plane::data::landingzone::data::*.bmp',imageRecord,FLAT);
 //EXPORT imageData := DATASET('~file::localhost::var::lib::^H^P^C^C^Systems::hpcc-data::landingzone::data::*.bmp',imageRecord,FLAT);
 //Add RecID and Dependent Data
 EXPORT imageRecordPlus := RECORD
   UNSIGNED4 RecID; 
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