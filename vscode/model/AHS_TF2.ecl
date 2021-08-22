IMPORT $;
IMPORT Std.System.Thorlib;
IMPORT GNN.Internal.Types AS iTypes;


kString := iTypes.kString;
nNodes := Thorlib.nodes();
node := Thorlib.node();
globalScope := 'keras_' + node + '.ecl';

#OPTION('outputLimit',100);
IMPORT PYTHON3 AS PYTHON;

TFStatus := RECORD
    STRING text;
END;

STREAMED DATASET(TFStatus) AHSCNN () := EMBED(Python: globalscope(globalScope), activity)

    try:
      import numpy as np
      import time
      import tensorflow as tf
      import tensorflow_hub as hub
      import datetime
      import traceback as tb

      mobilenet_v2 = 'https://tfhub.dev/google/tf2-preview/mobilenet_v2/feature_vector/4'
      feature_extractor_model = mobilenet_v2
      feature_extractor_layer = hub.KerasLayer(
        feature_extractor_model,
        input_shape=(224, 224, 3),
        trainable=False)

      data_root = '/var/lib/HPCCSystems/mydropzone/ahs-yes-no'
      batch_size = 32
      img_height = 224
      img_width = 224
      
     

      train_ds = tf.keras.preprocessing.image_dataset_from_directory(
        str(data_root),
        validation_split=0.2,
        subset='training',
        seed=123,
        image_size=(img_height, img_width),
        batch_size=batch_size
      )
      val_ds = tf.keras.preprocessing.image_dataset_from_directory(
        str(data_root),
        validation_split=0.2,
        subset='validation',
        seed=123,
        image_size=(img_height, img_width),
        batch_size=batch_size
      )

      class_names = np.array(train_ds.class_names)
      print(class_names)

      normalization_layer = tf.keras.layers.experimental.preprocessing.Rescaling(1./255)
      train_ds = train_ds.map(lambda x, y: (normalization_layer(x), y)) # Where x—images, y—labels.
      val_ds = val_ds.map(lambda x, y: (normalization_layer(x), y)) # Where x—images, y—labels.

      AUTOTUNE = tf.data.AUTOTUNE
      train_ds = train_ds.cache().prefetch(buffer_size=AUTOTUNE)
      val_ds = val_ds.cache().prefetch(buffer_size=AUTOTUNE)

      for image_batch, labels_batch in train_ds:
        print(image_batch.shape)
        print(labels_batch.shape)
        break

      #feature_batch = feature_extractor_layer(image_batch)
      #print(feature_batch.shape)

      num_classes = len(class_names)

      model = tf.keras.Sequential([
        feature_extractor_layer,
        tf.keras.layers.Dense(num_classes)
      ])
      model.summary()
 
      model.compile(
        optimizer=tf.keras.optimizers.Adam(),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=['acc'])

      log_dir = "logs/fit/" + datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
      tensorboard_callback = tf.keras.callbacks.TensorBoard(
         log_dir=log_dir,
         histogram_freq=1) # Enable histogram computation for every epoch.

      NUM_EPOCHS = 5

      history = model.fit(train_ds,
                    validation_data=val_ds,
                    epochs=NUM_EPOCHS,
                    callbacks=tensorboard_callback)


      predicted_batch = model.predict(image_batch)
      #predicted_id = tf.math.argmax(predicted_batch, axis=-1)
      #predicted_label_batch = class_names[predicted_id]
      #return predicted_label_batch

     
    except:
      
      return [tb.print(Exception, err)]
    finally:
       return ["Succeed"]
ENDEMBED;  

OUTPUT(AHSCNN());