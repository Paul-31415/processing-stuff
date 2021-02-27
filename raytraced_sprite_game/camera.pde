abstract class camera{
  abstract ray get(double x,double y);
  abstract PMatrix3D getMtrx();
}


class cam_persp extends camera{
  vec pos;
  angle dir;
  double depth;
  cam_persp(vec p,angle d,double de){ pos = p;dir = d; depth = de;}
  ray get(double x,double y){
    return new ray(pos,dir.apply(new vec(x,y,depth)));
  }
  PMatrix3D getMtrx(){
    PMatrix3D p = new PMatrix3D(1,0,0,0,
                                0,1,0,0,
                                0,0,1,0,
                                (float)-pos.x,(float)-pos.y,(float)-pos.z,1);
                                
    p.apply(dir.inverse().toMatrix());
    p.scale(1,1,(float)depth);
    return p;
  }
}

  
