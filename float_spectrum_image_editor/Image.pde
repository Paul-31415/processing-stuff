import java.io.Serializable;
double[] wls = {410,420,430,440,450,460,470,480,490,500,510,520,530,540,550,560,570,580,590,600,610,620,630,640,650,660,670,680,690,700,710};
class Image implements Serializable{
  
  spectrum[][] pixels;
  double[][]cache;
  boolean cached;
  
  Image(int w, int h){
    pixels = new spectrum[h][w];
    cache = new double[h*w][3];
    for(int y = 0; y < h; y++){ 
      for(int x = 0; x < w; x++){
        pixels[y][x] = new spectrum((x/32%2==1?6554:5778),wls);//5778//(x/32+w/32*(y/32))*32
      }
    }
    cached = false;
  }
  Image(int w, int h,double[] wv){
    pixels = new spectrum[h][w];
    cache = new double[h*w][3];
    for(int y = 0; y < h; y++){ 
      for(int x = 0; x < w; x++){
        pixels[y][x] = new spectrum(wv,new double[wv.length]);
      }
    }
    cached = false;
  }
  Image(Image I, kernal k){
    int h = I.pixels[0].length;
    int w = I.pixels.length;
    pixels = new spectrum[h][w];
    cache = new double[h*w][3];
    for(int y = 0; y < h; y++){ 
      for(int x = 0; x < w; x++){
        pixels[y][x] = k.get(I,x,y);
      }
    }
    cached = false;
  }
  Image(Image I, generator g){
    int h = I.pixels[0].length;
    int w = I.pixels.length;
    pixels = new spectrum[h][w];
    cache = new double[h*w][3];
    for(int y = 0; y < h; y++){ 
      for(int x = 0; x < w; x++){
        pixels[y][x] = g.get(I,x,y);
      }
    }
    cached = false;
  }
    

  
  
  boolean inBounds(int x, int y){
    return ( x >= 0 && x < pixels[0].length && y >= 0 && y < pixels.length);
  }
  boolean trySet(int x,int y, spectrum s){
    if( inBounds(x,y)){
      pixels[y][x] = s;
      cached = false;
      return true;
    }
    return false;
  }
  spectrum tryGet(int x,int y,spectrum def){
    if( inBounds(x,y)){
      return pixels[y][x];
    }
    return def;
  }
  boolean trySetCache(int x,int y, spectrum s,frenderer r){
    boolean res = trySet(x,y,s);
    if(res){
      cache[x+y*pixels[0].length] = r.Color(s);
    }
    return res;
  }
}

class kernal{
  double[][][] weights;
  int ox;
  int oy;
  kernal(double[][][] w, int ofx, int ofy){
    weights = w;
    ox = ofx;
    oy = ofy;
  }
  spectrum get(Image I, int x, int y){
    spectrum res = new spectrum();
    spectrum def = res;
    for(int ix = 0; ix< weights.length; ix++){
      for(int iy = 0; iy< weights[0].length; iy++){
        res = res.add(I.tryGet(x+ix+ox,y+iy+oy,def)
        .scale(
        weights[ix][iy])
        );
      }
    }
    return res;
  }
  
}
abstract class renderer{
  abstract PImage render(Image I,double gain);
  abstract PImage render(Image I,double gain,int X,int Y, int w, int h);
}

class frenderRenderer extends renderer{
  frenderer r;
  frenderRenderer(frenderer f){
    r = f;
  }
  PImage render(Image I,double gain,int X,int Y, int w, int h){
    PImage res = new PImage(w,h);
    res.loadPixels();
    spectrum def = new spectrum(); 
    int i = 0;
    for(int y = Y; y < h+Y; y++){ 
      for(int x = X; x < w+X; x++){
        spectrum s = I.tryGet(x,y,def);
        if(!I.cached){
          if (I.inBounds(x,y)){
            I.cache[i] = r.Color(s);
          }
        }
        res.pixels[i] = r.toColor(I.cache[i],gain);
        i ++;
      }
    }
    return res;
  }
  PImage render(Image I,double gain){
    PImage res = new PImage(I.pixels[0].length,I.pixels.length);
    res.loadPixels();
    int i = 0;
    for(spectrum[] row : I.pixels){
      for(spectrum s : row){
        if(!I.cached){
          I.cache[i] = r.Color(s);
        }
        res.pixels[i] = r.toColor(I.cache[i],gain);
        i ++;
      }
    }
    I.cached = true;
    return res;
  }
  
  
}

