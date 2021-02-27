
boolean[] heldKeys;
boolean[] heldMouseButtons;
ArrayList<uiElement> activeUIElements;
void registerUIElement(uiElement e){
  activeUIElements.add(e);
}
void unregisterUIElement(uiElement e){
  activeUIElements.remove(e);
}

void UIsetup(){
  heldKeys = new boolean[256];
  for(int i = 0; i < heldKeys.length; i++){
    heldKeys[i] = false;
  }
  heldMouseButtons = new boolean[256];
  for(int i = 0; i < heldMouseButtons.length; i++){
    heldMouseButtons[i] = false;
  }
  activeUIElements = new ArrayList<uiElement>();
}

context globalContext = new context();

void keyPressedHook(KeyEvent ev){
  keyPressedUpdateHeldKeys();
  for(uiElement e : activeUIElements){
    if(!e.keyPressedHook(ev,globalContext)){
      break;
    }
  }
}
void keyReleasedHook(KeyEvent ev){
  keyReleasedUpdateHeldKeys();
  for(uiElement e : activeUIElements){
    if(!e.keyReleasedHook(ev,globalContext)){
      break;
    }
  }
}
void mousePressedHook(MouseEvent ev){
  mousePressedUpdateHeldMouseButtons();
  for(uiElement e : activeUIElements){
    if(!e.mousePressedHook(ev,globalContext)){
      break;
    }
  }
}
void mouseReleasedHook(MouseEvent ev){
  mouseReleasedUpdateHeldMouseButtons();
  for(uiElement e: activeUIElements){
    if(!e.mouseReleasedHook(ev,globalContext)){
      break;
    }
  }
}
void mouseClickedHook(MouseEvent ev){
  for(uiElement e: activeUIElements){
    if(!e.mouseClickedHook(ev,globalContext)){
      break;
    }
  }
}
void mouseMovedHook(MouseEvent ev){
  for(uiElement e: activeUIElements){
    if(!e.mouseMovedHook(ev,globalContext)){
      break;
    }
  }
}
void mouseDraggedHook(MouseEvent ev){
  for(uiElement e: activeUIElements){
    if(!e.mouseDraggedHook(ev,globalContext)){
      break;
    }
  }
}
void mouseWheelHook(MouseEvent ev){
  for(uiElement e: activeUIElements){
    if(!e.mouseWheelHook(ev,globalContext)){
      break;
    }
  }
}
void drawHook(){
  for(uiElement e: activeUIElements){
    if(!e.drawHook(globalContext)){
      break;
    }
  }
}


void keyPressedUpdateHeldKeys() {
  heldKeys[keyCode] = true;
}
void keyReleasedUpdateHeldKeys() {
  heldKeys[keyCode] = false;
}
void mousePressedUpdateHeldMouseButtons() {
  heldMouseButtons[mouseButton] = true;
}
void mouseReleasedUpdateHeldMouseButtons() {
  heldMouseButtons[mouseButton] = false;
}

class context extends transform{
  context(transform t){
    super(t.x,t.y,t.z,t.w);
  }
  context(){
    super();
  }
  context semit(context o){
    return new context(super.semit(o));
  }
}


abstract class uiElement implements drawable,orientable{
  boolean keyPressedHook(KeyEvent e,context c) {return true;}
  boolean keyReleasedHook(KeyEvent e,context c) {return true;}
  boolean mousePressedHook(MouseEvent e,context c) {return true;}
  boolean mouseReleasedHook(MouseEvent e,context c) {return true;}
  boolean mouseClickedHook(MouseEvent e,context c) {return true;}
  boolean mouseMovedHook(MouseEvent e,context c) {return true;}
  boolean mouseDraggedHook(MouseEvent e,context c) {return true;}
  boolean mouseWheelHook(MouseEvent e,context c) {return true;}
  boolean drawHook(context c) {return true;}
}
class uiElementList extends uiElement{
  transform orientation;
  uiElement[] contents;
  uiElementList(uiElement... c){
    contents = c;
    orientation = new transform();
    
  }
  
