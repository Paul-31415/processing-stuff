class vec{
  public double x;
  public double y;
  public double z;
  vec(){
    x = 0; y= 0; z = 0;
  }
  vec(double X, double Y, double Z){
    x = X; y= Y; z = Z;
  }
  vec copy(){ return new vec(x,y,z);}
  
  double dot(vec o){ return x*o.x+y*o.y+z*o.z;}
  double mag2(){ return x*x+y*y+z*z;}
  double mag(){return Math.sqrt(mag());}
  
  vec cross(vec o){ return new vec(y*o.z-z*o.y,x*o.z-z*o.x,x*o.y-y*o.x);}
  vec crossEq(vec o){
    double tmpx = x;
    double tmpy = y;
    x = y*o.z-z*o.y;
    y = tmpx*o.z-z*o.x;
    z = tmpx*o.y-tmpy*o.x;
    return this;
  }
  vec negative(){return new vec(-x,-y,-z);}
  vec negativeEq(){x=-x;y=-y;z=-z; return this;}
  
  
  vec times(double o){return new vec(x*o,y*o,z*o);}
  vec timesEq(double o){x *= o; y*=o; z*=o; return this;}
  vec times(vec o){return new vec(x*o.x,y*o.y,z*o.z);}
  vec timesEq(vec o){x *= o.x; y*= o.y;z*=o.z; return this;}
  
  vec over(double o){return new vec(x/o,y/o,z/o);}
  vec overEq(double o){x/=o;y/=o;z/=o; return this;}
  vec over(vec o){return new vec(x/o.x,y/o.y,z/o.z);}
  vec overEq(vec o){x/=o.x;y/=o.y;z/=o.z;return this;}
  
  vec plus(vec o){return new vec(x+o.x,y+o.y,z+o.z);}
  vec plusEq(vec o){x+=o.x;y+=o.y;z+=o.z;return this;}
}
class Point{
  public double x,y,z,w;
  String toString(){
    return "Point("+x+","+ y+","+ z+","+ w+")";
  }
  Point(){
    x=0;y=0;z=0;w=1;
  }
  Point(double X,double Y){
    x=X;y=Y;z=0;w=1;}
  Point(double X,double Y,double Z){
    x=X;y=Y;z=Z;w=1;}
  Point(double X,double Y,double Z,double W){
    x=X;y=Y;z=Z;w=W;}
  Point copy(){
    return new Point(x,y,z,w);}
  float displayX(){
    return (float)(x/w);}
  float displayY(){
    return (float)(y/w);}
  Point normalized(){
    return new Point(x/w,y/w,z/w);
  }
  Point normalizedEq(){
    x/=w;y/=w;z/=w;w=1;
    return this;
  }
  
    
    
  //for matrix stuff
  Point times(double o){return new Point(x*o,y*o,z*o,w*o);}
  Point timesEq(double o){x *= o; y*=o; z*=o; w*=o; return this;}
  Point times(Point o){return new Point(x*o.x,y*o.y,z*o.z,w*o.w);}
  Point timesEq(Point o){x *= o.x; y*= o.y;z*=o.z;w*=o.w; return this;}
  
  Point plus(Point o){return new Point(x+o.x,y+o.y,z+o.z,w+o.w);}
  Point plusEq(Point o){x+=o.x;y+=o.y;z+=o.z;w+=o.w;return this;}
    
  Point negative(){return new Point(-x,-y,-z,w);}
    
}
class transform{
    Point x,y,z,w;
    transform inverseCache;
    boolean cacheValid;
    transform(){
      x = new Point(1,0,0,0);
      y = new Point(0,1,0,0);
      z = new Point(0,0,1,0);
      w = new Point(0,0,0,1);
      cacheValid = false;
    }
    