class blurRenderer extends renderer{
  frenderer r;
  double[] ranges;
  int[] blurs;
  blurRenderer(frenderer f,double[] R, int[] b){
    r = f;
    ranges = R;
    blurs = b;
  }  
  spectrum get(Image I, int X, int Y){
    //gaussian: e^(-(r^2)/(b^2))
    //block filter: 1/b^2
    
    int b = 0;
    for( int i : blurs){
      if(i > b){b=i;}
    }
    spectrum res = new spectrum();
    spectrum def = res;
    for(int x = X-(b/2); x < X-(b/2)+b; x++){
      for(int y = Y-(b/2); y < Y-(b/2)+b; y++){
        spectrum v = I.tryGet(x,y,def);
        double[] scales = new double[v.values.length];
        for(int i = 0; i < scales.length; i++){
          scales[i] = 0;
          for(int j = 0; j < ranges.length;j++){
            if (ranges[j] > v.wavelengths[i]){
              scales[i] = 1/(blurs[j]*blurs[j]);
              j = ranges.length;
            }
          }
        }
        res = res.add(I.tryGet(x,y,def).scale(scales));
      } 
    }
    return res;
  }
  PImage render(Image I,double gain,int X,int Y, int w, int h){
    PImage res = new PImage(w,h);
    res.loadPixels();
    int i = 0;
    for(int y = Y; y < h+Y; y++){ 
      for(int x = X; x < w+X; x++){
        spectrum s = get(I,x,y);
        if(!I.cached){
          if (I.inBounds(x,y)){
            I.cache[i] = r.Color(s);
          }
        }
        res.pixels[i] = r.toColor(I.cache[i],gain);
        i ++;
      }
    }
    return res;
  }
  PImage render(Image I,double gain){
    PImage res = render( I, gain,0,0, I.pixels[0].length,I.pixels.length);
    I.cached = true;
    return res;
  }
  
  
}

abstract class generator{
  abstract spectrum get(Image i, int x, int y);
}
  

class blurGen extends generator{
  double[] ranges;
  int[] blurs;
  blurGen(double[] R, int[] b){
    ranges = R;
    blurs = b;
  }  
  
  spectrum get(Image I, int X, int Y){
    //gaussian: e^(-(r^2)/(b^2))
    //block filter: 1/b^2
    
    int b = 0;
    for( int i : blurs){
      if(i > b){b=i;}
    }
    spectrum res = new spectrum();
    spectrum def = res;
    for(int x = X-(b/2); x < X-(b/2)+b; x++){
      for(int y = Y-(b/2); y < Y-(b/2)+b; y++){
        spectrum v = I.tryGet(x,y,def);
        double[] scales = new double[v.values.length];
        for(int i = 0; i < scales.length; i++){
          scales[i] = 0;
          for(int j = 0; j < ranges.length;j++){
            if (ranges[j] > v.wavelengths[i]){
              if (x-X+(b/2) >= -(blurs[j]/2) && x-X+(b/2) < blurs[j]-(blurs[j]/2) && y-Y+(b/2) >= -(blurs[j]/2) && y-Y+(b/2) < blurs[j]-(blurs[j]/2)){
                scales[i] = 1./(blurs[j]*blurs[j]);
              }
              j = ranges.length;
            }
          }
        }
        res = res.add(I.tryGet(x,y,def).scale(scales));
      } 
    }
    return res;
  }
}

class pixelateGen extends generator{
  int[] divisors;
  pixelateGen( int[] b){
    divisors = b;
  }  
  
  spectrum get(Image I, int X, int Y){
    double[] rw = I.tryGet(0,0,new spectrum()).wavelengths;
    double[] rv = new double[rw.length];
    for(int i = 0; i < divisors.length; i ++){
      double[] vs = I.tryGet((X/divisors[i])*divisors[i]+divisors[i]/2,(Y/divisors[i])*divisors[i]+divisors[i]/2,new spectrum()).values;
      if (i < vs.length){
        rv[i] = vs[i];
      }
    }
    return new spectrum(rw,rv);
  }
}
