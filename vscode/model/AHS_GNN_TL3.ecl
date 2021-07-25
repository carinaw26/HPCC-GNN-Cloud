IMPORT $;
IMPORT Python3 AS Python;
IMPORT GNN;
IMPORT GNN.Tensor;
IMPORT GNN.Internal.Types AS iTypes;
IMPORT GNN.Types;
IMPORT GNN.GNNI;
IMPORT GNN.Internal AS Int;
IMPORT GNN.Utils;
IMPORT Std.System.Thorlib;

// Data Preparation
imagerecord := $.AHS_File_Image.imageRecordPlus;
// plusrecs    := SORT($.AHS_File_Image.ImageDataPlus,recid);
mytraindata := $.AHS_File_Image.mytraindata;
mytestdata  := $.AHS_File_Image.mytestdata;
// mytraindata := PROJECT(plusrecs[1..14],imagerecord):PERSIST('~GNNTutorial::AHS:Train');
// mytestdata  := PROJECT(plusrecs[15..17],imagerecord):PERSIST('~GNNTutorial::AHS::Test');   
Tensdata    := Tensor.R4.TensData;

//create a Tensor of shape [0,224,224,3]: height,width,channels
Channels := 3;
Rws      := 224; 
Cols     := 224;
BCount   := Channels * Rws * Cols;

//independent "X" TRAINING Data
TensData makeTensTrainXDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  Channel := (cnt - 1) % channels + 1;
  Col     := ((cnt - 1) DIV channels) % (cols) + 1;
  RowN    := ((cnt - 1) DIV (channels * cols)) % (Rws) + 1;
  SELF.indexes := [img.recid, RowN, Col, Channel];
  SELF.value   := ((REAL)(>UNSIGNED1<)img.image[cnt] - 128.0)/ 128.0;//(REAL)(>UNSIGNED1<)
END;

mytensTrainXData := NORMALIZE(mytraindata, BCount, makeTensTrainXDat(LEFT, COUNTER));

OUTPUT(mytensTrainXData,NAMED('TrainIndData'));
OUTPUT(COUNT(mytensTrainXData),NAMED('CntTrainIndData'));

tensTrain := Tensor.R4.MakeTensor([0, Rws, Cols, Channels], mytensTrainXData);
OUTPUT(tensTrain,NAMED('TrainIndTens'));

//dependent ("Y') Training Data:
// Of course, for your Y (dependent training data) youâ€™re going to need to associate some label 
// with each image and then create a tensor of shape:
// [0, 1] 
// and use Utils.ToOneHot() to change that to a one hot encoded tensor of shape [0, numClasses].  
// That is because for neural networks, class variables need to be converted to [isClass0, isClass1, isClass2, â€¦].
// See Tests ClassificationTest.ecl for an example.

TensData makeTensTrainYDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  SELF.indexes := [img.recid, 1];//first element is RECID
  SELF.value   := img.YType;
END;
myYtensTrainData := NORMALIZE(mytraindata, 1, makeTensTrainYDat(LEFT, COUNTER));
OUTPUT(myYTensTrainData,NAMED('DepTrainData'));
OUTPUT(COUNT(myYTensTrainData),NAMED('CntDepTrainData'));
yTrainHot := Utils.ToOneHot(myYtensTrainData, 2);//2 states is not a AH student, a AH student

ytrain := Tensor.R4.MakeTensor([0,2], yTrainHot); //Needs to be from yTrainHot
OUTPUT(yTrain,NAMED('TrainDepTens'));

//Independent Test Data:
TensData makeTensTestXDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  Channel := (cnt - 1) % channels + 1;
  Col     := ((cnt - 1) DIV channels) % (cols) + 1;
  RowN    := ((cnt - 1) DIV (channels * cols)) % (Rws) + 1;
  SELF.indexes := [img.recid, RowN, Col, Channel];
  SELF.value   := ((REAL)(>UNSIGNED1<)img.image[cnt] - 128.0) / 128.0;//(REAL)(>UNSIGNED1<)
END;
mytensTestXData := NORMALIZE(myTestData, BCount, makeTensTestXDat(LEFT, COUNTER));

OUTPUT(mytensTestXData,NAMED('TestIndData'));
OUTPUT(COUNT(mytensTestXData),NAMED('CntTestIndData'));

tensTest := Tensor.R4.MakeTensor([0, Rws, Cols, Channels], mytensTestXData);
OUTPUT(tensTest,NAMED('TestIndTens'));

//Dependent Test Data
TensData makeTensTestYDat(ImageRecord img, INTEGER cnt) := TRANSFORM
  SELF.indexes := [img.recid, 1];//first element is RECID
  SELF.value   := img.YType;
END;
myYtensTestData := NORMALIZE(myTestData, 1, makeTensTestYDat(LEFT, COUNTER));
OUTPUT(myYTensTestData,NAMED('TestDepData'));
OUTPUT(COUNT(myYTensTestData),NAMED('CntTestDepData'));

yTestHot := Utils.ToOneHot(myYtensTestData, 2);//2 states is a AH student, not AH student
ytest    := Tensor.R4.MakeTensor([0,2], yTestHot); //Needs to be from yTrainHot
OUTPUT(yTest,NAMED('TestDepTens'));

// GetSession must be called before any other functions
s := GNNI.GetSession();

ldef :=['''layers.Dense(2)'''];  // dummy

compileDef := '''compile(optimizer=tf.keras.optimizers.Adam(),
                 loss=tf.keras.losses.binary_crossentropy,
                 metrics=[tf.keras.metrics.BinaryAccuracy()])
                 ''';

//compileDef := '''compile(optimizer='sgd',
//                 loss=tf.keras.losses.MeanAbsolutePercentageError())
//              ''';
//compileDef := '''compile(optimizer=tf.keras.optimizers.Adam(),
//                 loss=tf.keras.losses.binary_crossentropy,
//                 metrics=[tf.keras.metrics.Accuracy()])
//			  ''';
//mod := GNNI.DefinePTModel(s, ldef);
mod := GNNI.DefinePTModel(s, ldef, compileDef);
//OUTPUT(mod, NAMED('mod'));

// GetWeights returns the initialized weights that have been synchronized across all nodes.
wts := GNNI.GetWeights(mod);
OUTPUT(wts, NAMED('InitWeights'), ALL);

// Fit trains the models, given training X and Y data.  BatchSize is not the Keras batchSize,
// but defines how many records are processed on each node before synchronizing the weights

mod2 := GNNI.Fit(mod, tensTrain, Ytrain, batchSize := 32, numEpochs := 20);
OUTPUT(mod2, NAMED('mod2'));

// GetLoss returns the average loss for the final training epoch
losses := GNNI.GetLoss(mod2);

// EvaluateMod computes the loss, as well as any other metrics that were defined in the Keras
// compile line.
metrics := GNNI.EvaluateMod(mod2, Tenstest, ytest);

//OUTPUT(metrics, NAMED('metrics'));


// Predict computes the neural network output given a set of inputs.
preds := GNNI.Predict(mod2, Tenstest);

// Note that the Tensor is a packed structure of Tensor slices.  GetData()
// extracts the data into a sparse cell-based form -- each record represents
// one Tensor cell.  See Tensor.R4.TensData.

testYDat := Tensor.R4.GetData(yTest);
predDat  := Tensor.R4.GetData(preds);

OUTPUT(SORT(testYDat, indexes), ALL, NAMED('testDat'));
OUTPUT(preds, NAMED('predictions'));
predDatClass := Utils.Probabilities2Class(predDat);
//OUTPUT(SORT(predDatClass, indexes), ALL, NAMED('predDat'));