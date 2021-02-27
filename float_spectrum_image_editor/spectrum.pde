class spectrum{
  double[] values;
  double[] wavelengths;
  double blackbody(double t,double wl){
    double h = 4.13566766225e-15;//eV*s
    double c = 299792458;//m/s
    wl /= 1e9;//m
    double k = 8.617330350e-5;//eV/K
    return 2*h*c*c    //
    /(wl*wl*wl*wl*wl) //eV s m^2 s^-2 m^-5 = eV m^-3 s^-1
    /(Math.exp(h*c/wl/k/t // unitless 
    )-1);
  }
  spectrum(double t, double[] wls){
    values = new double[wls.length];
    wavelengths = wls;
    for (int i = 0; i < wls.length ; i++){
      values[i] = blackbody(t,wls[i]);
    }
  }
  spectrum(){
    values = new double[0];
    wavelengths = new double[0];
  }
  spectrum(double... v){ //for 3 vals, wavelength = 460,550,640
    values = v;
    wavelengths = new double[v.length];
    for(int i = 0; i < values.length; i++){
      wavelengths[i] = 415 + (415 - 685)*(i+.5)/(values.length+1);
    }
  }
  spectrum(double[] f,double[] v){ //for 3 vals, wavelength = 460,550,640
    values = v;
    wavelengths = f;
  }
  spectrum scale(double g){
    double[] v = new double[values.length];
    for(int i = 0; i < v.length; i++){
      v[i] = values[i]*g;
    }
    return new spectrum(wavelengths,v);
  }
  spectrum scale(double[] g){
    double[] v = new double[values.length];
    for(int i = 0; i < v.length; i++){
      v[i] = values[i]*g[i];
    }
    return new spectrum(wavelengths,v);
  }
  spectrum add(spectrum other){
    double[] lres = new double[values.length+other.values.length];
    double[] vres = new double[lres.length];
    for (int i = 0; i < values.length; i ++){
      lres[i] = wavelengths[i];
      vres[i] = values[i];
    }
    int n = values.length;
    for (int i = 0; i < other.values.length; i ++){
      boolean set = false;
      for (int j = 0; j < n; j ++){
        if(lres[j] == other.wavelengths[i]){
           vres[j] += other.values[i];
           set = true;
           j = n;
        }
      }
      if (!set){
        lres[n] = other.wavelengths[i];
        vres[n] = other.values[i];
        n ++;
      }
    }
    double[] l = new double[n];
    double[] v = new double[n];
    for (int j = 0; j < n; j ++){
      l[j] = lres[j];
      v[j] = vres[j];
    }
    return new spectrum(l,v);
    
  }
}
abstract class frenderer{
  abstract double[] Color(spectrum s);
  color toColor(double[] v,double gain){
    return color(boundToByte(v[0]*gain),boundToByte(v[1]*gain),boundToByte(v[2]*gain));
  }
}
double deNaN(double v){ if (Double.isNaN(v)){ return 0;}else{return v;}}
double square(double v){ return v*v;}
int boundToByte(double v){if(v<0){return 0;} if(v>255){return 255;} return int((float)v);}
class roughCIE extends frenderer{
  HashMap<Double,Double[]> cache = new HashMap<Double,Double[]>();
  double[] Color(spectrum s){
    double x=0;double y=0; double z=0;
    for( int i = 0; i < s.values.length; i++){
      double f = s.wavelengths[i];
      double v = s.values[i];
      if (!cache.containsKey(f)){
        Double[] cch = new Double[] {(Double)(double)(0.398*deNaN(exp((float)(-1250*square(log((float)(f+570.1)/1014)))))+
          1.132*deNaN(exp((float)(-234*square(log((float)(1338-f)/743.5)))))),
          (Double)(double)1.011*exp((float)(-.5*square((f-556.1)/46.14))),
          (Double)(double)2.060*deNaN(exp((float)(-32*square(log((float)(f-265.8)/180.4)))))};
        cache.put(f, cch);
      }
      Double[] c = cache.get(f);
      x += c[0]*v;
      y += c[1]*v;
      z += c[2]*v;
    }
    double r =  3.2406255 * x + -1.537208  * y + -0.4986286 * z;
    double g = -0.9689307 * x +  1.8757561 * y +  0.0415175 * z;
    double b =  0.0557101 * x + -0.2040211 * y +  1.0569959 * z;

    return new double[] {postProcess(r)*255,postProcess(g)*255,postProcess(b)*255};
  }
  double postProcess(double c){
    return  (c <= 0.0031308 ? c * 12.92 : 1.055 * Math.pow(c, 1. / 2.4) - 0.055);
  }
}
//class fatigueTemplate extends renderer{


class greyProj extends frenderer{
  double[] Color(spectrum s){
    float x=0;float y=0; float z=0;
    for( int i = 0; i < s.values.length; i++){
      double f = s.wavelengths[i];
      double v = s.values[i];
      x+= (0.398*exp((float)(-1250*square(log((float)(f+570.1)/1014))))+
          1.132*exp((float)(-234*square(log((float)(1338-f)/743.5)))))*v;
      y += 1.011*exp((float)(-.5*square((f-556.1)/46.14)))*v;
      z += 2.060*exp((float)(-32*square(log((float)(f-265.8)/180.4))))*v;
    }
    double r =  3.2406255 * x + -1.537208  * y + -0.4986286 * z;
    double g = -0.9689307 * x +  1.8757561 * y +  0.0415175 * z;
    double b =  0.0557101 * x + -0.2040211 * y +  1.0569959 * z;

    return new double[] {r,g,b};
  }
  color toColor(double[] v,double gain){
    v = new double[] {postProcess(v[0]*gain+.25)*255,postProcess(v[1]*gain+.25)*255,postProcess(v[2]*gain+.25)*255};
    return color(boundToByte(v[0]),boundToByte(v[1]),boundToByte(v[2]));
  }
  double postProcess(double c){
    if(c < 0 || c > 1){
      return 0;
    }
    
    return  (c <= 0.0031308 ? c * 12.92 : 1.055 * Math.pow(c, 1. / 2.4) - 0.055);
  }
}


class filt extends frenderer{
  double low,high;
  
  filt(double l, double h){
    low = l;
    high = h;
  }
  double[] Color(spectrum s){
    double t=0;
    for( int i = 0; i < s.values.length; i++){
      double f = s.wavelengths[i];
      double v = s.values[i];
      if(f > low && f < high){
       t += v;
      }
    }
    

    return new double[] {t*255,t*255,t*255};
  }
}

class cfilt extends frenderer{
  double low,high;
  frenderer c;
  cfilt(double l, double h,frenderer C){
    low = l;
    high = h;
    c = C;
  }
  double[] Color(spectrum s){
    double t=0;
    double[] vals = new double[s.values.length];
    for( int i = 0; i < s.values.length; i++){
      double f = s.wavelengths[i];
      double v = s.values[i];
      if(f > low && f < high){
       vals[i] = v;
      }else{
        vals[i] = 0;
      }
    }
    

    return c.Color(new spectrum(s.wavelengths,vals));
  }
}
