final String VERSION = "0-alpha";
state root;

void mousePressed(Event e){ mousePressedListeners.handle(e);}
void mouseReleased(Event e){ mouseReleasedListeners.handle(e);}
void mouseClicked(Event e){ mouseClickedListeners.handle(e);print ("a");}
void mouseDragged(Event e){ mouseDraggedListeners.handle(e);}
void mouseMoved(Event e){ mouseMovedListeners.handle(e);}
void mouseWheel(Event e){ mouseWheelListeners.handle(e);}
  
void keyPressed(Event e){ keyPressedListeners.handle(e);}
void keyReleased(Event e){ keyReleasedListeners.handle(e);}
void keyTyped(Event e){ keyTypedListeners.handle(e);}


//https://pomax.github.io/bezierinfo/#arclength

vector[] b; 
Bezier B;

ArrayList<drawable> canvas;

ArrayList<selectable> selected;

void setup(){
  setupSaveAndLoad();
  uiSetup();
  size(1024,1024);
  canvas = new ArrayList<drawable>();
  selected = new ArrayList<selectable>();
  canvas.add(new brushedCurve(new simpleBrush(),
  //new Bezier(new Bezier(new Bezier(randBez(3),randBez(3)),new Bezier(randBez(3),randBez(3))),
  //new Bezier(new Bezier(randBez(3),randBez(3)),
  //new Bezier(new Bezier(randBez(3),randBez(3),randBez(3)),new Bezier(randBez(3),randBez(3),randBez(3)),new Bezier(randBez(3),randBez(3),randBez(3)))));
  new Bezier(new weightedSelectableVector(new Point(300,300),1),
  new weightedSelectableVector(new Point(350,386.6),.5),
  new weightedSelectableVector(new Point(400,300),1))));
  
  canvas.add(new brushedCurve(new simpleBrush(),
  new Bezier(new weightedSelectableVector(new Point(300,300),1),
  new weightedSelectableVector(new Point(350,386.6),-.5),
  new weightedSelectableVector(new Point(400,300),1))));
  /*canvas.add(new brushedCurve(new simpleBrush(),
  new Bezier(new weightedSelectableVector(new Point(400,300),1),
  new weightedSelectableVector(new Point(450,300-86.6),.5),
  new weightedSelectableVector(new Point(350,300-86.6),1))));
  
  canvas.add(new brushedCurve(new simpleBrush(),
  new Bezier(new weightedSelectableVector(new Point(350,300-86.6),1),
  new weightedSelectableVector(new Point(250,300-86.6),.5),
  new weightedSelectableVector(new Point(300,300),1))));
  stroke(color(0,0,0),1);*/
  println( load(((saveable)((brushedCurve)canvas.get(0)).c).save(new connectionMap<String,Object>())));
  //selectInput("Select a file to process:", "fileLoad");
  new selectTool().attach();
}



void fileLoad(File selection){
      if (selection == null) {
      //do nothing!
        println("load canceled");
      } else {
        String[] content = loadStrings(selection.getPath());
        String cs = "";
        for (String s:content){
          cs+=s+"\n"; //preserve for multi-line strings
        }
        println(load(cs));
        
      }
}
void fileSave(File selection){
      if (selection == null) {
        //do nothing;
        println("save canceled");
      } else {
        println("saving to " + selection.getPath());
        saveStrings(selection.getPath(), new String[] {root.save(new connectionMap<String,Object>())});
      }
}







Bezier randBez(int n){
  Bezier r = new Bezier();
  for(int i = 0; i < n; i++){
    r.add(new weightedSelectableVector(new Point(random(width),random(height)),2));
    
  }
  return r;
}

PGraphics renderCache;
boolean renderCacheGood = false;

PGraphics selectCache;
boolean selectCacheGood = false;
/*
void keyPressed(KeyEvent e){keyPressedHook(e);}
void mousePressed(MouseEvent e){mousePressedHook(e);}
void keyReleased(KeyEvent e){keyReleasedHook(e);}
void mouseReleased(MouseEvent e){mouseReleasedHook(e);}
void mouseMoved(MouseEvent e){mouseMovedHook(e);}
void mouseClicked(MouseEvent e){mouseClickedHook(e);}
void mouseDragged(MouseEvent e){mouseDraggedHook(e);}
void mouseWheel(MouseEvent e){mouseWheelHook(e);}
*/

void mouseWheel(MouseEvent e){
  
  for (selectable s : selected){
     if (s instanceof weightedSelectableVector){
       ((weightedSelectableVector<Point>)s).setWeight(((weightedSelectableVector<Point>)s).w + e.getCount()/11.); 
       renderCacheGood = false;
       selectCacheGood=false;
     }
    }
}

