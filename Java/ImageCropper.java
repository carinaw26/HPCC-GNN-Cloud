

import java.awt.image.BufferedImage;
import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.io.FilenameFilter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.awt.Graphics2D;
 

import javax.imageio.ImageIO;

/* From Video Recorder we obtain two size of image files 1280 x 1280 and 960 x 960
 * Only middle 710 x 710 area is what we needed. But the start poistion is different 
 * The one is (280, 0) and the other is (136,0). Als we want to output bmp format since
 * this is the only format GNN current supports
 * The source directory and destination directory are hard-coded. I will refactor the code later
 */
public class ImageCropper {
  public static void main(String[] args) {
    try {
      File originalDirectory=new File ("/Users/carinawang/work/intern2021/images/original");
      String croppedDirectoryName = "/Users/carinawang/work/intern2021/images/cropped";
      File [] contentsOfDirectory= originalDirectory.listFiles();
      for (File subDir : contentsOfDirectory) {
        if (subDir.isDirectory()) {
          System.out.format("File name: %s%n", subDir.getName ());
          File [] imageFiles = subDir.listFiles();
          for (File f : imageFiles) {
            if (f.isFile() && f.getName().endsWith(".jpg")) {
              BufferedImage originalImgage = ImageIO.read(f);
              //System.out.println("Original Image Dimension: "+originalImgage.getWidth()+"x"+originalImgage.getHeight());
              int x = 136;
              int y = 0;
              int w = 366;
              int h = 366;

              if (originalImgage.getWidth() == 1280) {
                x = 280;  //Horizontal start point for 1280 x 1280 image. Otherwise we use x=136
                w = 710;  // Area 710 x 710 has the image portion we want  
                h = 710;
              }
              BufferedImage subImage =  originalImgage.getSubimage(x, y, w, h);
              Image img = subImage.getScaledInstance(224, 224, Image.SCALE_SMOOTH);
              BufferedImage bImage = new BufferedImage (img.getWidth(null), img.getHeight(null), BufferedImage.TYPE_INT_RGB);
              Graphics2D bGr = bImage.createGraphics();
              bGr.drawImage(img,0,0,null);
              bGr.dispose();
              String outputDirName = croppedDirectoryName + "/" + subDir.getName();
              //Path path = Paths.get(outputDirName);
              //boolean isDir = Files.isDirectory(path);
              File theDir = new File(outputDirName);
              if (!theDir.exists()) {
                theDir.mkdirs();
              }
              //System.out.println("Cropped Image Dimension: "+bImage.getWidth()+"x"+bImage.getHeight());
              String name = outputDirName + "/" + f.getName();
              int i = name.lastIndexOf('.');
              name = name.substring(0,i);
              File outputfile = new File(name + ".bmp" );

              System.out.println("ouptput " + outputfile.getAbsolutePath());
              ImageIO.write(bImage, "bmp", outputfile);

             //System.out.println("Image cropped successfully: "+outputfile.getPath());
            }
          }
        }
      }
    } catch (IOException e) {
      e.printStackTrace();
    } finally {}
  }
}
