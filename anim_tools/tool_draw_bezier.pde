class bezierTool extends tool{
  transform orientation;
  double pointsPerEvent;
  double error;
  transform getOrientation(){return orientation;}
  void setOrientation(transform o){ orientation=o;}
  void addOrientation(transform o){ orientation.timesEq(o);}
  canvas[] destinations;
  BrushedBezierPath[] results;
  
  bezierTool(double ppe,canvas... d){ destinations = d;
  orientation = new transform();
  pointsPerEvent = ppe;
  error = 0;
  }
  
  void draw(transform t){
    
  }
  void draw(transform t,PGraphics g){
    
  }
  
  
  boolean mouseReleasedHook(MouseEvent e,context c) {
  
  return true;}
  boolean mousePressedHook(MouseEvent e,context c) {
    error = 0;
    results = new BrushedBezierPath[destinations.length];
    for(int i = 0; i< destinations.length; i++){
      Point r = destinations[i].getOrientation().inverse().apply(new Point(mouseX,mouseY));
      results[i] = new BrushedBezierPath(brushes.get(0),1000,new Bezier(new vnd(r.x,r.y,r.z,r.w)));
      destinations[i].contents.add(results[i]);
      destinations[i].changed=true;
    }
    
  return true;}
  boolean mouseDraggedHook(MouseEvent e,context c) {
    error += pointsPerEvent;
    if (error>1){
      error--;
    for(int i = 0; i< results.length; i++){
      Point r = destinations[i].getOrientation().inverse().apply(new Point(mouseX,mouseY));
      results[i].path.get(0).points.add( new vnd(r.x,r.y,r.z,r.w));
      destinations[i].changed=true;
    }
    
    
    }
    
    
  return true;}
  
  
  
}