void mouseDragged(){
  if (mousePressed){
    for (selectable s : selected){
     if (s instanceof Point){
       ((Point)s).x = mouseX;
       ((Point)s).y = mouseY;
       renderCacheGood = false;
       selectCacheGood=false;
     }
     if (s instanceof weightedSelectableVector){
       ((weightedSelectableVector<Point>)s).v.x = mouseX*((weightedSelectableVector<Point>)s).w;
       ((weightedSelectableVector<Point>)s).v.y = mouseY*((weightedSelectableVector<Point>)s).w;
       renderCacheGood = false;
       selectCacheGood=false;
     }
    }
  }
}



void draw(){//drawHook();
  
  
  boolean doredraw = !(renderCacheGood&&selectCacheGood);

  if (!renderCacheGood){
  renderCache = createGraphics(width,height);
  renderCache.beginDraw();
  for(drawable d: canvas){
    d.draw(new coordTransform(),renderCache);
  }
  renderCacheGood = true;
  renderCache.endDraw();
  }
  
  if (!selectCacheGood){
  selectCache = createGraphics(width,height);
  selectCache.beginDraw();
  for(selectable s : selected){
    s.drawSelect(new coordTransform(),selectCache);
  }
  selectCacheGood = true;
  selectCache.endDraw();
  }
  
  
  if (doredraw){
  background(255);
  image(renderCache,0,0);
  image(selectCache,0,0);
  }
  
}






void keyPressed(){
  println(keyCode);
  if (key=='a'){
    selectCacheGood=false;
    selected.clear();
    for( drawable d: canvas){
    if (d instanceof selectable){
      //doSelectAll((selectable) d,4000000000.);
    }
    
    }
    
    
  }
  
  
}

/*
void mouseReleased(){
  selected.clear();
  selectCacheGood=false;
  if(keyPressed && key == 'p'){
    for( drawable d: canvas){
    if (d instanceof selectable){
      //if (doSelect((selectable) d,400)){

      //}
    }
  }
  }else{
  for( drawable d: canvas){
    if (d instanceof selectable){
      //if (doSelect((selectable) d,400)){
        break;
      //}
    }
  }
  }
  
  
  
  
  
  
}

*/
/*
void setup(){
  
  setupSaveAndLoad();
  //println(load("\"Version\"=\"0\""
  //));
   //println(load("\"Version\"=\""+VERSION+"\"\n"+(new Point(1,1).save(new connectionMap<String,Object>()))));
  
  size(256,256);
  
  background(0);
 
  
  b = new vector[]{
    new weightedVector(new Bezier(new weightedVector(new Point(10,200),1),
  //new weightedVector(new Point(100,200),.5),
  // new weightedVector(new Point(110,100),-.2),
   new weightedVector(new Point(200,200),1)),1),
 new weightedVector(new Bezier(new weightedVector(new Point(10,95),1),
  new weightedVector(new Point(95,95),15),
   new weightedVector(new Point(200,95),1)),1),
 new weightedVector(new Bezier(new weightedVector(new Point(10,10),1),
  //new weightedVector(new Point(100,10),.5),
   new weightedVector(new Point(200,10),1)),1)};
  / *for(int i = 0; i < b.length; i++){
    weightedVector[] p = new weightedVector[3];//[1+(int)random(5)];
    for(int j = 0; j < p.length; j++){
      p[j] = new weightedVector(new Point(random(width),random(height)),random(1));
    }
    b[i] = new Bezier(p);
  }* /
   
  //lineBezier((Bezier)((weightedVector)b[1]).v,0.01);
  //println(((Bezier)((weightedVector)b[1]).v).controlPoints);
  //println(((Bezier)((weightedVector)b[1]).v).get(0.4));
  B = new Bezier(b);
  //println(load(new weightedVector(new v1d(2),1).save(new connectionMap<String,Object>())));
  //println(load("\"out\"="+B.save(new connectionMap<String,Object>())).get("out"));
  //B.controlPoints.get(1).times(B);
  //vector v = B.get(2);
  //lineBezier(((Bezier)((weightedVector)v).v),0.01);
  //v.zero();
}

void lineBezier(Bezier b,double d){
  Point prev = (Point) ((weightedVector) b.get(0)).get();
  double f = 8; 
  for(double t = d ; t <= 1 ; t += d ){
    Point now = (Point) ((weightedVector) b.get(t)).get();
    stroke(color((int)((255*time*f))%256,255,(int)((255*t*f))%256));
    point(prev.displayX(),prev.displayY());
         //now.displayX() ,now.displayY() );
    
    prev = now;
  }
}



double time = 0;
void draw(){
  //background(192,192,192,20);
  //stroke(color((int)(255*time)));
  for (int i = 0; i < 100; i++){
    lineBezier((Bezier)((weightedVector)B.get(time)).get(),0.000625);
    //text((float)time,10,10);
    time = (time + 0.000625)%1;
  }
}*/
