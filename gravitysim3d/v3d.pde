class vec{
  double x,y,z;
  vec(double X, double Y, double Z){
    x=X;y=Y;z=Z;
  }
  vec(double X, double Y){
    x=X;y=Y;z=0;
  }
  vec(double X){
    x=X;y=0;z=0;
  }
  vec(){
    x=0;y=0;z=0;
  }
  vec(double... d){
    if (d.length>0){
      x=d[0];
      if (d.length>1){
        y=d[1];
        if (d.length>2){
          z=d[2];
    }}}
  }
  vec set(vec o){
    x=o.x;y=o.y;z=o.z;
    return this;
  }
  vec set(double ox,double oy,double oz){
    x=ox;y=oy;z=oz;
    return this;
  }
  vec copy(){
     return new vec(x,y,z); 
  }
  vec add(vec o){
    return new vec(x+o.x,y+o.y,z+o.z);
  }
  vec add(double ox,double oy,double oz){
    return new vec(x+ox,y+oy,z+oz);
  }
  vec addEq(vec o){
    x+=o.x;y+=o.y;z+=o.z;
    return this;
  }
  vec addEq(double ox,double oy,double oz){
    x+=ox;y+=oy;z+=oz;
    return this;
  }
  vec sub(vec o){
    return new vec(x-o.x,y-o.y,z-o.z);
  }
  vec sub(double ox,double oy,double oz){
    return new vec(x-ox,y-oy,z-oz);
  }
  vec subEq(vec o){
    x-=o.x;y-=o.y;z-=o.z;
    return this;
  }
  vec subEq(double ox,double oy,double oz){
    x-=ox;y-=oy;z-=oz;
    return this;
  }
  vec scale(double s){
    return new vec(x*s,y*s,z*s);
  }
  vec scaleEq(double s){
    x*=s;y*=s;z*=s;
    return this;
  }
  vec div(double s){
    return new vec(x/s,y/s,z/s);
  }
  vec divEq(double s){
    x/=s;y/=s;z/=s;
    return this;
  }
  double mag2(){
    return x*x+y*y+z*z;
  }
  double mag(){
    return Math.sqrt(mag2());
  }
  vec norm(){
    return div(mag());
  }
  vec normEq(){
    return divEq(mag());
  }
  vec neg(){
    return new vec(-x,-y,-z);
  }
  vec negEq(){
    x=-x;y=-y;z=-z;
    return this;
  }
  double dot(vec o){
    return x*o.x+y*o.y+z*o.z;
  }
  double dot(double ox,double oy,double oz){
    return x*ox+y*oy+z*oz;
  }
  vec cross(vec o){
    return new vec(y*o.z-z*o.y,z*o.x-x*o.z,x*o.y-y*o.x);
  }
  vec cross(double ox,double oy,double oz){
    return new vec(y*oz-z*oy,z*ox-x*oz,x*oy-y*ox);
  }
  vec crossEq(vec o){
    return set(y*o.z-z*o.y,z*o.x-x*o.z,x*o.y-y*o.x);
  }
  vec crossEq(double ox,double oy,double oz){
    return set(y*oz-z*oy,z*ox-x*oz,x*oy-y*ox);
  }
  vec projectNormed(vec o){
    return o.scale(dot(o));
  }
  vec project(vec o){
    return o.scale(dot(o)/o.mag2());
  }
  vec projectNormed(double ox,double oy,double oz){
    return new vec(ox,oy,oz).scale(dot(ox,oy,oz));
  }
  vec project(double ox,double oy,double oz){
    return project(new vec(ox,oy,oz));
  }
  vec projectNormedEq(vec o){
    return set(o.scale(dot(o)));
  }
  vec projectEq(vec o){
    return set(o.scale(dot(o)/o.mag2()));
  }
  vec projectNormedEq(double ox,double oy,double oz){
    return set(new vec(ox,oy,oz).scale(dot(ox,oy,oz)));
  }
  vec projectEq(double ox,double oy,double oz){
    return projectEq(new vec(ox,oy,oz));
  }
  vec perp(vec o){
    return sub(project(o));
  }
  vec perp(double ox,double oy,double oz){
    return sub(project(ox,oy,oz));
  }
  vec perpEq(vec o){
    return subEq(project(o));
  }
  vec perpEq(double ox,double oy,double oz){
    return subEq(project(ox,oy,oz));
  }
  vec reflect(vec o){
    return sub(perp(o).scaleEq(2));
  }
  vec reflect(double ox,double oy,double oz){
    return sub(perp(ox,oy,oz).scaleEq(2));
  }
  vec reflectEq(vec o){
    return subEq(perp(o).scaleEq(2));
  }
  vec reflectEq(double ox,double oy,double oz){
    return subEq(perp(ox,oy,oz).scaleEq(2));
  }
  vec nReflect(vec o){
    return sub(project(o).scaleEq(2));
  }
  vec nReflect(double ox,double oy,double oz){
    return sub(project(ox,oy,oz).scaleEq(2));
  }
  vec nReflectEq(vec o){
    return subEq(project(o).scaleEq(2));
  }
  vec nReflectEq(double ox,double oy,double oz){
    return subEq(project(ox,oy,oz).scaleEq(2));
  }
  vec reflect(vec oa,vec ob){
    return nReflect(oa.cross(ob));
  }
  vec reflect(double oax,double oay,double oaz,double obx,double oby,double obz){
    return nReflect(new vec(oax,oay,oaz).crossEq(obx,oby,obz));
  }
  vec reflectEq(vec oa,vec ob){
    return nReflectEq(oa.cross(ob));
  }
  vec reflectEq(double oax,double oay,double oaz,double obx,double oby,double obz){
    return nReflectEq(new vec(oax,oay,oaz).crossEq(obx,oby,obz));
  }
  void translate_(){
    translate((float)x,(float)y,(float)z);
  }
}
