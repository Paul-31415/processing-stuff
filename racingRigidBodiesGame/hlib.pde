class hvec{
  double x,y,z,w;
  // represents point x/w,y/w,z/w
  hvec(double ... c ){
    x = c.length>0?c[0]:0;
    y = c.length>1?c[1]:0;
    z = c.length>2?c[2]:0;
    w = c.length>3?c[3]:1;
  }
  hvec dup(){
    return new hvec(x,y,z,w);
  }
  hvec set(hvec o){
    x = o.x; y = o.y; z = o.z; w = o.w; return this;
  }
  hvec plus4(hvec ...  os){
    return dup().plus4Eq(os);
  }
  hvec plus4Eq(hvec ... os){
    for (hvec o : os){
      x += o.x;
      y += o.y;
      z += o.z;
      w += o.w;
    }
    return this;
  }
  hvec minus4(hvec ...os){
    return dup().minus4Eq(os);
  }
  hvec minus4Eq(hvec ...os){
    for (hvec o : os){
      x -= o.x;
      y -= o.y;
      z -= o.z;
      w -= o.w;
    }
    return this;
  }
  hvec plus(hvec ... os){
    return dup().plusEq(os);
  }
  hvec plusEq(hvec ... os){
    for (hvec o : os){
      double f = w/o.w;
      x += o.x*f;
      y += o.y*f;
      z += o.z*f;
    }
    return this;
  }
  hvec minus(hvec ... os){
    return dup().minusEq(os);
  }
  hvec minusEq(hvec ... os){
    for (hvec o : os){
      double f = w/o.w;
      x -= o.x*f;
      y -= o.y*f;
      z -= o.z*f;
    }
    return this;
  }
  hvec neg(){
    return new hvec(-x,-y,-z,w);
  }
  hvec neg4(){
    return new hvec(-x,-y,-z,-w);
  }
  hvec negEq(){
    x = -x; y = -y; z = -z; return this;
  }
  hvec neg4Eq(){
    x = -x; y = -y; z = -z; w = -w; return this;
  } 
  double X(){return x/w;}
  double Y(){return y/w;}
  double Z(){return z/w;}
  double dot2(hvec o){
    return (x*o.x+y*o.y)/w/o.w;
  }
  double dot3(hvec o){
    return (x*o.x+y*o.y+z*o.z)/w/o.w;
  }
  double dot4(hvec o){
    return x*o.x+y*o.y+z*o.z+w*o.w;
  }
  double dot3_oW(hvec o){
    return (x*o.x+y*o.y+z*o.z)/o.w;
  }
  double dot3_noW(hvec o){
    return x*o.x+y*o.y+z*o.z;
  }
  
  hvec cross3(hvec o){
    return new hvec(y*o.z-z*o.y,z*o.x-x*o.z,x*o.y-y*o.x,w*o.w);
  }
  
  hvec scale(double s){return dup().scaleEq(s);}
  hvec scaleEq(double s){
    x *= s; y *= s; z *= s;return this;
  }
  hvec scale4(double s){return dup().scale4Eq(s);}
  hvec scale4Eq(double s){
    x *= s; y *= s; z *= s; w *= s;return this;
  }
  hvec scalew(double s){return dup().scalewEq(s);}
  hvec scalewEq(double s){
    w /= s;return this;
  }
  
  hvec normw(){return dup().normwEq();}
  hvec normwEq(){
    w = Math.sqrt(x*x+y*y+z*z);return this;
  }
  hvec norm(){return dup().normEq();}
  hvec normEq(){return scale(1/mag3());}
  hvec norm_noW(){return dup().normEq_noW();}
  hvec normEq_noW(){return scale(1/mag3_noW());}
  hvec norm4(){return dup().norm4Eq();}
  hvec norm4Eq(){return scale4(1/mag4());}
  
  double mag3_sq(){return (x*x+y*y+z*z)/w/w;}
  double mag3_sq_noW(){return (x*x+y*y+z*z);}
  double mag4_sq(){return (x*x+y*y+z*z+w*w);}
  double mag3(){return Math.sqrt(mag3_sq());}
  double mag3_noW(){return Math.sqrt(mag3_sq_noW());}
  double mag4(){return Math.sqrt(mag4_sq());}
  
  //is also a plane
  //
  double side_dist(hvec o){
    return dot3_oW(o)-w;
  }
  boolean side(hvec o){
    return side_dist(o) <= 0;
  }
  
}

class line{
  double x,y,z;
}
