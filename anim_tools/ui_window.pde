class windowCallback extends voidMouseRegionCallback{
  
}


class window extends mouseRegion{
  regionGraphics graphic;
  uiElement element;
  boolean moveable;
  
  window(regionGraphics g, uiElement e)
  {
    
    super(g,new windowCallback());
    moveable = true;
    graphic = g;
    element = e;
  }
  
  
  
  
  
  
  
  
  
  
  
}
