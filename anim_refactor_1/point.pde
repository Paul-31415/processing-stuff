    double sq(double n){
      return n*n;
    }
    
class Point implements drawableVector,selectable{
  
  long uid = ++UNIQUE_ID;
  
  public double x,y,z,w;
  
  String toString(){
    return "Point("+x+","+ y+","+ z+","+ w+")";
  }
  Point New(){return new Point();}

  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      //ref
      return "@"+namespace.getKey(this);
    }else{
      //new
      String k = "Point_"+ uid;
      String v = "\"x\":\""+x+
                 "\",\"y\":\""+y+
                 "\",\"z\":\""+z+
                 "\",\"w\":\""+w+"\"";
      namespace.put(k,this);
      return "\""+k+"\"=\"Point\"("+v+")";
      
    }
    
  }
  void setParameter(String param,Object o){


      if (o instanceof dString){
        double v = Double.parseDouble(((SaveableString)(((dString)o).obj)).contents);
        switch (param){
          case "x":
            x = v;
            break;
          case "y":
            y = v;
            break;
          case "z":
            z = v;
            break;
          case "w":
            w = v;
            break;
          default:
            println("error: tried to set param "+param+" of Point"); 
            assert(1==0);
        }
      }
    
  }
  
  
  Point(){
    x=0;y=0;z=0;w=1;
  }
  
  float x(){
    return (float)(x/w);
  }
  float y(){
    return (float)(y/w);
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
  
  Iterable<selectable> selectableChildren(){
    return (Iterable<selectable>) new ArrayList<selectable>();
  }
  double selectDistance(Point p){
    //euclidiean distance

     return sq(x/w-p.x/p.w)+sq(y/w-p.y/p.w)+sq(z/w-p.z/p.w);
    
  }
  double selectDistance(transform t,double x, double y){
    return t.apply(this).selectDistance(new Point(x,y));
  }
  void drawSelect(transform t,PGraphics g){
    noStroke();
    fill(color(255,255,0),64);
    Point pt = t.apply(this);
    g.ellipse(pt.x(),pt.y(),3,3);
  }
  
  
  
  
  
    
    
  //for vector stuff
  vector times(double o){return new Point(x*o,y*o,z*o,w);}
  vector timesEq(double o){x *= o; y*=o; z*=o; return this;}
  vector times(vector O){Point o = (Point)O;return new Point(x*o.x,y*o.y,z*o.z,w*o.w);}
  vector timesEq(vector O){Point o = (Point)O;x *= o.x; y*= o.y;z*=o.z;w*=o.w; return this;}
  
  vector plus(vector O){Point o = (Point)O;return new Point(x*o.w+o.x*w,y*o.w+o.y*w,z*o.w+o.z*w,w*o.w);}
  vector plusEq(vector O){Point o = (Point)O;x=x*o.w+o.x*w;y=y*o.w+o.y*w;z=z*o.w+o.z*w;w*=o.w;return this;}
    
  Point negative(){return new Point(-x,-y,-z,w);}
  
  vector zero(){ return new Point();}
  //for matrix stuff
  Point mtimes(double o){return new Point(x*o,y*o,z*o,w*o);}
  Point mtimesEq(double o){x *= o; y*=o; z*=o; w*=o; return this;}
  Point mtimes(Point o){return new Point(x*o.x,y*o.y,z*o.z,w*o.w);}
  Point mtimesEq(Point o){x *= o.x; y*= o.y;z*=o.z;w*=o.w; return this;}
  
  Point mplus(Point o){return new Point(x+o.x,y+o.y,z+o.z,w+o.w);}
  Point mplusEq(Point o){x+=o.x;y+=o.y;z+=o.z;w+=o.w;return this;}
    
  Point mnegative(){return new Point(-x,-y,-z,-w);}
}
