abstract class tool extends uiElement{
  
}

class nullTool extends tool{
  transform orientation;
  transform getOrientation(){return orientation;}
  void setOrientation(transform o){ orientation=o;}
  void addOrientation(transform o){ orientation.timesEq(o);}
  
  void draw(transform t){
    
  }
  void draw(transform t,PGraphics g){
    
  }
}

class selectTool extends tool{
  transform orientation;
  transform getOrientation(){return orientation;}
  void setOrientation(transform o){ orientation=o;}
  void addOrientation(transform o){ orientation.timesEq(o);}
  
  void draw(transform t){
    
  }
  void draw(transform t,PGraphics g){
    
  }
  
}
