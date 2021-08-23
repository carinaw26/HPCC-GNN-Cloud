# GNNN Bundle Update
This directory include Keras.ecl and GNNI.ecl which implement JIRA HPCC ML-484 "add Keras Application support"
A new function DefineKAModel is defined:
```code
 /**
    * Load a Keras Application model with its function definition. Optionally,
    * also provide a "compile" line with the compilation parameters for the
    * model.
    * Keras Application reference: https://keras.io/api/applications/
    * <p>If no compile line is provided (cdef), then the compile specification
    * can be provided in a subsequent call to CompileMod (below).
    * <p> "fname" is for the model/function name for the Keras Application
    * <p> "fdef" is for the model function definition, i.e. what input parameters can be
    * supplied.
    * See GNN/Test/ClassicTest.ecl for an annotated example.
    * @param sess The session token from a previous call to GetSesion().
    * @param fname A name of the Keras Application. See "supportedModle" in following DefineKAModel for the list.
    * @param fdef input parameters passed to the model creation. Reference
    *        https://keras.io/api/applications/ for each model function parameters.
    *        A simple usage could be:
    *          fdef  := '''input_shape=(224,224,3),include_top=True,weights=None,classes=2'''
    *        (224, 224, 3) is the size of the image. "classes=2" means the images will be classified
    *        with two labels.
    * @param cdef (optional) A python string as would be passed to Keras model.compile(...).
    *         This line should begin with "compile".  Model is implicit here.
    * @return A model token to be used in subsequent GNNI calls.
    */

EXPORT UNSIGNED4 DefineKAModel(UNSIGNED4 sess, STRING fname, STRING fdef, STRING cdef = '') := FUNCTION
    SET OF STRING supportedModels := [
                                //  Year       Size        Depth     Default Shape
                                //  -----------------------------------------------
      'Xception',               //  2017        88 MB        126     (229,229,3)
      'VGG16',                  //  2015       528 MB         23     (224,224,3)
      'VGG19',                  //  2015       549 MB         26     (224,224,3)
      'ResNet50',               //  2015        98 MB          -     (224,244,3)
      'ResNet101',              //  2015       171 MB          -     (224,224,3)
      'ResNet152',              //  2015       232 MB          -     (224,224,3)
      'ResNet50V2',             //  2016        98 MB          -     (224,224,3)
      'ResNet101V2',            //  2016       171 MB          -     (224,224,3)
      'ResNet152V2',            //  2016       232 MB          -     (224,224,3)
      'InceptionV3',            //  2016        92 MB        159     (229,229,3)
      'InceptionResNetV2',      //  2017       215 MB        572     (229,229,3)
      'MobileNet',              //              16 MB         88     (224,224,3)
      'MobileNetV2',            //  2018        14 MB         88     (224,224,3)
      'DenseNet121',            //  2017        33 MB        121     (224,224,3)
      'DenseNet169',            //  2017        57 MB        169     (224,224,3)
      'DenseNet1201',           //  2017        80 MB        201     (224,224,3)
      'NASNetMobile',           //  2018        23 MB          -     (224,224,3)
      'NASNetLarge',            //  2018       343 MB          -     (331,331,3)
      'EfficientNetB0',         //  2019        29 MB          -
      'EfficientNetB1',         //  2019        31 MB          -
      'EfficientNetB2',         //  2019        36 MB          -
      'EfficientNetB3',         //  2019        48 MB          -
      'EfficientNetB4',         //  2019        75 MB          -
      'EfficientNetB5',         //  2019       118 MB          -
      'EfficientNetB6',         //  2019       166 MB          -
      'EfficientNetB7'          //  2019       256 MB          -
    ];

......
 END;
```
If this function is not available in your GNN bundle you can repalce GNNI.ecl and Keras.ecl with these two files.
On Windows the bundles should be under c:/Users/<name>/AppData/Roaming/HPCCSystems/bundles/
