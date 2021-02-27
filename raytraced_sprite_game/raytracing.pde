

class ray{
  vec start,dir;
  ray(vec s,vec d){
    start = s;dir = d;
  }
  ray norm(){
    return new ray(start.copy(),dir.norm());
  }
  ray normEq(){
    dir.normEq();
    return this;
  }
  ray travel(double d){
    return new ray(start.add(dir.scale(d)),dir.copy());
  }
  vec eval(double t){
    return start.add(dir.scale(t));
  }
  ray travelEq(double d){
    start.addEq(dir.scale(d));
    return this;
  }
  vec travelV(double d){
    return start.add(dir.scale(d));
  }
  ray translate(vec v){
    return new ray(start.add(v),dir.copy());
  }
  ray translate(double x, double y, double z){
    return new ray(start.add(x,y,z),dir.copy());
  }
  ray translateEq(vec v){
    start.addEq(v);
    return this;
  }
  ray translateEq(double x, double y, double z){
    start.addEq(x,y,z);
    return this;
  }
  String toString(){
    return "ray("+start+","+dir+")";
  }
}

class hit {
  boolean i;
  double d;
  ray r;
  Object t;
  vec n,uvw;
  int side;
  hit(boolean I,  ray R, Object T,double D,vec UVW,vec N,int Side) {
    i=I;d=D;r=R;t=T;uvw=UVW;n=N;side=Side;
  }
  hit(boolean I,  ray R, Object T,double D) {
    i=I;d=D;r=R;t=T;uvw=new vec();n = uvw;side=0;
  }
  hit(boolean I,  ray R, Object T) {
    i=I;d=0;r=R;t=T;uvw=new vec();n = uvw;side=0;
  }
  double ndist(){
    return d*r.dir.mag();
  }
  String toString(){
    return "hit("+i+","+r+","+t+","+d+","+uvw+","+n+","+side+")";
  }
}

abstract class traceable {
  material mat;
  abstract hit trace(ray r);
  traceable setMaterial(material m){
    mat = m; return this;
  }
  pcolor traceScene(pcolor p,ray r, traceable scene,int i){
    if (i <= 0){
      return p;
    }
    hit h = trace(r);
    if (h.i){
      return ((traceable)h.t).mat.cont(h,i-1,p,scene);
    }else{
      return p;
    }
  }
  void quickDraw(double res){}
}

class naive_scene extends traceable{
  ArrayList<traceable> objs;
  naive_scene(traceable... o){
    objs = new ArrayList<traceable>();
    for (traceable f :o){
      objs.add(f);
    }
  }
  hit trace(ray r){
    hit n = new hit(false,r,this,Double.POSITIVE_INFINITY);
    for (traceable t :objs){
      hit h = t.trace(r);
      if (h.i && h.d < n.d){
        n = h;
      }
    }
    return n;
  }
  void quickDraw(double res){
    for (traceable t :objs){
      t.quickDraw(res);
    }
  }
}

class translation extends traceable{
  traceable graphic;
  vec amnt;
  translation(traceable g,vec m){graphic = g;amnt = m;}
  hit trace(ray r){
    return graphic.trace(r.translate(amnt));
  }
}
class nplane extends traceable{
  vec origin,n;
  nplane(vec o,vec N){
    origin = o;n=N;
  }
  hit trace(ray r){
    
    double distD = r.dir.dot(n);
    if (distD == 0){
      return new hit(false,r,this);
    }
    vec dif = origin.sub(r.start);
    double dist = dif.dot(n)/distD;
    vec uvw = r.travelV(dist).subEq(origin);
    return new hit(dist>=0,r,this,dist,uvw,n,distD>0?1:0);
  }
  String toString(){
    return "nplane("+origin+","+n+")";
  }
  void quickDraw(double res){
    vec perp = n.copy();
    if(Math.abs(perp.x)>Math.abs(perp.y)) {
      if (Math.abs(perp.x)>Math.abs(perp.z)) {
        perp.x = -perp.x;
      }else{
        perp.z = -perp.z;
      }
    }else{
      if (Math.abs(perp.y)>Math.abs(perp.z)){
        perp.y = -perp.y;
      }else{
        perp.z = -perp.z;
      }
    }
  
    perp.crossEq(n).normEq().scaleEq(1e10);
    vec p2 = n.cross(perp).normEq().scaleEq(1e10);
    beginShape();
    origin.add(perp).vert();
    origin.add(p2).vert();
    origin.sub(perp).vert();
    origin.sub(p2).vert();
    endShape();
    beginShape();
    origin.vert();
    origin.add(n).vert();
    endShape();
  }
}


class uvplane extends traceable{
  vec origin,u,v,n;
  uvplane(vec o,vec U, vec V){
    origin = o;u=U;v=V;n=u.cross(v);
  }
  hit trace(ray r){
    double distD = r.dir.dot(n);
    if (distD == 0){
      return new hit(false,r,this);
    }
    vec dif = origin.sub(r.start);
    double dist = dif.dot(n)/distD;
    vec dest = r.travelV(dist).subEq(origin);
    vec uvw = dest.toBasis(u,v,n);
    return new hit(dist>=0,r,this,dist,uvw,n,distD>0?1:0);
  }
  String toString(){
    return "uvplane("+origin+","+u+","+v+")";
  }
  void quickDraw(double res){
    beginShape();
    origin.add(u.scale(1e10)).vert();
    origin.add(v.scale(1e10)).vert();
    origin.sub(u.scale(1e10)).vert();
    origin.sub(v.scale(1e10)).vert();
    endShape();
    beginShape();
    origin.vert();
    origin.add(n).vert();
    endShape();
    beginShape();
    origin.vert();
    origin.add(u).vert();
    endShape();
    beginShape();
    origin.vert();
    origin.add(v).vert();
    endShape();
  }
}

class uvtriangle extends uvplane{
  uvtriangle(vec o,vec U, vec V){
    super(o,U,V);
  }
  hit trace(ray r){
    hit h = super.trace(r);
    if (h.uvw.x < 0 || h.uvw.y < 0 || h.uvw.x+h.uvw.y > 1 ){
      return new hit(false,r,this);
    }
    return h;
  }
}

class uvsphere extends traceable{
  vec origin;
  double r2;
  uvsphere(vec o,double r2){
    this.r2 = r2;
    this.origin = o;
  }
  hit trace(ray r){
    double a = r.dir.mag2();
    double b = 2*r.dir.dot(r.start.sub(this.origin));
    double c = r.start.sub(this.origin).mag2()-this.r2;
    double d = b*b-4*a*c;
    if (d < 0){
      return new hit(false,r,this);
    }
    double sd = Math.sqrt(d);
    double t0 = (-b-sd)/(2*a);
    double t1 = (-b+sd)/(2*a);
    if (t0>0){
      return new hit(true,r,this,t0,new vec(0,0,0),r.eval(t0).subEq(this.origin),1);
    }
    if (t1>0){
      return new hit(true,r,this,t1,new vec(0,0,0),r.eval(t1).subEq(this.origin),0);
    }
    return new hit(false,r,this);
  }
}
