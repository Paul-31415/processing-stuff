

world w;
keyboard k;

double r = 0.25;
sparkType st = (sparkType)new thickFadeSpark(color(255,255,128),color(255,0,0),10,0);
collider cl = (collider) new zCollider(.75);
boolean viewPortControll = true;
sprite ram1;
sprite ram2;
player p1;
player p2;
collider nc = new nullcollider();

char[] wasd = {'w','a','s','d'};
char[] ijkl = {'i','j','k','l'};
dvector[] dirs = {new dvector(0,0.1) ,new dvector(-0.1) ,new dvector(0,-0.1),new dvector(0.1)};

void setup(){
   size(1600,850);
   noSmooth();
   k = new keyboard();
   
   w = new world(new dvector(-1.125,-1.125,10),new dvector(128,-128,0.25),new dvector(width/2,height/2));
   w.timeScale = 1;
   ram1 = new sprite(loadImage("./green_npc_ram.png"),4,4,new dvector(0,0,0,84*4,64*4),new dvector(), new dvector(), nc);
   ram2 = new sprite(loadImage("./green_npc_ram.png"),4,4,new dvector(0,0,0,84*4,64*4),new dvector(), new dvector(), nc);
   p1 = new player(wasd, dirs,ram1,k);
   p2 = new player(ijkl, dirs,ram2,k);
   w.addDrawable( (drawable) p1,(drawable)p2);
   
}



void draw(){
  background(0);
  spark[] s = new spark[1];
  for(int i = 0; i < s.length; i ++)
    s[i] = new spark(st, 6, 30, new dvector(1+sin(millis()/314.1*4),cos(millis()/314.1*4),-1), new dvector(.3+random(.6),millis()/3141.5,millis()/314.1*4).cartesian().scale(25).add(new dvector(0.7,21).scale(0)), new dvector(0,0,49), cl);
  
  //w.addDrawable((drawable[])s);
  
  
  
  
  
  
  
  w.step();
  w.render();
  w.cull();
  
  
  if(viewPortControll){
  if(key == 'w'){
    w.offset = w.offset.add(new dvector(0,0,-r));
  }
  if(key == 's'){
    w.offset = w.offset.add(new dvector(0,0,r));
  }
  if(key == 'a'){
    w.offset = w.offset.add(new dvector(r));
  }
  if(key == 'd'){
    w.offset = w.offset.add(new dvector(-r));
  }
  if(key == 'q'){
    w.offset = w.offset.add(new dvector(0,-r));
  }
  if(key == 'z'){
    w.offset = w.offset.add(new dvector(0,r));
  }
  if(key == 'e'){
    w.scale = w.scale.mul(new dvector(1,1,1.03125));
  }
  if(key == 'c'){
    w.scale = w.scale.mul(new dvector(1,1,1/1.03125));
  }
  }
}



void keyPressed(){
  k.keyPressed();
}
void keyReleased(){
  k.keyReleased();
}
