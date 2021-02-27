
boolean[] heldKeys;
int mouseDX=0;
int mouseDY=0;

boolean record = false;

world w;
ArrayList<ArrayList<rock>> camCenters;
void setup(){
  randomSeed(288382);
  
  size(1024,1024,P3D);
  //frustum(-1e3,1e3,1e3,-1e3,1e-1,1e2);
  camCenters = new ArrayList<ArrayList<rock>>();
  camCenters.add(new ArrayList<rock>());
  //camera(0,0,0,0,0,1,0,1,0);
  perspective(PI/3.,1,((height/2.0) / tan(PI*60.0/360.0))/100.,((height/2.0) / tan(PI*60.0/360.0))*1e12);
  fill(128);
  heldKeys = new boolean[256];
  for(int i = 0; i < heldKeys.length;i++){
    heldKeys[i]=false;
  }
  lights();//directionalLight(240,240,240,.7,.7,0);
  w = new world();
  //w.rocks.add(new rock(new vec(0,0,-30),new vec(.0,0,0),1,1,color(128)));
  
  //w.rocks.add(new rock(new vec(0,30,-30),new vec(-.0,0,0),10,10));
  //w.rocks.add(new rock(new vec(30,30,-30),new vec(0,0,0),10,10));
  //w.rocks.add(new rock(new vec(0,-30,-30),new vec(0,0,0),1e24,60000));
  int n = 4;
  for (int x = 0; x < n; x++){
   for (int y = 0; y < n; y++){
     for (int z = 0; z < n; z++){
       double s = (random(2)+.1)*1000;
       double d = random(1602)+1602/2;
      rock r = new rock(new vec(x*4,y*4,z*4),new vec(0),4/3.*PI*s*s*s*d,s,color((int)(255-(d/1602.)*64)));
      w.rocks.add(r);
      camCenters.get(0).add(r);
     }
   }
  }
  /* funtime experiments
  double d = 1932000;//4e17 1e9 19320 7300
  double ra = 1e3;
  rock r = new rock(new vec(-100000,2,2),new vec(0*200),4/3.*PI*ra*ra*ra  *d,ra,color(60,40,40));
      w.rocks.add(r);
      camCenters.get(0).add(r);
      r = new rock(new vec(-100000-4*ra,2,2),new vec(-0*200),-4/6.*PI*ra*ra*ra*d,ra,color(60,40,40));
      w.rocks.add(r);
      //camCenters.get(0).add(r);
   //*/
}
double[] zooms = {.01,100./60000000};
vec pos = new vec(0,0,0);
angle rot = new angle();//.fromAxisAngle(0,0,0);
double speed = 10;
double simSpeed = 1;
int steps = 16;
double angleRate=.01;


int camCenter = 0;
void draw(){
  background(0);
  noStroke();
  lights();
  
  vec cme = new vec();
  double mtot = (double)1e-20;
  for( rock r : camCenters.get(camCenter)){
    mtot += r.mass;
    cme.addEq(r.pos.scale(r.mass));
  }
  translate(width/2,height/2);
  w.draw(pos.add(cme.divEq(mtot)),rot,zooms[camCenter]);
  translate(-width/2,-height/2);
  
  for (int i = 0; i < steps; i++){
    w.update(simSpeed);
  }
  vec dpos = new vec();
  if (heldKeys[32]){
    dpos.subEq(0,speed,0);
    
  }
  if (heldKeys[16]){
    dpos.addEq(0,speed,0);
  }
  if (heldKeys[65]){
    dpos.subEq(speed,0,0);
  }
  if (heldKeys[68]){
    dpos.addEq(speed,0,0);
  }
  if (heldKeys[87]){
    dpos.subEq(0,0,speed);
  }
  if (heldKeys[83]){
    dpos.addEq(0,0,speed);
  }
  
  if (heldKeys[61]){
    zooms[camCenter]*=1.05;
  }
  if (heldKeys[45]){
    zooms[camCenter]/=1.05;
  }
  
  if (heldKeys[93]){
    if(simSpeed*1.1 < 1000)
    simSpeed*=1.1; 
  }
  if (heldKeys[91]){
    simSpeed/=1.1;
  }
  if (heldKeys[39]){
    steps+=1;
  }
  if (heldKeys[59]){
    steps-=1;
  }
  if (heldKeys[50]){
    G*=1.1; 
  }
  if (heldKeys[49]){
    G/=1.1;
  }
  
  rot = new angle().fromAxisAngle(Math.PI/2,0,0)
    .plus(new angle().fromAxisAngle(angleRate*(mouseY-height/2),0,0))
    .plus(new angle().fromAxisAngle(0,angleRate*(mouseX-width/2),0));
  //*///rot = rot.plus(new angle().fromAxisAngle(1/100.,0,0));
  //print(dpos.mag(),rot.apply(dpos).mag());
 
   
  pos.addEq(rot.apply(dpos));
  fill(color(255,0,0));
  text(pos.x+"",10,10);
  fill(color(0,255,0));
  text(pos.y+"",10,30);
  fill(color(0,0,255));
  text(pos.z+"",10,50);
  fill(color(255,255,255));
  text("time/step:"+simSpeed+" s",10,80);
  text("steps/frame:"+steps,10,92);
  text("G:"+G,10,104);
  fill(color(128,255,0));
  text("Time Rate:"+(simSpeed*steps)*60,10,120);
}


void keyPressed(){
  heldKeys[keyCode] = true;
  println(keyCode);
  if (key=='p'){
    rock saturn = new rock(new vec(60000000*0,60000000*1.5,0),new vec(-20e3,0,0),5.683e26,58.232e6,color(200,200,0));
    w.rocks.add(saturn);
    camCenters.add(new ArrayList<rock>());
    camCenters.get(camCenters.size()-1).add(saturn);
    print("saturn added");
    //w.rocks.add(new rock(new vec(60000000,600000,-30),new vec(-1,0,0),1e24,60000));
  }
  if (key=='o'){
    rock saturn = new rock(new vec(60000000*10,60000000*0,0),new vec(0,-4e3,0),5.683e26,58.232e6,color(200,200,0));
    w.rocks.add(saturn);
    camCenters.add(new ArrayList<rock>());
    camCenters.get(camCenters.size()-1).add(saturn);
    print("saturn added");
    //w.rocks.add(new rock(new vec(60000000,600000,-30),new vec(-1,0,0),1e24,60000));
  }
  if (key=='c'){
    camCenter = (camCenter+1)%camCenters.size();
  }
  
}
void keyReleased(){
  heldKeys[keyCode] = false;
}
  
void mouseMoved(MouseEvent e){
  mouseDX+=e.getX();
  mouseDY+=e.getY();
}
