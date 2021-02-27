
class checkbox extends mouseRegion{
  boolean checked;
  checkboxCallback callback;
  checkbox(checkboxGraphics g,checkboxCallback b){
    super(g,new mouseRegionCallbackList(b,g));
    callback = b;
    checked = false;
  }
  checkbox(checkboxGraphics g,checkboxCallback b,boolean c){
    super(g,new mouseRegionCallbackList(b,g));
    checked = c;
  }
  void uncheck(){
    if(checked){
      checked = false;
      ((checkboxGraphics)super.graphics).setState(this);
      callback.uncheck(this);
    }
  }
  void check(){
    if(!checked){
      checked = true;
      ((checkboxGraphics)super.graphics).setState(this);
      callback.check(this);
    }
  }
  void toggle(){
      checked ^= true;
      ((checkboxGraphics)super.graphics).setState(this);
      if (checked){callback.check(this);}else{callback.uncheck(this);}
  }
  void update(boolean chkd){
    checked = chkd;
    ((checkboxGraphics)super.graphics).setState(this);
    if (checked){callback.check(this);}else{callback.uncheck(this);}
  }
}
interface checkboxGraphics extends regionGraphics,mouseRegionCallback{
  void setState(checkbox c);
}
class checkboxCallback extends voidMouseRegionCallback{
  booleanFunction check;
  booleanFunction uncheck;
  voidFunction forceCheck;
  voidFunction forceUncheck;
  checkboxCallback(booleanFunction c,booleanFunction uc,voidFunction fc,voidFunction func){check = c;uncheck = uc;forceCheck=fc;forceUncheck=func;}
   void onRelease(mouseRegion b){
     if (!b.mouseIsIn){return;}
   if (((checkbox)b).checked){
     if(uncheck.call()){
       (((checkbox)b).checked) = false;
     }
   }else{
     if(check.call()){
       (((checkbox)b).checked) = true;
     }
   }
   }
   void check(checkbox c){
     forceCheck.call();
   }
   void uncheck(checkbox c){
     forceUncheck.call();
   }
}

class squareCheckboxGraphics extends voidMouseRegionCallback implements checkboxGraphics {
  transform orientation;
  Quad base;
  style[] stateStyles;
  int state;
  regionGraphics label;
  squareCheckboxGraphics(){
    stateStyles = new style[]{
      new style(color(96),255,color(0),255,1),
      new style(color(128),255,color(255),255,2),
      new style(color(48),255,color(196),255,1),
      new style(color(64),255,color(0),255,1),
      new style(color(64),255,color(169),255,2),
      new style(color(32),255,color(128),255,1),
    };
    state = 0;
    base = new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),stateStyles[state]);
    label = new rectCanvas(new Point(0,0,0),new Point(1,1,1));
    ((rectCanvas)label).contents.add(base);
    orientation = new transform();
  }
  transform getOrientation(){return orientation;}
  void setOrientation(transform o){     orientation = o;  }
  void addOrientation(transform o){     orientation.timesEq(o);  }
  
  boolean isIn(Point p){
    return label.isIn(orientation.inverse().apply(p));
  }
  void updateBase(){
    base.s=stateStyles[state];
  }
  
  void onEnter(mouseRegion b){state = (mousePressed?1:0) + (((checkbox) b).checked?4:1);}
  void onExit(mouseRegion b){state = ((checkbox) b).checked?3:0;}
  void onPress(mouseRegion b){if (!b.mouseIsIn){return;}state = ((checkbox) b).checked?5:2;  }
  void onRelease(mouseRegion b){if (!b.mouseIsIn){return;}state = ((checkbox) b).checked?4:1;  }
  
  void draw(transform t){
    updateBase();
    //println(orientation.times(t));
    label.draw(orientation.semit(t));
  }
  void draw(transform t,PGraphics g){
    updateBase();
    label.draw(orientation.semit(t),g);
  }
  void setState(checkbox c){
    state = (state%3) + (c.checked?3:0); 
  }
}


class simpleCheckboxGraphics extends voidMouseRegionCallback implements checkboxGraphics {
  regionGraphics[] graphics;
  int state;
  transform orientation;
  simpleCheckboxGraphics(regionGraphics normal,
  regionGraphics hover,
  regionGraphics clickCheck,
  regionGraphics checked,
  regionGraphics hoverChecked,
  regionGraphics clickUncheck
  ){
    graphics = new regionGraphics[]{normal,hover,clickCheck,checked,hoverChecked,clickUncheck};
    state = 0;
    orientation = new transform();
  }
  transform getOrientation(){
     return orientation;
  }void setOrientation(transform o){
     orientation = o;
  }void addOrientation(transform o){
     orientation.timesEq(o);
  }
  boolean isIn(Point p){
    return graphics[state].isIn(orientation.inverse().apply(p));
  }
  void onEnter(mouseRegion b){state = (mousePressed?1:0) + (((checkbox) b).checked?4:1);}
  void onExit(mouseRegion b){state = ((checkbox) b).checked?3:0;}
  void onPress(mouseRegion b){if (!b.mouseIsIn){return;}state = ((checkbox) b).checked?5:2;  }
  //void onRelease(mouseRegion b){state = ((checkbox) b).checked?4:1;  }
  void onRelease(mouseRegion b){if (!b.mouseIsIn){return;}state = ((checkbox) b).checked?4:1;  }
  void draw(transform t){
    graphics[state].draw(orientation.semit(t));
  }
  void draw(transform t,PGraphics g){
    graphics[state].draw(orientation.semit(t),g);
  }
  void setState(checkbox c){
    state = (state%3) + (c.checked?3:0); 
  }
}
