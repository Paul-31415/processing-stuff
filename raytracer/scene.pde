class scene extends traceable{
  ArrayList<traceable> contents;
  
  scene(){
    contents = new ArrayList<traceable>();
  }
  scene(ArrayList<traceable> c){
    contents = c;
  }
  scene add(traceable o){
    contents.add(o);
    return this;
  }
  intersection trace(ray r){
    intersection res = new intersection(0,false,0);
    for( traceable t: contents){
      res = t.trace(r,res);
    }
    return res;
  }
  
}
