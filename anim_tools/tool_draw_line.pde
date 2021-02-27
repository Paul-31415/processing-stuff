class lineTool extends tool{
  transform orientation;
  transform getOrientation(){return orientation;}
  void setOrientation(transform o){ orientation=o;}
  void addOrientation(transform o){ orientation.timesEq(o);}
  canvas[] destinations;
  Line[] results;
  
  lineTool(canvas... d){ destinations = d;
  orientation = new transform();
  }
  
  void draw(transform t){
    
  }
  void draw(transform t,PGraphics g){
    
  }
  
  
  boolean mouseReleasedHook(MouseEvent e,context c) {
  
  return true;}
  boolean mousePressedHook(MouseEvent e,context c) {
    results = new Line[destinations.length];
    for(int i = 0; i< destinations.length; i++){
      Point r = destinations[i].getOrientation().inverse().apply(new Point(mouseX,mouseY));
      results[i] = new Line(r,r,new style( color(0),0,color(0),255,1));
      destinations[i].contents.add(results[i]);
    }
  return true;}
  boolean mouseDraggedHook(MouseEvent e,context c) {
    for(int i = 0; i< results.length; i++){
      Point r = destinations[i].getOrientation().inverse().apply(new Point(mouseX,mouseY));
      results[i].b = r;
    }
    
    
    
    
    
  return true;}
  
  
  
}
