class Color{
  color c;
  Color(color C){ c = C;}
  color get(traceable o,vec n,ray r, double t, double u, double v){return c;}
}

class randColor extends Color{
  color c1;
  color c2;
  randColor(color C1, color C2){ super(0);c1=C1; c2 = C2;}
  color get(traceable o,vec n,ray r, double t, double u, double v){
    return color(random(red(c1),red(c2)),random(green(c1),green(c2)),random(blue(c1),blue(c2)),random(alpha(c1),alpha(c2)));
  }
}

class fog extends Color{
  scene S;
  Color c;
  double d;
  fog(Color C, double density, scene s){
    super(0);
    c = C;
    S = s;
    d = density;
  }
  fog(color C,double density,scene s){
    super(0);
    c = new Color(C);
    S = s;
    d = density;
  }
  
  color get(traceable o,vec n,ray r, double t, double u, double v){
    color cl = c.get(o,n,r,t,u,v);
    double dens = d*alpha(cl)/255.;
    
    ray transp = new ray(r.get(t), r.dir,0).travel(0.00001);
    
    intersection ri = S.trace(transp);
    if (!ri.intersects){ return cl;}
    double a = 1-exp((float)(-ri.t*dens));
    transp.intensity = r.intensity*(1-a);
    ri = S.trace(transp);
    int res = ri.c;
    return color((int)(red(cl)*a+red(res)*(1-a)),(int)(green(cl)*a+green(res)*(1-a)),(int)(blue(cl)*a+blue(res)*(1-a)));

    
  }
}

class holoColor extends Color{
  scene S;
  Color c;
  holoColor(Color C,scene s){
    super(0);
    c = C;
    S = s;
  }
  holoColor(color C,scene s){
    super(0);
    c = new Color(C);
    S = s;
  }
  
  color get(traceable o,vec n,ray r, double t, double u, double v){
    // newr = r-2(r•n)n
    color cl = c.get(o,n,r,t,u,v);
    double a = alpha(cl)/255.;
    if (r.intensity * (1-a) < THRESH)
      return cl;
    
    ray hol = new ray(r.pos, r.dir,r.intensity*(1-a));
    
    int res = S.trace(hol).c;
      
    return color((int)(red(cl)*a+red(res)*(1-a)),(int)(green(cl)*a+green(res)*(1-a)),(int)(blue(cl)*a+blue(res)*(1-a)));
  }
}





class C_SetAlpha extends Color{
  int a;
  Color c;
  C_SetAlpha(Color C,int A){
    super(0);
    a = A;
    c = C;
  }
  color get(traceable o,vec n,ray r, double t, double u, double v){
    color cl = c.get(o,n,new ray(r.pos,r.dir,r.intensity*a/255.),t,u,v);
    return color(red(cl),green(cl),blue(cl),a);
  }
  
  
}
class C_NormAlpha extends Color{
  double a;
  double b;
  Color c;
  C_NormAlpha(Color C,double A, double B){
    super(0);
    a = A;
    c = C;
    b = B;
  }
  color get(traceable o,vec n,ray r, double t, double u, double v){
    double d = Math.abs(r.dir.normalize().dot(n.normalize()));
    color cl = c.get(o,n,new ray(r.pos,r.dir,r.intensity*(a*d+b)/255.),t,u,v);
    
    return color(red(cl),green(cl),blue(cl),(int)(a*d+b));
  }
  
  
}



class Texture extends Color{
  PImage tx;
  Texture(PImage t){ super(0);tx = t;}
  color get(traceable o,vec n,ray r, double t, double u, double v){
  return tx.get((int)(u*tx.width),(int)(v*tx.height));
  }
}


double THRESH = 1./255;
class transparentColor extends Color{
  scene S;
  Color c;
  transparentColor(Color C,scene s){
    super(0);
    c = C;
    S = s;
  }
  transparentColor(color C,scene s){
    super(0);
    c = new Color(C);
    S = s;
  }
  
  color get(traceable o,vec n,ray r, double t, double u, double v){
    // newr = r-2(r•n)n
    color cl = c.get(o,n,r,t,u,v);
    double a = alpha(cl)/255.;
    if (r.intensity * (1-a) < THRESH)
      return cl;
    
    ray transp = new ray(r.get(t), r.dir,r.intensity*(1-a)).travel(0.00000001);
    
    int res = S.trace(transp).c;
      
    return color((int)(red(cl)*a+red(res)*(1-a)),(int)(green(cl)*a+green(res)*(1-a)),(int)(blue(cl)*a+blue(res)*(1-a)));
  }
}

class RefractColor extends Color{
  scene S;
  Color c;
  double refact;
  RefractColor(Color C,scene s,double ref){
    super(0);
    c = C;
    S = s;
    refact = ref;
  }
  RefractColor(color C,scene s,double ref){
    super(0);
    c = new Color(C);
    S = s;
    refact = ref;
  }
  
  color get(traceable o,vec n,ray r, double t, double u, double v){
    // newr = r-2(r•n)n
    color cl = c.get(o,n,r,t,u,v);
    double a = alpha(cl)/255.;
    if (r.intensity * (1-a) < THRESH)
      return cl;
    
    ray transp = new ray(r.get(t), r.dir.add(n.scale(refact*r.dir.dot(n)/n.mag2())),r.intensity*(1-a)).travel(0.00000001);
    
    int res = S.trace(transp).c;
      
    return color((int)(red(cl)*a+red(res)*(1-a)),(int)(green(cl)*a+green(res)*(1-a)),(int)(blue(cl)*a+blue(res)*(1-a)));
  }
}


class reflectiveColor extends Color{
  scene S;
  Color c;
  reflectiveColor(Color C,scene s){
    super(0);
    c = C;
    S = s;
  }
  reflectiveColor(color C,scene s){
    super(0);
    c = new Color(C);
    S = s;
  }
  
  color get(traceable o,vec n,ray r, double t, double u, double v){
    // newr = r-2(r•n)n
    color cl = c.get(o,n,r,t,u,v);
    double a = alpha(cl)/255.;
    if (r.intensity * (1-a) < THRESH)
      return cl;
    
    ray reflect = new ray(r.get(t), r.dir.add(n.scale(-2*r.dir.dot(n)/n.mag2())),r.intensity*(1-a)).travel(0.00000001);
    
    int res = S.trace(reflect).c;
      
    return color((int)(red(cl)*a+red(res)*(1-a)),(int)(green(cl)*a+green(res)*(1-a)),(int)(blue(cl)*a+blue(res)*(1-a)));
  }
  
  
}
