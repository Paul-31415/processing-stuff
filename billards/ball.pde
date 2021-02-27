class Ball{
  vec pos,vel;
  double size,mass;
  Ball(){
      pos = new vec();
      vel = new vec();
      size = 1;
      mass = 1;
  }
  Ball(vec Pos, vec Vel, double Size,double Mass){
    pos = Pos;
    vel = Vel;
    size = Size;
    mass = Mass;
  }
  Ball relativeTo(Ball o){
    return new Ball(pos.sub(o.pos),vel.sub(o.vel),size,mass);
  }
  void advance(double t){
    pos.addEq(vel.scale(t));
  }
  void draw(double t){
    ellipse((float)(pos.x-size+vel.x*t),(float)(pos.y-size+vel.y*t),(float)(pos.x+size+vel.x*t),(float)(pos.y+size+vel.y*t)); 
  }
  double intersect(double s){
    // mag(pos+vel*t)=size+s, min t>0;
    // d = mag(pos+vel*t)-size-s;
    // (pos+vel*t)•(pos+vel*t) = (size+s)^2;
    // pos•(pos+vel*t)+t*vel•(pos+vel*t)
    // pos•pos+t*pos•vel+t*pos•vel+t^2*vel•vel=(size+s)^2
    
    double a = vel.dot(vel);
    double b = pos.dot(vel)*2;
    double c = pos.dot(pos)-(size+s)*(size+s);
    if (a == 0){
      return inf;
    }
    double det = b*b-4*a*c;
    if (det < 0){
      return inf;
    }
    det = Math.sqrt(det)/(2*a);
    b = -b/(2*a);
    if (b-det>0){
      return b-det;
    }
    if (b+det>0){
      return b+det;//shouldn't have to get here, it's in the uncoliding zone
    }
    return inf;
  }
  
}
