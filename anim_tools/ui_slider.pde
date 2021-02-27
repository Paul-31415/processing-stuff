
class slider extends mouseRegion{
  double value;
  sliderCallback callback;
  slider(sliderGraphics g,sliderCallback b){
    super(g,new mouseRegionCallbackList(g,b));
    callback = b;
    value = 1;
  }
  boolean mouseDraggedHook(MouseEvent e,context c) {
    
    super.handleIsIn(c);
    if (mouseIsIn){
      functions.onDrag(this);
      
      value = callback.changeValue(this,((sliderGraphics)super.graphics).getValue(orientation.inverse().apply(c.inverse().apply(new Point(mouseX,mouseY)))));
      
      return false;
    }else{
      return true;
    }
  }
  
}
interface sliderGraphics extends paramaterizedDrawable1DRegionGraphics,mouseRegionCallback{
  double getValue(Point p);
}
class sliderCallback extends voidMouseRegionCallback{
  voidFunction onRelease;
  voidFunction onChange;
  sliderCallback(voidFunction p,voidFunction b){onRelease = p;onChange = b;}
   void onRelease(mouseRegion b){if (!b.mouseIsIn){return;} onRelease.call();}
 double changeValue(slider s, double v){
   onChange.call();
   return v;
 }
}
interface paramaterizedDrawable1DRegionGraphics extends regionGraphics,paramaterizedDrawable1D{
}

class simpleSliderRectangle extends Quad implements paramaterizedDrawable1DRegionGraphics{
  double param;
  double maxWidth;
  double thickness;
  simpleSliderRectangle(double w,double h,style s){
    super(new Point(0,0),
    new Point(w,0),
    new Point(w,h),
    new Point(0,h),
    s);
    param = 1;
    maxWidth = w;
    thickness = 1;
  }
  double getParam(){return param;}
  void setParam(double v){
     param = v;
     super.b.x = maxWidth*param;
     super.c.x = super.b.x;
  }
  
  
  boolean isIn(Point p){

    
    Point a= orientation.inverse().apply(p).normalizedEq();
    Point low = super.orientation.apply(new Point()).normalizedEq();
    Point hi = super.orientation.apply(new Point(maxWidth,super.c.y,thickness)).normalizedEq();
    return a.x>=low.x && a.x<=hi.x && a.y>=low.y && a.y<=hi.y && a.z>=low.z && a.z<=hi.z;
  }
}

class simpleSliderGraphics extends voidMouseRegionCallback implements sliderGraphics {
  paramaterizedDrawable1DRegionGraphics[] graphics;
  int state;
  double param;
  transform orientation;
  simpleSliderGraphics(paramaterizedDrawable1DRegionGraphics normal,
  paramaterizedDrawable1DRegionGraphics hover,
  paramaterizedDrawable1DRegionGraphics click){
    graphics = new paramaterizedDrawable1DRegionGraphics[]{normal,hover,click};
    state = 0;
    param = 0;
    orientation = new transform();
  }
  double getParam(){return param;}
  void setParam(double v){
    param = v;
    graphics[0].setParam(v);
    graphics[1].setParam(v);
    graphics[2].setParam(v);
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
  double getValue(Point p){
    return orientation.inverse().apply(p).normalizedEq().x;
  }
  void onEnter(mouseRegion b){ setParam(((slider)b).value);state = mousePressed?2:1;}
  void onExit(mouseRegion b){setParam(((slider)b).value);state = 0;}
  void onPress(mouseRegion b){ if (!b.mouseIsIn){return;} setParam(((slider)b).value);  state = 2;  }
  void onRelease(mouseRegion b){ if (!b.mouseIsIn){return;} setParam(((slider)b).value);  state = 1;  }
  void onDrag(mouseRegion b){ if (!b.mouseIsIn){return;} setParam(((slider)b).value);  }
  void onScroll(mouseRegion b){ if (!b.mouseIsIn){return;} setParam(((slider)b).value);  }
  void draw(transform t){
    
    graphics[state].draw(orientation.semit(t));
  }
  void draw(transform t,PGraphics g){
    
    graphics[state].draw(orientation.semit(t),g);
  }
}
