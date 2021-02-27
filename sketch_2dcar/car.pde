class car{
  double x,y,a,w,vx,vy;
  double ix,iy;
  double[][] poly;
  double tireVel = 0;
  double steer = 0;
  double staticFriction = 1;
  
  car(){
    
    
    
    
    x=0;y=0;
    a=0;w=0;vx=0;vy=0;
    ix = 1; iy = 0;
    poly = new double[][] {new double[]{-0.5,0},new double[]{-.6,-.3},new double[]{1,0},new double[]{-.6,.3}};
  }
  
  void i(){
    ix = Math.cos(a);
    iy = -Math.sin(a);
  }
  
  double[] toLoc(double... p){
    return new double[] {ix*p[0]+iy*p[1],iy*p[0]-ix*p[1]};
  }
  double[] fromLoc(double... p){
    return new double[] {ix*p[0]+iy*p[1],-iy*p[0]+ix*p[1]};
  }
  void draw(double s){
    beginShape();
    for (double[] p : poly){
      double[] pt = fromLoc(p);
      vertex((float)((pt[0]+x)*s),(float)((pt[1]+y)*s));
    }
    endShape();
  }
  void step(double s){
    double[] p = toLoc(x,y);
    
    
    
    
    
    
    
    x += vx*s;
    y += vy*s;
    a += w*s;
    i();
    
    
  }
  
}
