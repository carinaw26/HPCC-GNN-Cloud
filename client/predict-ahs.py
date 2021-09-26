'''
Prerequisities:
  TensorFlow 2.0+
  numpy
  pillow
'''
import sys
import os
import os.path
import getopt
import numpy as np
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # 0: DEBUG, 1: INFO, 2: WARNING, 3:ERROR
import tensorflow as tf
import PIL.Image as Image

class PredictAHS(object):
  '''
  This class utilize a pre-trained TensorFlow model to predict if an input image 
  an American Heritage student or not.
  '''

  def __init__(self):
    '''
    The default constructor
    '''
    
    self.model_path            = None
    self.model            = None
    self.image_path       = None
    self.image            = None
    self.category         = ['No', 'Yes']
    self.image_shape      = (224,224)

  def usage (self):
    print("Usage predict_ahs.py [option(s)]\n")
    print("  -?, --help               print help")
    print("  -i, --image_path         Input image path. For example, /tmp/s123.bmp")
    print("  -m, --model_path         AFS model path. For example. /tmp/tf_model/ahs")
    print("\n")
    exit(1)

  def process_args(self):
    try:
      opts, args = getopt.getopt(sys.argv[1:],":i:m:",
        ["help", "image_path","model_path"])
                 
    except getopt.GetoptError as err:
      print(str(err))
      self.usage()

    for arg, value in opts:
      if arg in ("-?", "--help"):
        self.usage()
      elif arg in ("-i", "image_path"):
        self.image_path = value
      elif arg in ("-m", "model_path"):
        self.model_path = value
      else:
        print("\nUnknown option: " + arg)
        self.usage()

  def validate_args(self):
    if not (self.model_path or self.image_path):
      print("\n Missing mode_path or image_path.\n")
      self.usage()
    if not os.path.isdir(self.model_path):
      print("\nModel " + self.model_path + " does not exist.\n")
      exit(1)
    if not os.path.isfile(self.image_path):
      print("\nImage " + self.image_path + " does not exist.\n")
      exit(1)

  def loadModel(self):
    self.model = tf.keras.models.load_model(self.model_path)

  def modelSummary(self):
    self.model.summary()

  def prepareImage(self):
    self.image = Image.open(self.image_path).resize(self.image_shape)
    self.image = np.array(self.image)/255.0

  def predictImage(self):
    result = self.model.predict(self.image[np.newaxis, ...])
    predicted_class = np.argmax(result[0], axis=-1)
    print("Is this an AH student? " + self.category[predicted_class])
     
  def predict(self):
    self.loadModel()
    self.prepareImage()
    self.predictImage()

if __name__ == '__main__':

  pa = PredictAHS()
  pa.process_args()
  pa.validate_args()
  pa.predict()
  