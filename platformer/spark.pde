class spark extends particle {
  dvector[] oldPos;
  double life;
  sparkType type;
  
  spark(sparkType t,int trail,double l, dvector p, dvector v, dvector a, collider cld){
    pos = p;
    vel = v;
    accel = a;
    col = cld;
    life = l;
    type = t;
    oldPos = new dvector[trail];
    for(int i = 0; i < oldPos.length; i++){
      oldPos[i] = pos.copy();
    }
  }
  
  void step(double dt,world w){
    dt += lostTime;
    lostTime = 0;
    if(type.stepFunc(this)){
    life -= dt;
    removeMeFromDrawables = (life < 0);
    removeMeFromStepables = (life < 0);
    newVel = vel.add(accel.scale(dt));
    newPos = pos.add(vel.add(newVel).scale(dt/2));
    for(int i = oldPos.length-1; i > 0 ;i--)
      oldPos[i] = oldPos[i-1];
    oldPos[0] = pos.copy();
    }
    col.check(this,dt,w);
  }
  

  
  void draw(dvector offset,dvector scale,dvector drawOffset){
    if(type.drawFunc(this)){
    dvector p = pos;
    for(int i = 0; i < oldPos.length; i++){
      type.drawSegment(p,oldPos[i],offset,scale,drawOffset,i,this);
      p = oldPos[i];
    }
  }}
  boolean visible(dvector offset,dvector scale,dvector drawOffset){
   return pos.simple3dUnnormalized(offset,scale).get(2)>0;
  }
}

abstract class sparkType{
  abstract void drawSegment(dvector a, dvector b,dvector o,dvector sc, dvector d,int i,spark s);
  abstract boolean drawFunc(spark s);
  abstract boolean stepFunc(spark s);
}

class debugSpark extends sparkType{
  double t;
  debugSpark(double thickness){
    t = thickness;
  }
  
  boolean drawFunc(spark s){ return true;}
  boolean stepFunc(spark s){ return true;}
  
  void drawSegment(dvector a, dvector b, dvector o,dvector sc, dvector d, int i, spark s){
    stroke(color((int)(128+(s.lostTime)),(int)(255-0*Math.log(s.lostTime)),255));
    strokeWeight(abs((float)(t/a.simple3dUnnormalized(o,sc).get(2))));
    a = a.simple3d(o,sc,d);
    b = b.simple3d(o,sc,d);
    line((float)a.get(0),(float)a.get(1),(float)b.get(0),(float)b.get(1));
  }
}


class simpleSpark extends sparkType{
  color c;
  simpleSpark(color col){
    c =col;
  }
  
  boolean drawFunc(spark s){ return true;}
  boolean stepFunc(spark s){ return true;}
  
  void drawSegment(dvector a, dvector b, dvector o,dvector sc, dvector d, int i, spark s){
    stroke(c);
    strokeWeight(1);
    a = a.simple3d(o,sc,d);
    b = b.simple3d(o,sc,d);
    line((float)a.get(0),(float)a.get(1),(float)b.get(0),(float)b.get(1));
  }
}

class thickSpark extends sparkType{
  color c;
  double t;
  thickSpark(color col,double thickness){
    c =col;
    t = thickness;
  }
  
  boolean drawFunc(spark s){ return true;}
  boolean stepFunc(spark s){ return true;}
  
  void drawSegment(dvector a, dvector b, dvector o,dvector sc, dvector d, int i, spark s){
    stroke(c);
    strokeWeight((float)(t/a.simple3dUnnormalized(o,sc).get(2)));
    a = a.simple3d(o,sc,d);
    b = b.simple3d(o,sc,d);
    line((float)a.get(0),(float)a.get(1),(float)b.get(0),(float)b.get(1));
  }
}

class thickFadeSpark extends sparkType{
  color c;
  color c2;
  double t;
  double t2;
  thickFadeSpark(color col,color col2,double thickness,double th2){
    c =col;
    c2 = col2;
    t = thickness;
    t2=th2;
  }
  
  boolean drawFunc(spark s){ return true;}
  boolean stepFunc(spark s){ return true;}
  int shade(double a, double b, double v){
    return (int)(a*(1-v)+b*v);
  }
  
  void drawSegment(dvector a, dvector b, dvector o,dvector sc, dvector d, int i, spark s){
    stroke(color(shade(red(c),red(c2),(double)i/s.oldPos.length),shade(green(c),green(c2),(double)i/s.oldPos.length),shade(blue(c),blue(c2),(double)i/s.oldPos.length)));
    strokeWeight(abs((float)(shade(t,t2,(double)i/s.oldPos.length)/a.simple3dUnnormalized(o,sc).get(2))));
    a = a.simple3d(o,sc,d);
    b = b.simple3d(o,sc,d);
    line((float)a.get(0),(float)a.get(1),(float)b.get(0),(float)b.get(1));
  }
}
