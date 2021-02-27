
class gas{
  double mass;
  double temp;
  double[] vel;

  gas(double d,double[] v,double t){
    mass = d;
    vel = v;
    temp = t;
  }
  
  gas(gas in){
    mass = in.mass;
    vel = in.vel.clone();
    temp = in.temp;
  }
  
  void setTo(gas in){
    mass = in.mass;
    vel = in.vel.clone();
    temp = in.temp;
  }
  double e(){
    //total kinetic energy
    double v2 = 0;
    for(int i = 0; i < vel.length; i++){
      v2 += vel[i]*vel[i];
    }
    return mass/2*v2+mass*temp;
  }
  
  double[] p(){
    double[] r = vel.clone();
    for (int i = 0; i < r.length; i++){
      r[i] *= mass;
    }
    return r;
  }
  double ke(){
    double v2 = 0;
    for(int i = 0; i < vel.length; i++){
      v2 += vel[i]*vel[i];
    }
    return mass/2*v2;
  }
  double ed(){
    double v2 = 0;
    for(int i = 0; i < vel.length; i++){
      v2 += vel[i]*vel[i];
    }
    return v2;
  }
  
  
  void add(gas in){
      
      
      mass += in.mass;
      if(mass != 0){
      double fact = in.mass/mass;
      double eBefore = (in.ed()+in.temp)*(1-fact)+(ed()+temp)*fact;
      for(int i = 0; i < vel.length; i++){
        vel[i] = (1-fact)*vel[i]+in.vel[i]*fact;
      }
      temp = (1-fact)*temp+in.temp*fact;
      
      
      temp = (eBefore-ed());
      
      if(temp!=temp){
        print('e');
      }
      }
  }
  void subtract(gas in){
      double eBefore = ed()+temp;
      
      double fact = 1-in.mass/mass;
      mass -= in.mass;
      
      if(fact != 0){
      for(int i = 0; i < vel.length; i++){
        vel[i] = (vel[i]-(1-fact)*in.vel[i])/fact;
      }
      
      }
      
      temp = (eBefore-ed());
      
      if(temp<0){
        print('E');
        temp = 0;
      }
      
  }
  double tv(){
    //t is in joules/particle
    return Math.sqrt(temp/2);
  }
}


class gasVoxel{
  gas content;
  gas newCont;
  gasVoxel[][] neighbors;//[[+x,-x],[+y,-y]...]
  double cohesion = 0;
 
  gasVoxel(double d,double[] v,double t){
    content = new gas(d,v,t);
    newCont = new gas(content);
    neighbors = new gasVoxel[v.length][2];
    //dif = new gasVoxel(v.length);
  }
  
  void setNeighbor(int dim, int dir,gasVoxel n){
    neighbors[dim][dir] = n;
  }
  void send(double dt){
    double[] p = newCont.p();
    double tv = content.temp/1000;//content.tv();
    double total = 0;
    for(int i = 0; i < content.vel.length; i++){
      total += Math.abs(content.vel[i]);
    }
    total += tv*2*content.vel.length;
    total*=dt;
    double factor = 1;
    if (total>1)
      factor = 1/total;
    
    double[] po = new double[content.vel.length];
    for(int i = 0; i < content.vel.length; i++){
      po[i] = 0;
    }
    for(int i = 0; i < content.vel.length; i++){
      if(neighbors[i][content.vel[i]>0?0:1] != null){
        double[] vtmp = content.vel.clone();
        //vtmp[i] -= dt*cohesion;
        gas part = new gas(factor*content.mass*dt*Math.abs(content.vel[i]),vtmp,content.temp);
        double[] pa = part.p();
        for(int j = 0; j < content.vel.length; j++){
          po[j] += pa[j];
        }
        neighbors[i][content.vel[i]>0?0:1].newCont.add(part); 
        newCont.subtract(part);
      }
      for(int dir = 0; dir < 2; dir++){
        if(neighbors[i][dir] != null){
        double[] vtmp = content.vel.clone();
        vtmp[i] += (1-dir*2)*tv;
        gas part = new gas(factor*content.mass*dt*tv,vtmp,content.temp);
        neighbors[i][dir].newCont.add(part);
        newCont.subtract(part);
        }
      }
    }
    /*if(newCont.mass<0 || newCont.mass!=newCont.mass){
      print(newCont.mass);
      print(factor);
      newCont.mass=0;
    }*/
    for(int i = 0; i < newCont.vel.length; i++){
      if(newCont.vel[i]!=newCont.vel[i]){
        newCont.vel[i] = 0;
      }
    }
    
    double[] pn = newCont.p();
    for(int i = 0; i < content.vel.length; i++){
      pn[i] += po[i];
    }
    double pnet = 0;
    for(int i = 0; i < content.vel.length; i++){
      pnet += (pn[i] - p[i])*(pn[i] - p[i]);
      //newCont.vel[i] += (p[i] - pn[i])/newCont.mass;
    }
    if (pnet!=0){
      //print(pnet);
      //print(' ');
      
    }
    
  }
  
  
  void next(){
    content.setTo(newCont);
  }
}
