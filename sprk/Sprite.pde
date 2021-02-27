class sprite{
  char[] wasd;
  double spd;
  dvector pos;
  PImage[] frames;
  int frame;
  keyboard kbd;
  //float angle; to be implemented...
  //scale is in the position vector
  

  
  sprite(PImage[] grphx, dvector p, double speed, char[] ctrl, keyboard k){
    frames = grphx;
    pos = p;
    frame = 0;
    wasd = ctrl;
    spd = speed;
    kbd = k;
  }
  sprite(PImage grphx,int numwidth, int numheight,dvector p, double sped, char[] ctrl ,keyboard k){
    frames = new PImage[numwidth*numheight];
    for(int x = 0; x < numwidth; x++){
      for(int y = 0; y < numheight; y++){
        frames[y+numheight*x] = grphx.get(x*grphx.width/numwidth,y*grphx.height/numheight,grphx.width/numwidth,grphx.height/numheight);
      }
    }
    pos = p;
    frame = 0;
    wasd = ctrl;
    spd = sped;
    kbd = k;
  }
  
  
  void update(){
    if(kbd.check(wasd[0])){
      pos = pos.add(new dvector(0,-1).scale(spd));
    }
    if(kbd.check(wasd[1])){
      pos = pos.add(new dvector(-1).scale(spd));
    }
    if(kbd.check(wasd[2])){
      pos = pos.add(new dvector(0,1).scale(spd));
    }
    if(kbd.check(wasd[3])){
      pos = pos.add(new dvector(1).scale(spd));
    }
  }
  void draw(){
    
    
  }
  
}
