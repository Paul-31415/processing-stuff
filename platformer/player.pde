class player extends drawable{
  char[] wasd;
  dvector[] dirs;
  sprite s;
  keyboard k;
  double health;
  
  player(char[] ctrl, dvector[] d,sprite sp,keyboard kbd){
    wasd = ctrl;
    dirs = d;
    s = sp;
    k = kbd;
    pos = s.pos;
    health = 1;
  }
  
  void draw(dvector a,dvector b, dvector c){
    s.draw(a,b,c);
    text((int)(100*health),1,1);
  }
  void step(double dt, world w){
    s.step(dt,w);
     
    for(int i = 0; i < wasd.length; i++){
      if(k.ey(wasd[i])){
        s.pos = s.pos.add(dirs[i]); 
      }
    }
    pos = s.pos;
    
    w.addDrawable((drawable) new spark(st, 6, 30, pos, new dvector(.3+random(.6),millis()/3141.5,millis()/314.1*4).cartesian().scale(25).add(new dvector(0.7,21).scale(0)), new dvector(0,0,49), cl));

    
  }
}
