class Ion
{
  public double[] pos;
  public double[] vel; 
  public double charge; 
  public double mass;
  public Ion(double[] p,double[] v,double c,double m){
    pos = p;
    vel = v;
    charge = c;
    mass = m;
  }
  public void addVel(){
   for (int i = 0; i < vel.length; i++){ 
     pos[i] += vel[i];
   }
  }
  public double energy(){
    //mv^2
    double v2 = 0;
    for( double v : vel)
      v2 += v * v;
    return mass*v2;
  }
  public double velR(){
    float v2 = 0;
    for( double v : vel)
      v2 += v * v;
    return sqrt(v2);
  }
}