  transform getOrientation(){ return orientation;}
  void setOrientation(transform t){  orientation = t;}
  void addOrientation(transform t){  orientation.timesEq(t);}
  void draw(transform t,PGraphics g){
    transform eff = orientation.semit(t);
    for( uiElement elem : contents){
      elem.draw(eff,g);
    }
  }
  void draw(transform t){
    transform eff = orientation.semit(t);
    for( uiElement elem : contents){
      elem.draw(eff);
    }
  }
  
  
  boolean keyPressedHook(KeyEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.keyPressedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean keyReleasedHook(KeyEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.keyReleasedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean mousePressedHook(MouseEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.mousePressedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean mouseReleasedHook(MouseEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.mouseReleasedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean mouseClickedHook(MouseEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.mouseClickedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean mouseMovedHook(MouseEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.mouseMovedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean mouseDraggedHook(MouseEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.mouseDraggedHook(e,eff)){
        return false;
      }}    return true;  }
  boolean mouseWheelHook(MouseEvent e,context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.mouseWheelHook(e,eff)){
        return false;
      }}    return true;  }
  boolean drawHook(context c) {context eff = c.semit( new context(orientation));
    for(uiElement el : contents){
      if(!el.drawHook(eff)){
        return false;
      }}    return true;  }
}









/*class uiDraw extends uiElement{
  drawable thing;
  transform orientation;
  uiDraw(drawable t){
    thing = t;
    orientation = new transform();
  }
  
  transform getOrientation(){
     return orientation;
  }void setOrientation(transform o){
     orientation = o;
  }void addOrientation(transform o){
     orientation.timesEq(o);
  }
  boolean drawHook() {
    thing.draw(orientation);
  return true;}
  void draw(transform t){
    thing.draw(orientation.times(t));
  }
  void draw(transform t,PGraphics g){
    thing.draw(orientation.times(t),g);
  }
}*/




interface mouseRegionCallback{
  abstract void onPress(mouseRegion b);
  abstract void onRelease(mouseRegion b);
  abstract void onClick(mouseRegion b);
  abstract void onScroll(mouseRegion b);
  abstract void onHover(mouseRegion b);
  
  abstract void onMove(mouseRegion b);
  abstract void onDrag(mouseRegion b);
  
  abstract void onEnter(mouseRegion b);
  abstract void onExit(mouseRegion b);
}
class mouseRegionCallbackList implements mouseRegionCallback{
  mouseRegionCallback[] callbacks;
  mouseRegionCallbackList(mouseRegionCallback... cb){callbacks = cb;}
   void onPress(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onPress(b);}
   void onRelease(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onRelease(b);}
   void onClick(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onClick(b);}
   void onScroll(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onScroll(b);}
   void onHover(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onHover(b);}
  
   void onMove(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onMove(b);}
   void onDrag(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onDrag(b);}
  
   void onEnter(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onEnter(b);}
   void onExit(mouseRegion b){for(mouseRegionCallback c: callbacks) c.onExit(b);}
}

class voidMouseRegionCallback implements mouseRegionCallback{
  voidMouseRegionCallback(){}
   void onPress(mouseRegion b){}
   void onRelease(mouseRegion b){}
   void onClick(mouseRegion b){}
   void onScroll(mouseRegion b){}
   void onHover(mouseRegion b){}
  
   void onMove(mouseRegion b){}
   void onDrag(mouseRegion b){}
  
   void onEnter(mouseRegion b){}
   void onExit(mouseRegion b){}
}

class mouseRegion extends uiElement{
  transform orientation;
  boolean mouseIsIn;
  boolean grabInsideEvents;
  boolean grabOutsideEvents;
  regionGraphics graphics;
  mouseRegionCallback functions;
  mouseRegion(regionGraphics g,mouseRegionCallback f){
    graphics = g;
    mouseIsIn = false;
    functions = f;
    orientation = new transform();
    grabInsideEvents = true;
    grabOutsideEvents = false;
  }
  
  transform getOrientation(){
    return orientation;  }
  void setOrientation(transform t){
    orientation = t;  }
  void addOrientation(transform t){
    orientation.timesEq(t);  }
  
  void draw(transform t){
    graphics.draw(orientation.semit(t));
  }
  void draw(transform t,PGraphics g){
    graphics.draw(orientation.semit(t),g);
  }
  
  boolean mousePressedHook(MouseEvent e,context c) {
    functions.onPress(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
  boolean mouseReleasedHook(MouseEvent e,context c) {
    functions.onRelease(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
  boolean mouseClickedHook(MouseEvent e,context c) {
    functions.onClick(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
  boolean mouseWheelHook(MouseEvent e,context c) {
    functions.onScroll(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
  void handleIsIn(context c){
    //println((orientationInverse.apply(new Point(mouseX,mouseY))));
    //println(graphics.isIn(orientationInverse.apply(new Point(mouseX,mouseY))));
    if (graphics.isIn(orientation.inverse().apply(c.inverse().apply(new Point(mouseX,mouseY))))){
      if (!mouseIsIn){
        mouseIsIn = true;
        functions.onEnter(this);
      }
    }else{
      if (mouseIsIn){
        mouseIsIn = false;
        functions.onExit(this);
      }
    }
    //println(orientationInverse);
    //println(orientationInverse.apply(new Point(mouseX,mouseY)));
    //println(mouseIsIn);
  }
  
  boolean mouseMovedHook(MouseEvent e,context c) {
    handleIsIn(c);
    functions.onMove(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
  boolean mouseDraggedHook(MouseEvent e,context c) {
    
    handleIsIn(c);
    functions.onDrag(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
  
  boolean drawHook() {
    functions.onHover(this);
    return mouseIsIn?!grabInsideEvents:!grabOutsideEvents;
  }
}





interface regionGraphics extends drawable,orientable{
  abstract boolean isIn(Point p);
}
class bitmapCanvas extends canvas implements regionGraphics{
  transform camera;
  PGraphics buffer;
  bitmapCanvas(){
    super();
    camera = new transform();
    buffer = createGraphics(100,100);
  }
  bitmapCanvas(int w, int h){
    super();
    camera = new transform();
    buffer = createGraphics(w,h);
  }
  

  
  boolean isIn(Point p){
    PGraphics g = createGraphics(1,1);
    g.beginDraw();
    transform shift = new transform(new Point(1,0,0,0),
                                    new Point(0,1,0,0),
                                    new Point(0,0,1,0),
                                    p.negative());
    this.draw(shift,g);
    g.endDraw();
    PImage r = g;
    return alpha(g.get(0,0))>0;
    
  }
  
}


class rectCanvas extends canvas implements regionGraphics{
  Point lowCorner;
  Point highCorner;
 
  rectCanvas(Point low, Point hi){
    super();
    lowCorner = low;
    highCorner = hi;

  }
  
  transform getOrientation(){
    return orientation;
  }
  void setOrientation(transform t){
    super.orientation = t;
  }
  void addOrientation(transform t){
    super.orientation.timesEq(t);
  }
  
  boolean isIn(Point p){
    Point a= orientation.inverse().apply(p).normalizedEq();
    Point low = lowCorner.normalized();
    Point hi = highCorner.normalized();
    return a.x>=low.x && a.x<=hi.x && a.y>=low.y && a.y<=hi.y && a.z>=low.z && a.z<=hi.z;
  }
}

interface voidFunction{ abstract void call();}
interface booleanFunction{ abstract boolean call();}
