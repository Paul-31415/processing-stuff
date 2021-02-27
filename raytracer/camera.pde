abstract class camera{
  ray look;
  abstract ray getRay(double x, double y);
  abstract void startIteration(int w, int h,double x0, double y0, double xf, double yf);
  abstract ray nextRay();
}

class c_ortho extends camera{
  vec ix;
  vec iy;
  c_ortho(ray pos)
  {
    look = pos;
    
    vec[] basis = getOrthoBasis( look.dir,new vec(1,0,0), new vec(0,1,0), new vec(0,0,1));
    assert basis.length == 3;
    ix = basis[1].scale(look.dir.mag());
    iy = basis[2].scale(look.dir.mag());
  }
  c_ortho(vec pos, vec dir, vec x, vec y){
    look = new ray(pos,dir);
    ix = x.copy();
    iy = y.copy();
  }
  ray getRay(double x, double y){
    return new ray(ix.scale(x).add(iy.scale(y)).add(look.pos),look.dir);
  }
  int iterCount;
  int iterWidth;
  vec scaledIx;
  vec scaledIy;
  vec rowStarter;
  vec current;
  void startIteration(int w, int h,double x0, double y0, double xf, double yf){
    iterWidth = w; scaledIx = ix.scale((xf-x0)/w); scaledIy = iy.scale((yf-y0)/h);
    rowStarter = getRay(x0,y0).pos;
    current = rowStarter.add(scaledIx.neg());
    iterCount = 0;
  }
  ray nextRay(){
    iterCount ++;
    current = current.add(scaledIx);
    if (iterCount > iterWidth){
      rowStarter = rowStarter.add(scaledIy);
      current = rowStarter;
      iterCount = 1;
    }
    return new ray(current,look.dir);
  }
}
class c_persp extends camera{
  vec ix;
  vec iy;
  c_persp(ray pos)
  {
    look = pos;
    
    vec[] basis = getOrthoBasis( look.dir,new vec(1,0,0), new vec(0,1,0), new vec(0,0,1));
    assert basis.length == 3;
    ix = basis[1];
    iy = basis[2];
  }
  c_persp(vec pos, vec dir, vec x, vec y){
    look = new ray(pos,dir);
    ix = x.copy();
    iy = y.copy();
  }
  ray getRay(double x, double y){
    return new ray(look.pos,ix.scale(x).add(iy.scale(y)).add(look.dir));
  }
  int iterCount;
  int iterWidth;
  vec scaledIx;
  vec scaledIy;
  vec rowStarter;
  vec current;
  void startIteration(int w, int h,double x0, double y0, double xf, double yf){
    iterWidth = w; scaledIx = ix.scale((xf-x0)/w); scaledIy = iy.scale((yf-y0)/h);
    rowStarter = getRay(x0,y0).dir;
    current = rowStarter.add(scaledIx.neg());
    iterCount = 0;
  }
  ray nextRay(){
    iterCount ++;
    current = current.add(scaledIx);
    if (iterCount > iterWidth){
      rowStarter = rowStarter.add(scaledIy);
      current = rowStarter;
      iterCount = 1;
    }
    return new ray(look.pos,current);
  }
  
}
