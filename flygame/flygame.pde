


void setup(){
  size(1024,1024,P3D);
  background(0);
  
  println("tests:");
  println("zero rot euler angle:"+new angle().eulerVec());
  println("90°x rot euler angle:"+new angle().fromAxisAngle(PI/2,0,0).eulerVec());
  println("y rot euler angle:"+new angle().fromAxisAngle(0,1,0).eulerVec());
  println("z rot euler angle:"+new angle().fromAxisAngle(0,0,1).eulerVec());
  lights();
  
  
  
  
}
angle a = new angle();

void axes(float s){
  stroke(color(255,0,0));
  line(0,0,s,0);
  //rect(0,0,.1*s,s);
  stroke(color(0,255,0));
  rotateZ(PI/2);
  line(0,0,s,0);
  //rect(0,0,.1*s,s);
  stroke(color(0,0,255));
  rotateZ(-PI/2);
  rotateY(-PI/2);
  line(0,0,s,0);
  //rect(0,0,.1*s,s);
  rotateY(PI/2);
}

void axes(float s,angle a){
  noStroke();
  fill(color(128));
  sphere(s*.1);
  fill(color(255,0,0));
  vec v = a.apply(new vec(s,0,0));
  v.translate_();
  sphere(s*.1);
  fill(color(0,255,0));
  v.untranslate_();
  v = a.apply(new vec(0,s,0));
  v.translate_();
  sphere(s*.1);
  fill(color(0,0,255));
  v.untranslate_();
  v = a.apply(new vec(0,0,s));
  v.translate_();
  sphere(s*.1);
  v.untranslate_();
}
/*
void draw(){
  lights();
  sphereDetail(4);
  //translate(width/2,height/2);
  background(0);
    translate(width/2,height/2,1);
  for (int x = -5; x <= 5; x++){
    for (int y = -5; y <= 5; y++){
    translate(x*80,y*80,0);
    a.rotate_();
    strokeWeight(3);
    axes(70);
    translate(30,30,30);
    noFill();
    stroke(color(255,255,0));
    box(25);
    translate(-30,-30,-30);
    a.unrotate_();
    noStroke();
    axes(30,a);
    fill(255);
    vec p = a.apply(new vec(30,30,30));
    p.translate_();
    a.rotate_();
    box(20);
    a.unrotate_();
    p.untranslate_();
    translate(-x*80,-y*80,0);
    }
  }
  
  translate(-width/2,-height/2,-1);
  
  if (key=='1'){
    a=a.plus(a.fromAxisAngle(.05,0,0));
  }
  if (key=='2'){
    a=a.plus(a.fromAxisAngle(0,.05,0));
  }
  if (key=='3'){
    a=a.plus(a.fromAxisAngle(0,0,.05));
  }
  if (key=='r'){
    a=new angle();
  }
}
*/





void keyPressed(){
  
}
