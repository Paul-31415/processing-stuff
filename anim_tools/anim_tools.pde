
canvas world;

//Path p = new Path();
Bezier b = new Bezier();

rectCanvas bc;

mouseRegion testButton;
mouseRegion testCheckbox;
mouseRegion testSlider;
transform camera;
void setup(){
  frameRate(10);
  world = new canvas();
  world.contents.add(new bg(color(192)));
  UIsetup();
  uiSetup();
  size(768,768);
  camera = new transform(new Point(01,00,00,00),
                         new Point(00,01,00,00),
                         new Point(00,00,01,00),
                         new Point(00,00,00,01));
                         
  bc = new rectCanvas(new Point(0,0,0), new Point(1,1,1));
bc.contents.add( (drawable) new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),
new style(color(255,64,64),255)) );

rectCanvas bch = new rectCanvas(new Point(0,0,0), new Point(1,1,1));
 bch.contents.add( (drawable) new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),
new style(color(255,128,64),255)) );

rectCanvas bcp = new rectCanvas(new Point(0,0,0), new Point(1,1,1));
bcp.contents.add( (drawable) new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),
new style(color(128,16,16),255)) );

rectCanvas cc = new rectCanvas(new Point(0,0,0), new Point(1,1,1));
 cc.contents.add( (drawable) new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),
new style(color(255,64,64),255)) );
cc.contents.add( (drawable) new Quad(new Point(0.5,0.5),new Point(0.4,.6),new Point(.5,.4),new Point(.8,.8),
new style(color(255,255,255),255)) );

rectCanvas cch = new rectCanvas(new Point(0,0,0), new Point(1,1,1));
cch.contents.add( (drawable) new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),
new style(color(255,128,64),255)) );
cch.contents.add( (drawable) new Quad(new Point(0.5,0.5),new Point(0.4,.6),new Point(.5,.4),new Point(.8,.8),
new style(color(255,255,255),255)) );

rectCanvas ccp = new rectCanvas(new Point(0,0,0), new Point(1,1,1));
ccp.contents.add( (drawable) new Quad(new Point(0,0),new Point(0,1),new Point(1,1),new Point(1,0),
new style(color(128,16,16),255)) );
ccp.contents.add( (drawable) new Quad(new Point(0.5,0.5),new Point(0.4,.6),new Point(.5,.4),new Point(.8,.8),
new style(color(255,255,255),255)) );

  testButton = new button(new simpleButtonGraphics(bc,bch,bcp),new ButtonCallback(
  new voidFunction(){
   public void call(){
    println("Pressed!");
   }
  }));
  
   /*testCheckbox = new checkbox(new simpleCheckboxGraphics(bc,bch,bcp,cc,cch,ccp),new checkboxCallback(
  new booleanFunction(){
   public boolean call(){
    println("checked!");
    return true;
   }
  },
  new booleanFunction(){
   public boolean call(){
    println("unckecked!");
    return true;
   }
  }));
  testSlider = new slider(new simpleSliderGraphics(  new simpleSliderRectangle(1,1,new style(color(64,255,64),255)),
  new simpleSliderRectangle(1,1,new style(color(64,128,64),255)),
  new simpleSliderRectangle(1,1,new style(color(128,255,64),255))
  ),new sliderCallback(new voidFunction(){
   public void call(){
     println("slider changed!");
   }
  }));
  
  
  transform checkboxTransform =      new transform(new Point(91,40,00,00),
                                                   new Point(00,-91,0,00),
                                                   new Point(00,-30,91,00),
                                                   new Point(40,40+91,00,01));
                                                   
   transform buttonTransform =        new transform(new Point(91,00,00,00),
                                                   new Point(00,91,00,00),
                                                   new Point(00,00,91,00),
                                                   new Point(40,40+91*2,00,01));                                                 
  
  
  testSlider.setOrientation(new transform(new Point(91,00,00,00),
                                                   new Point(00,21,00,00),
                                                   new Point(00,00,91,00),
                                                   new Point(40,40+91*4,00,01)));
  testCheckbox.setOrientation(checkboxTransform);
  testButton.setOrientation(buttonTransform);
  */
  //println(buttonTransform);                                                 
  //println(buttonTransform.inverse());
  //registerUIElement(testButton);
  //registerUIElement(testCheckbox);
  //registerUIElement(testSlider);
  registerUIElement(toolBar);
  toolBar.setOrientation(new transform(new Point(32,00,00,00),
                                       new Point(00,32,00,00),
                                       new Point(00,00,32,00),
                                       new Point(10,10,-8,01))); 
  //registerUIElement(new uiDraw(testCheckbox));
  //quadStrokeBezier(b,0.001);
  /*println(new transform(new Point(1,0,0,0),
                                                   new Point(0,1,0,0),
                                                   new Point(0,0,1,0),
                                                   new Point(0,1.1,0,1)).semit(new transform(new Point(2,0,0,0),
                                                   new Point(0,2,0,0),
                                                   new Point(0,0,2,0),
                                                   new Point(0,0,0,1))));*/
}
Bezier an = new Bezier();
double t = 0;

void draw(){drawHook();
  if(world.changed){
    world.draw(camera);
    world.changed = false;
  }
  toolBar.draw(camera);
  
  //testButton.draw(camera); //<>//
  //testCheckbox.draw(camera);
  //testSlider.draw(camera);
  /*if(mousePressed){
    //mouseP();
  }else
  if (an.points.length>0){
    t = (t+0.01)%1;
    an.points[an.points.length-1] = new vv(b.points);
    vv V = ((vv) an.get(t));
    Bezier res = new Bezier(V.v); //<>//
    Path p2 = new Path();
    p2.add(res);
    background(128);
    br.Stroke(p2,0.001);
    
  }*/
}

void mousePressed(MouseEvent e){mousePressedHook(e);
  
  /*b = new Bezier();
  p.add(b);
  
  vector[] old = an.points;
  an.points = new vv[an.points.length+1];
  for(int i = 0; i < old.length; i ++){
    an.points[i] = old[i];
  }
  an.points[old.length] = new vv(b.points);
  
  mouseP();*/
}
polyBrush br = new polyBrush(new style(color(128,255,128),255,color(0,0,0),64));
void keyPressed(KeyEvent e){keyPressedHook(e);
  /*if (key=='p'){
    mouseP();
  }
  //print(key);print(" : ");*/
  println(keyCode);
}
void mouseP(){
 /* vector[] old = b.points;
  b.points = new vnd[b.points.length+1];
  for(int i = 0; i < old.length; i ++){
    b.points[i] = old[i];
  }
  b.points[old.length] = new vnd(mouseX,mouseY);
  background(128);
  //br.Stroke(p,0.001);
  //quadStrokeBezier(b,0.001);*/
}

void keyReleased(KeyEvent e){keyReleasedHook(e);}
void mouseReleased(MouseEvent e){mouseReleasedHook(e);}
void mouseMoved(MouseEvent e){mouseMovedHook(e);}
void mouseClicked(MouseEvent e){mouseClickedHook(e);}
void mouseDragged(MouseEvent e){mouseDraggedHook(e);}
void mouseWheel(MouseEvent e){mouseWheelHook(e); 
println(e);}
