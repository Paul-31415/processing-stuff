class state implements saveable{
  String version;
  HashMap<String,Object> params;
  long uid = ++UNIQUE_ID;
  
  
  
  state(){
    version = VERSION;
    params = new HashMap<String,Object>();
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  state New(){
    return new state();
  }
  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      //ref
      return "@"+namespace.getKey(this);
    }else{
      //new
      String k = "state_"+ uid;
      String v = "\"version\":\""+version+
                 "\"";
      namespace.put(k,this);
      return "\""+k+"\"=\"state\"("+v+")";
      
    }
    
  }
  void setParameter(String param,Object o){
        switch (param){
          case "version":
            if (o instanceof dString){
              version = ((SaveableString)(((dString)o).obj)).contents;
              break;
            }else{
              println("error: tried to set version as a non immedate val: "+o); 
              assert(1==0);
            }
          default:
            println("warn: tried to set unknown param "+param+" of state"); 
            params.put(param,o);
        }
      
    
  }
  
  
  
}
