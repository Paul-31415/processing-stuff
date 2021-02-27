abstract class traceable{
  abstract intersection trace(ray r);
  intersection trace(ray r,intersection current){
    intersection res = this.trace(r);
    if (res.intersects){
      if(current.intersects){
        if(res.t < current.t){
          return res;}
        return current;}
      return res;}
    return current;}
}

class bitbg extends traceable{
  double size;
  bitbg(double s){
    size = s;
  }
  
  intersection trace(ray r){
    vec bgv = r.dir.normalize().scale(127);
    int c = (int)bgv.get(2) ^ (((int)bgv.get(1)^(int)bgv.get(0))&31);
    return new intersection(size,true,color(abs((c))%128));
  }
}


class Triangle extends traceable{
  vec p0;
  vec p1;
  vec p2;
  vec n;
  Color c;
  double EPSILON = 0.000000001;
  Triangle(vec a, vec b, vec C, Color col){
    p0 = a.copy();
    p1 = b.copy();
    p2 = C.copy();
    n = p1.add(p0.neg()).cross(p2.add(p0.neg()));
    c = col;
  }
  
  
  intersection trace(ray r){
    vec e1 = p1.add(p0.neg());
    vec e2 = p2.add(p0.neg());
    
    vec h = r.dir.cross(e2);
    double a = e1.dot(h);
    if (a < EPSILON && a > -EPSILON)
      return new intersection(0,false,0);
    
    double f = 1./a;
    vec s = r.pos.add(p0.neg());
    double u = f * s.dot(h);
    
    if ( u < 0 || u > 1){
      return new intersection(0,false,0);
    }
    
    vec q = s.cross(e1);
    double v = r.dir.dot(q) * f ;
    
    if (v < 0 || u+v>1){
      return new intersection(0,false,0);
    }
    
    double t = f * e2.dot(q);
    
    
    if (t > 0){
      return new intersection(t,true, c.get(this,n,r,t,u,v));
    }else{
      return new intersection(t,false,0);
    }
  }
  
  
  intersection trace(ray r,intersection current){
    if(current.intersects && !r.hasPotentialCloser(current.t,p0,p1,p2))
      return current;
    
    intersection res = this.trace(r);
    if (res.intersects){
      if(current.intersects){
        if(res.t < current.t){
          return res;}
        return current;}
      return res;}
    return current;}
}



class Parallelogram extends traceable{
  vec p0;
  vec p1;
  vec p2;
  vec n;
  Color c;
  double EPSILON = 0.000000001;
  Parallelogram(vec a, vec b, vec C, Color col){
    p0 = a.copy();
    p1 = b.copy();
    p2 = C.copy();
    n = p1.add(p0.neg()).cross(p2.add(p0.neg()));
    c = col;
  }
  
  
  intersection trace(ray r){
    vec e1 = p1.add(p0.neg());
    vec e2 = p2.add(p0.neg());
    
    vec h = r.dir.cross(e2);
    double a = e1.dot(h);
    if (a < EPSILON && a > -EPSILON)
      return new intersection(0,false,0);
    
    double f = 1./a;
    vec s = r.pos.add(p0.neg());
    double u = f * s.dot(h);
    
    if ( u < 0 || u > 1){
      return new intersection(0,false,0);
    }
    
    vec q = s.cross(e1);
    double v = r.dir.dot(q) * f ;
    
    if (v < 0 || v>1){
      return new intersection(0,false,0);
    }
    
    double t = f * e2.dot(q);
    
    
    if (t > 0){
      return new intersection(t,true, c.get(this,n,r,t,u,v));
    }else{
      return new intersection(t,false,0);
    }
  }
  
  intersection trace(ray r,intersection current){
    if(current.intersects && !r.hasPotentialCloser(current.t,p0,p1,p2,p1.add(p2,p0.neg())))
      return current;
    
    intersection res = this.trace(r);
    if (res.intersects){
      if(current.intersects){
        if(res.t < current.t){
          return res;}
        return current;}
      return res;}
    return current;}
  
}

class Sphere extends traceable{
  vec pos;
  double radius2;
  double radius;
  Color c;
  
  Sphere(vec p, double r,Color C){
    pos = p;
    radius2 = r*r;
    radius = r;
    c = C;
  }
  intersection trace(ray r){
    double t0,t1;
    vec l = pos.neg().add(r.pos);
    double a = r.dir.mag2();
    double b = 2 * r.dir.dot(l);
    double C = l.mag2()-radius2;
    double rt = b*b-4*a*C;
    if (rt < 0)
      return new intersection(0,false,0);
      
    double tca = Math.sqrt(rt)/(2*a);
    t0 = (tca+b);
    t1 = (tca-b);
    if (t0 > t1 || t0 < 0){
      t0 = t1;
    }
    t0 = t0/r.dir.mag();
    if (t0 > 0)
      return new intersection(t0,true,c.get(this,pos.neg().add(r.get(t0)),r,t0,0,0));
    
    return new intersection(0,false,0);
  }
  
  intersection trace(ray r,intersection current){
    
    //if(current.intersects && !r.hasPotentialCloser(current.t,pos.add(new vec(radius,radius,radius)),pos.add(new vec(-radius,radius,radius)),pos.add(new vec(radius,-radius,radius)),pos.add(new vec(-radius,-radius,radius)),pos.add(new vec(radius,radius,-radius)),pos.add(new vec(-radius,radius,-radius)),pos.add(new vec(radius,-radius,-radius)),pos.add(new vec(-radius,-radius,-radius))))
      //return current;
    
    intersection res = this.trace(r);
    if (res.intersects){
      if(current.intersects){
        if(res.t < current.t){
          return res;}
        return current;}
      return res;}
    return current;}
  
  
  
}







abstract class ScalarField{
  abstract double get(vec pos);
}


class PotentialField extends traceable{
  ScalarField f;
  double prec;
  Color c;
  
  PotentialField(ScalarField fld, double p,Color C){
    f = fld;
    prec = p;
    c = C;
  }
  intersection trace(ray r){
    
    return new intersection(0,false,0);
  }
  
}
