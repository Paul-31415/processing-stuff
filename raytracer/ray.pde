class intersection{
  double t;
  boolean intersects;
  color c;
  intersection(double tval, boolean i, color col){
    t = tval;
    intersects = i;
    c = col;
  }
}

class ray{
  double intensity;
  vec pos;
  vec dir;
  ray(vec p,vec d,double i){
    pos = p.copy();
    dir = d.copy();
    intensity = i;
  }
  ray(vec p,vec d){
    pos = p.copy();
    dir = d.copy();
    intensity = 1;
  }
  vec get(double t){
    return pos.add(dir.scale(t));
  }
  ray travel(double t){
    return new ray(get(t),dir,intensity);
  }
  int getCandidateDimension(){
    for( int i = 0; i < this.dir.v.length; i++){
      if (this.dir.get(i) != 0)
        return i;      
    }
    return 0;
  }
  boolean hasPotentialCloser(double d, vec... vs){
    int dim = this.getCandidateDimension();
    for (vec v: vs){
      double n = (v.get(dim)-this.pos.get(dim))/this.dir.get(dim);
      if(n < d && n > 0)
       return true;
    }
    return false;
  }
}
