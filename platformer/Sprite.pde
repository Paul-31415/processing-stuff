/*
class Sprite{
  dvector pos;
  renderer rend;
  stepper stepr;
  
  Sprite(dvector p, renderer r, stepper s){
    pos = p;
    rend = r;
    stepr = s;
  }
  
  
  
}*/



class sprite extends particle {
  
  
  PImage[] frames;
  int frame;
  //float angle; to be implemented...
  //scale is in the position vector
  

  
  sprite(PImage[] grphx, dvector p, dvector v, dvector a, collider c){
    frames = grphx;
    pos = p;
    vel = v;
    accel = a;
    col = c;
    frame = 0;
  }
  sprite(PImage grphx,int numwidth, int numheight, dvector p, dvector v, dvector a, collider c){
    frames = new PImage[numwidth*numheight];
    for(int x = 0; x < numwidth; x++){
      for(int y = 0; y < numheight; y++){
        frames[y+numheight*x] = grphx.get(x*grphx.width/numwidth,y*grphx.height/numheight,grphx.width/numwidth,grphx.height/numheight);
      }
    }
    pos = p;
    vel = v;
    accel = a;
    col = c;
    frame = 0;
  }
  
  void setScale(double sx, double sy){
    pos.set(3,sx);
    pos.set(4,sy);
    
  }
  
  void draw(dvector offset,dvector scale,dvector drawOffset){
    dvector p = pos.simple3d(offset,scale,drawOffset);
    //crude 3d
    image(frames[frame],(float)p.get(0),(float)p.get(1),(float)p.get(3),(float)p.get(4));
  }
  boolean visible(dvector offset,dvector scale,dvector drawOffset){
   return pos.simple3dUnnormalized(offset,scale).get(2)>0;
  }
  int compareTo(drawable other){
    return ((Double)other.pos.get(2)).compareTo(this.pos.get(2));
  } //closer sprites are "greater than" farther sprites (on the z direction)
  
}