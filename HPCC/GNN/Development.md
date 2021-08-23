# GNN Model Development

## Prerequisities
1. Make sure HPCC cluster with Docker image platform-gnn is deployment
2. Run GNN/Test/SetupTest.ecl to verify GNN is ready to use

## GNN Tutorial
All HPCC Machine Learning links: https://learn.lexisnexis.com/Activity/2553

Generalized Neural Network (GNN) Tutorial (Part 1)
```code
https://learn.lexisnexis.com/lexisnexis/resources/courses/HPCC/Advanced_Thor/Lesson_21_ML5_GNNTutorial/Lesson_ML5_GNNTutorial.html
```
Generalized Neural Network (GNN) Tutorial (Part 2)
```code
https://learn.lexisnexis.com/lexisnexis/resources/courses/HPCC/Advanced_Thor/Lesson_22_ML6_GNNTutorial2/Lesson_ML6_GNNTutorial2.html
```

## Prepare Dataset 
[How to define Dataset from spray logic file](../vscode/model/File_Image.ecl)
[How create the Dataset from the definition](../vscode/model/BWR_Image.ecl)

For Amerian Heritage Student (AHS) data reference
[How to define Dataset from AHS logic file](../vscode/model/AHSFile_Image.ecl)
[How create the Dataset from the definition](../vscode/model/AHS_Image.ecl)

## Create GNN Model
[How create Tensor and GNN sequential model](../vscode/model/BWR_ImageGNN.ecl)

For Amerian Heritage Student (AHS) data reference
[How create Tensor and GNN with MobileNetV2 model](../vscode/model/AHS_GNN_TL3.ecl)
Beware this model require DefineKAModel function. If your GNN bundle doesn't have it update GNNI.ecl and Keras.ecl which are provided in bundle directory.

The basic code block is like this:
```code
// Pick a Keras Application
modelName := 'MobileNetV2';
//modelName := 'Xception';
//modelName := 'NASNetMobile';
//modelName := 'DenseNet169';

// Keras Application function definition
fdef := '''input_shape=(224,224,3),include_top=True,weights=None,classes=2''';

// compile definition
compileDef := '''compile(optimizer=tf.keras.optimizers.Adam(),
                 loss=tf.keras.losses.binary_crossentropy,
                 metrics=[tf.keras.metrics.BinaryAccuracy()])
                 ''';
mod := GNNI.DefineKAModel(s, modelName, fdef, compileDef);

```
### Current limitations
Due to JIRA https://track.hpccsystems.com/browse/HPCC-26366 following code need comment out. Otherwise train and predict will fail
```code
//OUTPUT(metrics, NAMED('metrics'));
//OUTPUT(SORT(predDatClass, indexes), ALL, NAMED('predDat'));
```

## Run
Depends where to run. For VSCode reference [VSCode README](../../vscode/README.md)


## Check Results
### From EclWatch
Click the workunit for the status and outputs

### From kubectl logs
During the thorworker execution run
```code
kubectl logs <thorworker pod name>
```
Just show the loss and accuracy
```code
kubectl logs <thorworker pod name> | grep "===="

```

### Terminate failed jobs
Sometimes failed jobs will not clean themselves. You need run followint to terminate them
```code
kubectl delete job --all
```



