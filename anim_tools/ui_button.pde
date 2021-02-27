
class button extends mouseRegion{
  button(buttonGraphics g,ButtonCallback b){
    super(g,new mouseRegionCallbackList(g,b));
  }
}
interface buttonGraphics extends regionGraphics,mouseRegionCallback{}
class ButtonCallback extends voidMouseRegionCallback{
  voidFunction press;
  ButtonCallback(voidFunction p){press = p;}
   void onRelease(mouseRegion b){press.call();}
}
class simpleButtonGraphics extends voidMouseRegionCallback implements buttonGraphics {
  regionGraphics[] graphics;
  int state;
  transform orientation;
  simpleButtonGraphics(regionGraphics normal,
  regionGraphics hover,
  regionGraphics click){
    graphics = new regionGraphics[]{normal,hover,click};
    state = 0;
    orientation = new transform();
  }
  transform getOrientation(){
     return orientation;
  }void setOrientation(transform o){
     orientation=o;
  }void addOrientation(transform o){
     orientation.timesEq(o);
  }
  boolean isIn(Point p){

    return graphics[state].isIn(orientation.inverse().apply(p));
  }
  void onEnter(mouseRegion b){state = mousePressed?2:1;}
  void onExit(mouseRegion b){state = 0;}
  void onPress(mouseRegion b){  if (!b.mouseIsIn){return;}  state = 2;  }
  void onRelease(mouseRegion b){  if (!b.mouseIsIn){return;}  state = 1;  }
  void draw(transform t){
    
    graphics[state].draw(orientation.semit(t));
  }
  void draw(transform t,PGraphics g){
    
    graphics[state].draw(orientation.semit(t),g);
  }
}
