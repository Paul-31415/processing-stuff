class Color implements vector{
  
  long uid = ++UNIQUE_ID;
  
  String toString(){
    return "Color("+r+","+ g+","+ b+","+ a+")";
  }
  Color New(){return new Color();}
  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      return "@"+namespace.getKey(this);
    }else{
      String k = "Color_"+ uid;
      String v = "\"r\":\""+r+
                 "\",\"g\":\""+g+
                 "\",\"b\":\""+b+
                 "\",\"a\":\""+a+"\"";
      namespace.put(k,this);
      return "\""+k+"\"=\"Color\"("+v+")";
    }
  }
  void setParameter(String param,Object o){
      if (o instanceof dString){
        double v = Double.parseDouble(((SaveableString)(((dString)o).obj)).contents);
        switch (param){
          case "r":
            r = v;
            break;
          case "g":
            g = v;
            break;
          case "b":
            b = v;
            break;
          case "a":
            a = v;
            break;
          default:
            println("error: tried to set param "+param+" of "+this.getClass().getName()); 
            assert(1==0);
        }
      }
    
  }
  
  
  double r,g,b,a;
  
  color get(){
    return color((int)Math.max(0,Math.min(255,255*r)),(int)Math.max(0,Math.min(255,255*g)),(int)Math.max(0,Math.min(255,255*b)));
  }
  float getAlpha(){
    return (float)a;
  }
  
  
  Color(){
    r = 0; g = 0; b = 0; a = 0;
  }
  Color(double l){
    r = l; g = l; b = l; a = 1;
  }
  Color(double l,double A){
    r = l; g = l; b = l; a = A;
  }
  Color(double R, double G, double B){
    r = R; g = G; b = B; a = 1;
  }
  Color(double R, double G, double B, double A){
    r = R; g = G; b = B; a = A;
  }
  vector copy(){
    return new Color(r,g,b,a);
  }
  
  vector plus(vector O){
    Color o = (Color)O;
    return new Color(r+o.r,g+o.g,b+o.b,a+o.a);
  }
  vector plusEq(vector O){
    Color o = (Color)O;
    r += o.r; g += o.g; b += o.b; a += o.a;
    return this;
  }
  
  vector times(vector O){
    Color o = (Color)O;
    return new Color(r*o.r,g*o.g,b*o.b,a*o.a);
  }
  vector timesEq(vector O){
    Color o = (Color)O;
    r *= o.r; g *= o.g; b *= o.b; a *= o.a;
    return this;
  }
  vector times(double o){
    return new Color(r*o,g*o,b*o,a*o);
  }
  vector timesEq(double o){
    r *= o; g *= o; b *= o; a *= o;
    return this;
  }
  
  vector zero(){
    return new Color(0,0,0,0);
  }
  
}




/*
class style implements vector{
  
  
  
  
  vector copy(){
  
  }
  
  vector plus(vector o){
    assert (o instanceof style);
    
  }
  vector plusEq(vector o){
    assert (o instanceof style);
    
  }
  
  vector times(vector o){
    assert (o instanceof style);
    
  }
  vector timesEq(vector o){
    assert (o instanceof style);
    
  }
  vector times(double o);
  vector timesEq(double o);
  
  vector zero(){
    
  }
  
}*/
