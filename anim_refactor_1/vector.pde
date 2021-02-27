interface vector extends saveable{
  abstract vector copy();
  
  abstract vector plus(vector o);
  abstract vector plusEq(vector o);
  
  abstract vector times(vector o);
  abstract vector timesEq(vector o);
  abstract vector times(double o);
  abstract vector timesEq(double o);
  
  abstract vector zero();
  
}

interface drawableVector extends vector{
  abstract float x();
  abstract float y();
}


class v1d implements vector{
  String toString(){
    return "v1d("+value+")";
  }
  
  
  long uid = ++UNIQUE_ID;
  v1d New(){
    return new v1d();
  }
  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      //ref
      return "@"+namespace.getKey(this);
    }else{
      //new
      String k = "v1d_"+ uid;
      String v = "\"value\":\""+value+"\"";
      namespace.put(k,this);
      return "\""+k+"\"=\"v1d\"("+v+")";
      
    }
    
  }
  public void setParameter(String param,Object o){

      if (o instanceof dString){
        double v = Double.parseDouble(((SaveableString)(((dString)o).obj)).contents);
        switch (param){
          case "value":
            value = v;
            break;
          default:
            println("error: tried to set param "+param+" of v1d"); 
            assert(1==0);
        }
      }
    
  }
  
  
  
  v1d(){}
  
  double value;
  v1d(double v){
    value = v;
  }
  vector copy(){
    return new v1d(value);
  }
  vector plus(vector o){
    return new v1d(((v1d)o).value+value);
  }
  vector plusEq(vector o){
    value += ((v1d)o).value; return this;
  }
  vector times(vector o){
    return new v1d(((v1d)o).value*value);
  }
  vector timesEq(vector o){
    value *= ((v1d)o).value; return this;
  }
  vector times(double o){
    return new v1d(value*o);
  }
  vector timesEq(double o){
    value *= o; return this;
  }
  vector zero(){
    return new v1d(0);
  }
}