    String toString(){
      return "transform["+x.x+",\t"+y.x+",\t"+z.x+",\t"+w.x+"\t]\n" +
             "         ["+x.y+",\t"+y.y+",\t"+z.y+",\t"+w.y+"\t]\n" +
             "         ["+x.z+",\t"+y.z+",\t"+z.z+",\t"+w.z+"\t]\n" +
             "         ["+x.w+",\t"+y.w+",\t"+z.w+",\t"+w.w+"\t]\n";
      
    }
    transform(Point X,Point Y,Point Z,Point W){
      x = X;y = Y;z = Z;w = W;}
    Point apply(Point p){
      return x.times(p.x)
      .plusEq( y.times(p.y) )
      .plusEq( z.times(p.z) )
      .plusEq( w.times(p.w) ); 
    }
    transform(Q q){
      transform t1 = new transform(
      new Point(q.r,-q.v.z,q.v.y,-q.v.x),
      new Point(q.v.z,q.r,-q.v.x,-q.v.y),
      new Point(-q.v.y,q.v.x,q.r,-q.v.z),
      new Point(q.v.x,q.v.y,q.v.z,q.r));
      
      x = new Point(q.r,-q.v.z,q.v.y,q.v.x);
      y = new Point(q.v.z,q.r,-q.v.x,q.v.y);
      z = new Point(-q.v.y,q.v.x,q.r,q.v.z);
      w = new Point(-q.v.x,-q.v.y,-q.v.z,q.r);
       
      this.semitEq(t1);
    }
    transform copy(){return new transform(x.copy(),y.copy(),z.copy(),w.copy());}
    
    transform times(transform o){
      return new transform(apply(o.x),apply(o.y),apply(o.z),apply(o.w));}
    transform timesEq(transform o){
      cacheValid = false;
      Point tmpx = apply(o.x);
      Point tmpy = apply(o.y);
      Point tmpz = apply(o.z);
     this.w = apply(o.w);
     this.z = tmpz;
     this.y = tmpy;
     this.x = tmpx;
     return this;}
    transform semit(transform o){
      return o.times(this);}
    transform semitEq(transform o){
      x = o.apply(this.x);
      y = o.apply(this.y);
      z = o.apply(this.z);
      w = o.apply(this.w);
    return this;}
    
    transform transpose(){
       return new transform(
       new Point(x.x,y.x,z.x,w.x),
       new Point(x.y,y.y,z.y,w.y),
       new Point(x.z,y.z,z.z,w.z),
       new Point(x.w,y.w,z.w,w.w));      
    }
    transform inverse(){
      if (!cacheValid){
      //output undefined for noninvertible transformations
      double[][] work = new double[][] {
        new double[] {x.x,y.x,z.x,w.x,1,0,0,0},
        new double[] {x.y,y.y,z.y,w.y,0,1,0,0},
        new double[] {x.z,y.z,z.z,w.z,0,0,1,0},
        new double[] {x.w,y.w,z.w,w.w,0,0,0,1}};
        
      for(int col = 0;col < 4; col++){
         
         int maxRow = col;
         for(int row = col+1;row < 4; row++){
           if (Math.abs(work[row][col]) > Math.abs(work[maxRow][col]))
             maxRow = row;
         }
         //swap row with maxRow
         double[] tmp = work[col];
         work[col] = work[maxRow];
         work[maxRow] = tmp;
         //normalize row
         for (int i = 7; i >=col; i--){
           work[col][i] /= work[col][col];
           
         }
         
         //zero other entries
         for(int row = 0; row < 4; row++){
           if(row != col){
             //println(">"+row+","+col+":"+work[row][col]);
             for (int i = 7; col <= i ; i--){
               //println("D"+row+","+i+":"+work[row][i]);
               //println("S"+col+","+i+":"+work[col][i]);
               work[row][i] -= work[col][i]*work[row][col];
               //println("d"+row+","+i+":"+work[row][i]);
             }
             
           }
         }
         
         /*for (double[] dd : work){
           for (double d : dd){
             print(d+"\t");
           }
           print('\n');
         }
         print('\n');*/
      }
      //rref complete
      inverseCache = new transform(
      new Point(work[0][4],work[1][4],work[2][4],work[3][4]),
      new Point(work[0][5],work[1][5],work[2][5],work[3][5]),
      new Point(work[0][6],work[1][6],work[2][6],work[3][6]),
      new Point(work[0][7],work[1][7],work[2][7],work[3][7]));
      cacheValid = true;
      }
      return inverseCache.copy();
    }
    
