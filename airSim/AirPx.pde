class AirPx
{
  public double density; 
  public double temp; 
  public double[] flow; 
  public double newDensity; 
  public double newTemp; 
  public double[] newFlow;
  public AirPx(double d,double t,double[] f){
    density = d;
    temp = t;
    flow = f;
    newDensity = d;
    newTemp = t;
    newFlow = f;
  }
  private double avg(double a,double b, double q){
    return a * q + b * (1-q);    
  }
  private double vel2(){
    double v2 = 0;
    for(double v:flow)
      v2 += v * v;
    return v2;
  }
  public void move(AirPx b, double frac){
    if(frac < 0){
      b.move(this,-frac);
      return;
    }
    
    double amount = density * frac;
    if(amount > 0){
      b.newDensity += amount;
      newDensity -= amount;
      if (newDensity < 0){
        newDensity = 0;
      }

      for(int i = 0; i < flow.length ; i ++)
        b.newFlow[i] = avg(flow[i],b.newFlow[i],amount/(amount+b.density));
      b.newTemp = avg(temp,b.newTemp,amount/(amount+b.density));
      //adiobatic heating/cooling pv=nrt, dp*v + dv*p = dt
      // dn = amount, n = density, v = 1 + dn/n, dv = -dn/n, p = pressure(), dp = hmmm, it heats up tho
      //newTemp -= (1-temp)/amount;
      //b.newTemp += (1-temp)/amount;
    }
  }

    
  

  
  public void update(float e){
    density = min((float)newDensity,1e8);
    temp = min((float)newTemp,1e8);
    for(int i = 0 ; i < flow.length ; i ++)
      flow[i] = max(0,min((float)newFlow[i],1/e));
  }
  public void discard(){
    newDensity = density;
    newTemp = temp;
    for(int i = 0 ; i < flow.length ; i ++)
      newFlow[i] = flow[i];
  }
  public double pressure(){
    return density * temp;
  }
  public color Color(int mode){
    if(mode == 0)
      return color((int)(temp/5),(int)(flow[0]*16+127),(int)(flow[1]*16+127));
    if(mode == 1)
      return color((int)(temp/4),(int)(pressure()/16),(int)(density*64));
    return color(0,0,0);
  }
  
}