
class pcolor extends vec{
  pcolor(double... d){
    super(d);
  }
  color toColor(){
    return color((int)(255*x),(int)(255*y),(int)(255*z));
  }
  pcolor(color c){
    super(red(c)/255.,green(c)/255.,blue(c)/255.);
  }
  pcolor mul(pcolor o){
    return new pcolor(x*o.x,y*o.y,z*o.z);
  }
}


abstract class material{
  //abstract pcolor apply(pcolor in);
  abstract pcolor cont(hit h,int i,pcolor p,traceable scene);
}


class m_flat extends material{
  pcolor colr;
  m_flat(pcolor c){
    colr = c;
  }
  pcolor apply(pcolor in){
    return colr;
  }
  pcolor cont(hit h,int i,pcolor p,traceable scene){
    return colr;
  }
}

class m_directional extends material{
  material m,b;
  vec dir;
    m_directional(material M,material D,vec d){
      m = M;
      b = D;
      dir = d;
    }
  pcolor cont(hit h,int i,pcolor p,traceable scene){
    double r = randomGaussian();
    r *= r;
    if (-h.r.dir.dot(dir) > r){
    return m.cont(h,i,p,scene);
    }else{
      return b.cont(h,i,p,scene);
    }
  }
}

class m_lit extends material{
  pcolor colr;
  double scatter;
  m_lit(pcolor c,double s){
    colr = c;scatter = s;
  }
  pcolor cont(hit h,int i,pcolor p,traceable scene){
    ray n = h.r.travel(h.d);
    n.dir.normEq().scaleEq(1-scatter).addEq(n.dir.random().normEq().scaleEq(scatter));
    if (n.dir.dot(h.n)<0){
      n.dir.nReflectEq(h.n);
    }
    return (pcolor)colr.mul(scene.traceScene(p,n.travel(0.001),scene,i));
  }
}
class m_transp extends material{
  pcolor colr;
  double scatter,ior;
  m_transp(pcolor c,double s,double i){
    colr = c;scatter = s;ior = i;
  }
  pcolor cont(hit h,int i,pcolor p,traceable scene){
    ray n = h.r.travel(h.d);
    n.dir.normEq().scaleEq(1-scatter).addEq(n.dir.random().normEq().scaleEq(scatter));
    if (n.dir.dot(h.n)<0){
      n.dir.addEq(n.dir.project(h.n).scale(ior-1));
    }
    else
    {
      n.dir.addEq(n.dir.project(h.n).scale(1./ior-1));
    }
    return (pcolor)colr.mul(scene.traceScene(p,n.travel(0.001),scene,i));
  }
}

class m_checkerboard extends material{
  material a,b;
  m_checkerboard(material A,material B){a=A;b=B;}
  pcolor cont(hit h,int i,pcolor p,traceable scene){
    if (((((int)Math.floor(h.uvw.x))^((int)Math.floor(h.uvw.y))^((int)Math.floor(h.uvw.z)))&1) == 0){
      return a.cont(h,i,p,scene);
    }else{
      return b.cont(h,i,p,scene);
    }
  }
}
  
