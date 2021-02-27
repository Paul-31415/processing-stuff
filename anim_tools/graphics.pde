interface drawable extends saveable{
  abstract void draw(transform t);
  abstract void draw(transform t,PGraphics g);
}

interface orientable{
  public void setOrientation(transform t);
  public void addOrientation(transform t);
  public transform getOrientation();
}

interface generalParamaterizedDrawable extends drawable{
  abstract Object getParam();
  abstract void setParam(Object o);
}
interface paramaterizedDrawable1D extends drawable{
  abstract double getParam();
  abstract void setParam(double o);
}
interface paramaterizedDrawable2D extends drawable{
  abstract double[] getParam();
  abstract void setParam(double o1,double o2);
}

class style{
  color Fill;
  float FillA;
  color Stroke;
  float StrokeA;
  float weight;
  int join;
  int cap;
  style(){
    Fill = 0;    FillA = 0;
    Stroke = 0;  StrokeA = 0;
    weight = 0;
    join = ROUND;
    cap = ROUND;
  }
  style copy(){
    return new style(Fill,FillA,Stroke,StrokeA,weight,join,cap);
  }
  
  style(color f,float fa){
    Fill = f;    FillA = fa;
    Stroke = 0;  StrokeA = 0;
    weight = 0;
    join = ROUND;
    cap = ROUND;
  }
  style(color f,float fa,color s,float sa){
    Fill = f;    FillA = fa;
    Stroke = s;  StrokeA = sa;
    weight = 1;
    join = ROUND;
    cap = ROUND;
  }
  style(color f,float fa,color s,float sa,float w){
    Fill = f;    FillA = fa;
    Stroke = s;  StrokeA = sa;
    weight = w;
    join = ROUND;
    cap = ROUND;
  }
  style(color f,float fa,color s,float sa,float w,int j, int c){
    Fill = f;    FillA = fa;
    Stroke = s;  StrokeA = sa;
    weight = w;
    join = j;
    cap = c;
  }
  void set(){
    fill(Fill,FillA);
    stroke(Stroke,StrokeA);
    strokeWeight(weight);
    strokeJoin(join);
    strokeCap(cap);
  }
   void set(PGraphics g){
    g.fill(Fill,FillA);
    g.stroke(Stroke,StrokeA);
    strokeWeight(weight);
    strokeJoin(join);
    strokeCap(cap);
  }
}

class canvas implements drawable,orientable{
  ArrayList<drawable> contents;
  transform orientation;
  
  transform getOrientation(){
    return orientation;
  }
  void setOrientation(transform t){
    orientation = t;
  }
  void addOrientation(transform t){
    orientation.timesEq(t);
  }
  
  boolean changed;
  
  canvas(){
    contents = new ArrayList<drawable>();
    orientation = new transform();
    changed = false;
  }
  void draw(transform t){
    transform effective = orientation.semit(t);
    for(drawable d:contents){
      d.draw(effective);
    }
  }
  void draw(transform t,PGraphics g){
    transform effective = orientation.semit(t);
    for(drawable d:contents){
      d.draw(effective,g);
    }
  }
}

class bg implements drawable{
   color c;
   bg(color C){
     c = C;
   }
   void draw(transform t){
     background(c);
   }
   void draw(transform t,PGraphics g){
     g.background(c);
   }
}

class Quad implements drawable,orientable {
  Point a,b,c,d;
  style s;
  
  transform orientation;
  transform getOrientation(){
    return orientation;
  }
  void setOrientation(transform t){
    orientation = t;
  }
  void addOrientation(transform t){
    orientation.timesEq(t);
  }
  Quad(Point A,Point B,Point C,Point D,style S){
    a=A;b=B;c=C;d=D;
    s = S;
    orientation = new transform();
  }
  
  void draw(transform t){
    s.set();
    transform eff = orientation.semit(t);
    Point t1 = eff.apply(a);
    Point t2 = eff.apply(b);
    Point t3 = eff.apply(c);
    Point t4 = eff.apply(d);
    quad(t1.displayX(),t1.displayY(),
         t2.displayX(),t2.displayY(),
         t3.displayX(),t3.displayY(),
         t4.displayX(),t4.displayY());
  }
  void draw(transform t,PGraphics g){
    s.set(g);
    transform eff = orientation.semit(t);
    Point t1 = eff.apply(a);
    Point t2 = eff.apply(b);
    Point t3 = eff.apply(c);
    Point t4 = eff.apply(d);
    g.quad(t1.displayX(),t1.displayY(),
         t2.displayX(),t2.displayY(),
         t3.displayX(),t3.displayY(),
         t4.displayX(),t4.displayY());
  }
}

class Ellispe implements drawable,orientable {
  Point a,b;
  style s;
  
  transform orientation;
  transform getOrientation(){
    return orientation;
  }
  void setOrientation(transform t){
    orientation = t;
  }
  void addOrientation(transform t){
    orientation.timesEq(t);
  }
 Ellispe(Point A,Point B,style S){a=A;b=B;s=S;}
 void draw(transform t){
    s.set();
    transform eff = orientation.semit(t);
    Point t1 = eff.apply(a);
    Point t2 = eff.apply(b);
    
    ellipse(t1.displayX(),t1.displayY(),
         t2.displayX(),t2.displayY());
  }
  void draw(transform t,PGraphics g){
    s.set(g);
    transform eff = orientation.semit(t);
    Point t1 = eff.apply(a);
    Point t2 = eff.apply(b);
    
    g.ellipse(t1.displayX(),t1.displayY(),
         t2.displayX(),t2.displayY());
  }
}
class Line implements drawable,orientable {
  Point a,b;
  style s;
  
  transform orientation;
  transform getOrientation(){
    return orientation;
  }
  void setOrientation(transform t){
    orientation = t;
  }
  void addOrientation(transform t){
    orientation.timesEq(t);
  }
  Line(Point A,Point B,style S){
    a=A;b=B;
    s = S;
    orientation = new transform();
  }
  
  void draw(transform t){
    s.set();
    transform eff = orientation.semit(t);
    Point t1 = eff.apply(a);
    Point t2 = eff.apply(b);
    
    line(t1.displayX(),t1.displayY(),
         t2.displayX(),t2.displayY());
  }
  void draw(transform t,PGraphics g){
    s.set(g);
    transform eff = orientation.semit(t);
    Point t1 = eff.apply(a);
    Point t2 = eff.apply(b);
    
    g.line(t1.displayX(),t1.displayY(),
         t2.displayX(),t2.displayY());
  }
}








//class textStyle