    vnd apply(vector v){
      Point p = apply(((vnd)v).toPoint()); 
      return ((vnd)v).mask(new vnd(p.x,p.y,p.z,p.w));
    }
    
    
  
}
interface vector{
  abstract vector plus(vector o);
  abstract vector plusEq(vector o);
  
  abstract vector times(vector o);
  abstract vector timesEq(vector o);
  abstract vector times(double o);
  abstract vector timesEq(double o);
  
  abstract vector zero();
}

class vnd implements vector{//n dimensional vectors
  double[] p;
  vnd(double... d){ p = d;}
  
  int dim(){ return p.length;}
  double get(int i){
    if (i>=p.length){
      return 0;
    }
    return p[i];
  }
  
  
  double dot(vnd o){
    double tot = 0;
    for(int i = 0; i < min(o.dim(),dim());i++){
      tot += o.p[i]*p[i];
    }
    return tot;
  }
  
  vnd plus(vector O){
    vnd o = (vnd) O;
    double[] res = new double[max(o.dim(),dim())];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.p[i]+p[i];
    }
    double[] l = (o.dim()>dim())? o.p:p;
    for(int i = min(o.dim(),dim()); i < res.length ;i++){
      res[i] = l[i];
    }
    return new vnd(res);
  }
  vnd plusEq(vector O){
    vnd o = (vnd) O;
    if (o.dim()<=dim()){
      for(int i = 0; i < o.dim();i++){
        p[i] += o.p[i];
      }
    }else{
      
    double[] res = new double[o.dim()];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.p[i]+p[i];
    }
    for(int i = min(o.dim(),dim()); i < res.length ;i++){
      res[i] = o.p[i];
    }
    p = res;
    }
    return this;
  }
  
  
  vnd times(double o){
    double[] res = new double[dim()];
    for(int i = 0; i < dim();i++){
      res[i] = o*p[i];
    }
    return new vnd(res);
  }
  vnd timesEq(double o){
    for(int i = 0; i < dim();i++){
      p[i] *= o;
    }
    return this;
  }
  
  vnd times(vector O){
    vnd o = (vnd) O;
    double[] res = new double[min(o.dim(),dim())];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.p[i]*p[i];
    }
    return new vnd(res);
  }
  vnd timesEq(vector O){
    vnd o = (vnd) O;
    if(o.dim()>dim()){
      for(int i = 0; i < dim();i++){
        p[i] *= o.p[i];
      }
    }else{
      double[] res = new double[o.dim()];
      for(int i = 0; i < res.length;i++){
        res[i] = o.p[i]*p[i];
      }
      p = res;
    }
    return this;
  }
  
  vnd times1Extend(vnd o){
    double[] res = new double[max(o.dim(),dim())];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.p[i]*p[i];
    }
    double[] l = (o.dim()>dim())? o.p:p;
    for(int i = min(o.dim(),dim()); i < res.length ;i++){
      res[i] = l[i];
    }
    return new vnd(res);
  }
  vnd times1ExtendEq(vnd o){
    if (o.dim()>dim()){
      double[] res = new double[o.dim()];
      for(int i = 0; i < dim();i++){
        res[i] = o.p[i]*p[i];
      }
      for(int i = dim(); i < res.length ;i++){
        res[i] = o.p[i];
      }
      p = res;
    }else{
      for(int i = 0; i < o.dim();i++){
        p[i] *= o.p[i];
      }
    }
    return this;
  }
  
  vnd mask(vnd o){
    double[] res = new double[max(o.dim(),dim())];
    for(int i = 0; i < o.dim(); i++){
      res[i] = o.p[i];
    }
    for(int i = o.dim(); i < dim(); i++){
      res[i] = p[i];
    }
    return new vnd(res);
  }
  vnd maskEq(vnd o){
    if(o.dim()>dim()){
      double[] res = new double[o.dim()];
      for(int i = 0; i < o.dim(); i++){
         res[i] = o.p[i];
      }
      p = res;
    }else{
      for(int i = 0; i < o.dim(); i++){
         p[i] = o.p[i];
      }
    }
    return this;
  }
  
    
  
  Point toPoint(){
    if( dim() < 4){
      return new vnd(0,0,0,1).plusEq(this).toPoint();
    }else{
      return new Point(p[0],p[1],p[2],p[3]);
    }
  }
  vnd zero(){
    return new vnd();
  }
}

