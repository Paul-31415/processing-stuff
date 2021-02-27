abstract class distfunc{
  abstract double dist(vec v);
  double dist(ray r){
    return dist(r.start);
  }
}

class marcher extends traceable{
  distfunc d;
  double near = 0.0001;
  double epsilon = 0.0001;
  double far = 1e30;
  int maxS = 100;
  marcher(distfunc D){
    d = D;
  }
  hit trace(ray r){
    double rm = r.dir.mag();
    ray s = new ray(r.start.copy(),r.dir.div(rm));;
    double dist = d.dist(s);
    boolean inside = (dist < -near);
    double totalDist = 0;
    for (int i = 0; i < maxS; i++){
      dist = inside?-d.dist(s):d.dist(s);
      if (dist < near){
        vec n = new vec(d.dist(s.start.add(epsilon,0,0))-dist,d.dist(s.start.add(0,epsilon,0))-dist,d.dist(s.start.add(0,0,epsilon))-dist);
        return new hit(true,r,this,totalDist/rm,s.start,n.divEq(epsilon),i);
      }
      if (dist > far){
        return new hit(false,r,this,totalDist/rm,s.start,new vec(),i);
      }
      totalDist += dist;
      s.travelEq(dist);
    }
    return new hit(false,r,this,totalDist/rm,s.start,new vec(),maxS);
  }
  void quickDraw(double res) {
    /*for (double z = modelZ(0,0,0); z < modelZ(0,0,100); z+= res){
    for (double x = modelY(0,0,0); y < modelY(0,height,0); y+= res){
    for (double x = modelX(0,0,0); x < modelX(width,0,0); x+= res){
      //marching cubes
      
      
    }
    }
    }
    */
      
      
    
    
  }
}

class df_sphere extends distfunc{
  vec origin;
  double radius;
  df_sphere(vec o,double r){
    origin = o; radius = r;
  }
  double dist(vec v){
    return v.sub(origin).mag()-radius;
  }
}
double sq(double i){ return i*i;}
class df_torus extends distfunc{
  vec origin;
  double r1,r2;
  df_torus(vec o,double r,double rb){
    origin = o; r1 = r;r2=rb;
  }
  double dist(vec v){
    vec t = v.sub(origin);
    return Math.sqrt(sq(Math.sqrt(t.x*t.x+t.z*t.z)-r1)+t.y*t.y)-r2;
  }
}

class df_bulb extends distfunc{
  vec origin;
  int iter;
  double bailout = 2;
  double power = 2;
  df_bulb(vec o,int i){
    origin = o; iter = i;
  }
  double dist(vec v){
    vec z = v.sub(origin);
    vec p = z.copy();
    double dr = 1;
    double r = 0;
    for (int i = 0; i < iter; i++){
      r = z.mag();
      if (r > bailout) break;
      
      //polar
      double theta = Math.asin(z.z/r);
      double phi = Math.atan2(z.y,z.x);
      dr = Math.pow(r,power-1.0)*power*dr+1;
      
      //scale and rot point
      double zr = Math.pow(r,power);
      theta *= power;
      phi *= power;
      z.set(new vec(Math.cos(theta)*Math.cos(phi),Math.sin(phi)*Math.cos(theta),Math.sin(theta)).scaleEq(zr));
      z.addEq(p);
    }
    return .5*Math.log(r)*r/dr;
  }
}

class df_union extends distfunc{
  ArrayList<distfunc> objs;
  df_union(distfunc... d){
    objs = new ArrayList<distfunc>();
    for (distfunc f :d){
      objs.add(f);
    }
  }
  double dist(vec v){
    double m = Double.POSITIVE_INFINITY;
    for (distfunc f : objs){
      m = Math.min(m,f.dist(v));
    }
    return m;
  }
  double dist(ray v){
    double m = Double.POSITIVE_INFINITY;
    for (distfunc f : objs){
      m = Math.min(m,f.dist(v));
    }
    return m;
  }
}

class df_intersection extends distfunc{
  ArrayList<distfunc> objs;
  df_intersection(distfunc... d){
    objs = new ArrayList<distfunc>();
    for (distfunc f :d){
      objs.add(f);
    }
  }
  double dist(vec v){
    double m = Double.NEGATIVE_INFINITY;
    for (distfunc f : objs){
      m = Math.max(m,f.dist(v));
    }
    return m;
  }
  double dist(ray v){
    double m = Double.NEGATIVE_INFINITY;
    for (distfunc f : objs){
      m = Math.max(m,f.dist(v));
    }
    return m;
  }
}

class df_complement extends distfunc{
  distfunc obj;
  df_complement(distfunc d){
    obj = d;
  }
  double dist(vec v){
    return -obj.dist(v);
  }
}

class df_smooth_union extends distfunc{
  ArrayList<distfunc> objs;
  double smoothness;
  df_smooth_union(double s,distfunc... d){
    smoothness = s;
    objs = new ArrayList<distfunc>();
    for (distfunc f :d){
      objs.add(f);
    }
  }
  double dist(vec v){
    double sum = 0;
    for (distfunc f : objs){
      double dist = f.dist(v);
      if (dist < 0){
        return dist;
      }
      sum += Math.exp(dist*-smoothness);
    }
    return -Math.log(sum)/smoothness;
  }
  double dist(ray v){
    double sum = 0;
    for (distfunc f : objs){
      double dist = f.dist(v);
      if (dist < 0){
        return dist;
      }
      sum += Math.exp(dist*-smoothness);
    }
    return -Math.log(sum)/smoothness;
  }
}
class df_onion extends distfunc{
  distfunc obj;
  double t;
  df_onion(distfunc d,double T){
    obj = d;t=T;
  }
  double dist(vec v){
    return Math.abs(obj.dist(v))-t;
  }
}
