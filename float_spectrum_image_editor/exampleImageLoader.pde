import com.jmatio.io.*;
import com.jmatio.types.*;

public class matlabLoader {

   Image getImage(){// throws  IOException, FileNotFoundException {
     double[] wls = new double[31];
     for(int i = 0; i < 31; i++){
       wls[i] = 410+10*i;//410+10*i;
     }
     
     
     
    try{
       String basePath = new File("").getAbsolutePath();


      MatFileReader matfilereader = new MatFileReader(basePath.concat("/Documents/Processing/float_spectrum_image_editor/data/scene5.mat"));
      HashMap<String,MLArray> stuff = (HashMap<String,MLArray>)matfilereader.getContent();
      System.out.println(stuff);
      MLDouble dat  = (MLDouble) stuff.get("reflectances");
       
       
       
      Image res = new Image(dat.getDimensions()[1],dat.getDimensions()[0]);
      double[][] ddat = dat.getArray();
      
      println(ddat.length);
      println(ddat[0].length);
      println(ddat[0][0]);
      println(ddat[0].length/res.pixels[0].length);
      for(int x = 0; x < res.pixels.length; x++){
        for(int y = 0; y < res.pixels[0].length; y++){
          double[] vals = new double[ddat[0].length/res.pixels[0].length];
          for( int i = 0; i < vals.length; i ++){
            vals[i] = ddat[x][y+res.pixels[0].length*i];
          }
          res.pixels[x][y].values = vals;
          res.pixels[x][y].wavelengths = wls;
        }
      }
      return res;
    }catch(Exception e){
      print(e);
      return new Image(1,1);
    }
  }
}
