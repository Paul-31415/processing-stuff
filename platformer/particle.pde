abstract class particle extends drawable{
  dvector newPos;
  dvector vel;
  dvector newVel;
  dvector accel;
  volume hitbox;
  double lostTime;
  
  collider col;
  
  void step(double dt,world w){
    dt += lostTime;
    lostTime = 0;
    newVel = vel.add(accel.scale(dt));
    newPos = pos.add(vel.add(newVel).scale(dt/2));
    col.check(this,dt,w);
  }
}