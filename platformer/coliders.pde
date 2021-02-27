abstract class collider{
  abstract void check(particle s,double dt,world w);
}

class nullcollider extends collider{
  nullcollider(){}
  void check(particle s,double dt,world w){
    s.pos = s.newPos;
    s.vel = s.newVel;
  }
}
class xAxiscollider extends collider{
  double bounce;
  xAxiscollider(double b){
    bounce = b;
  }
  void check(particle s,double dt,world w){

    if(s.newPos.get(1) < 0){
      dvector step = s.newPos.add(s.pos.scale(-1));
      s.newPos = s.pos.add(step.scale(-s.pos.get(1)/step.get(1)));
      s.newVel.set(1,Math.abs(bounce*s.newVel.get(1)));
      s.lostTime -= dt*(s.pos.get(1)/step.get(1));
      if (s.newVel.add(s.accel.scale(dt)).get(1)<0){
        s.newVel.set(1,s.accel.get(1)*dt);
      }
      
    }
    s.pos = s.newPos;
    s.vel = s.newVel;
  }
}

class zCollider extends collider{
  double bounce;
  zCollider(double b){
    bounce = b;
  }
  void check(particle s,double dt,world w){
    if(s.newPos.get(2) > 0){
      dvector step = s.newPos.add(s.pos.scale(-1));
      s.newPos = s.pos.add(step.scale(-s.pos.get(2)/step.get(2)));
      s.newVel.set(2,-Math.abs(bounce*s.newVel.get(2)));
      s.lostTime -= dt*(s.pos.get(2)/step.get(2));
      if (s.newVel.add(s.accel.scale(dt)).get(2)<0){
        s.newVel.set(2,-s.accel.get(2)*dt);
      }
      
    }
    s.pos = s.newPos;
    s.vel = s.newVel;
  }
}




class generalCollider extends collider{
  void check(particle s,double dt,world w){
  
  }
}