class vv implements vector{ //vector of vectors
  vector[] v;
  vv(vector... d){ v = d;}
  
  int dim(){ return v.length;}
  
  vv plus(vector O){
    vv o = (vv) O;
    vector[] res = new vector[max(o.dim(),dim())];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.v[i].plus(v[i]);
    }
    vector[] l = (o.dim()>dim())? o.v:v;
    for(int i = min(o.dim(),dim()); i < res.length ;i++){
      res[i] = l[i];
    }
    return new vv(res);
  }
  vv plusEq(vector O){
    vv o = (vv) O;
    if (o.dim()<=dim()){
      for(int i = 0; i < o.dim();i++){
        v[i].plusEq(o.v[i]);
      }
    }else{
      
    vector[] res = new vector[o.dim()];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.v[i].plus(v[i]);
    }
    for(int i = min(o.dim(),dim()); i < res.length ;i++){
      res[i] = o.v[i];
    }
    v = res;
    }
    return this;
  }
  
  
  vv times(double o){
    vector[] res = new vector[dim()];
    for(int i = 0; i < dim();i++){
      res[i] = v[i].times(o);
    }
    return new vv(res);
  }
  vv timesEq(double o){
    for(int i = 0; i < dim();i++){
      v[i].timesEq(o);
    }
    return this;
  }
  
  vv times(vector O){
    vv o = (vv) O;
    vector[] res = new vector[min(o.dim(),dim())];
    for(int i = 0; i < min(o.dim(),dim());i++){
      res[i] = o.v[i].times(v[i]);
    }
    return new vv(res);
  }
  vv timesEq(vector O){
    vv o = (vv) O;
    if(o.dim()>dim()){
      for(int i = 0; i < dim();i++){
        v[i].timesEq(o.v[i]);
      }
    }else{
      vector[] res = new vector[o.dim()];
      for(int i = 0; i < res.length;i++){
        res[i] = o.v[i].times(v[i]);
      }
      v = res;
    }
    return this;
  }
  
  vv zero(){
    return new vv();
  }
}


class Bezier{ //arbitrary order, arbitrary dimension
  ArrayList<vector> points;
  Bezier(vector... p){
    points = new ArrayList<vector>();
    for(vector v:p){
      points.add(v);
    }
  }
  double binomial(int n, int k){ 
     // = n!/(k!*(n-k)!)
     double res = 1;
     k = (k > n/2)?n-k:k;
     for(int i = 1; i <=k; i++){
       res = (res * (n+1-i))/i;
     }
     return res;
  }
  vector get(double t){
    // b(t,K (control point index) ,v)=bin(N,K)*(1-t)^(N-K) * t^K * v
    vector res = points.get(0).zero();
    double bin = 1;
    for(int i = 0; i < points.size(); i++){
      res.plusEq(points.get(i).times(bin*
      Math.pow((1-t),points.size()-1-i)*
      Math.pow(t,i)));
      bin *= ((double)points.size()-(i+1))/(i+1);
    }
    return res;
  }
}







interface Path{
 double start();
 double end();
 double length();
 vnd get(double t);
}
class BezierPath implements Path,orientable{
   ArrayList<Bezier> path;
   transform orientation;
   BezierPath(){
     path = new ArrayList<Bezier>();
     orientation = new transform();
   }
   BezierPath(Bezier... bs){
     path = new ArrayList<Bezier>();
     for (Bezier b:bs){
       path.add(b);
     }
     orientation = new transform();
   }
  transform getOrientation(){return orientation;} 
  void setOrientation(transform t){ orientation=t;}
  void addOrientation(transform t){ orientation.timesEq(t);}
   
   double start(){
     return 0;
   }
   double end(){
     return length();
   }
   
   double length(){
     return path.size();
   }
   
   vnd get(double t){
     int index = (int) t;
     if (0 >= index){
       return orientation.apply(path.get(0).get(t));
     }else{
       if (index >= path.size()-1){
         return orientation.apply(path.get(path.size()-1).get(t-path.size()+1));
       }else{
         return orientation.apply(path.get(index).get(t-index));
       }
     }
   }
   void add(Bezier b){
     path.add(b);
   }
}
