class star{
  double[] pos;
  double mass;
  double[] vel;
  double temp;
  double age;
  
  star(double[] p, double[] v,double m){
    mass = m;
    vel = v;
    pos = p;
  }
  
  void step(double dt){
    for(int i = 0; i < pos.length; i++){
      pos[i] += dt*vel[i];
    }
  }
  
  
}
