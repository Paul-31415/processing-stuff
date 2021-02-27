interface brush{
  abstract brush copy();
  abstract void Stroke(Path p, double delta);
  abstract void Stroke(Path p, double delta,PGraphics g);
}

class lineBrush implements brush{
  style s;
  lineBrush(style S){ s=S;}
  lineBrush(color c){s = new style(0,0,c,255);}
  lineBrush(color c, float a){s = new style(0,0,c,a);}
  lineBrush(color c, float a,float t){s = new style(0,0,c,255,t);}
  
  brush copy(){
    return new lineBrush(s.copy());
  }
  void Stroke(Path p,double r){
    s.set();
    Point pr = p.get(p.start()).toPoint();
    for(double t = p.start()+r; t < p.end(); t += r){
      Point pt = p.get(t).toPoint();
      //print(t);print(':');println(pr.displayY());
      line(pr.displayX(),pr.displayY(),pt.displayX(),pt.displayY());
      pr = pt;
    }
  }
  void Stroke(Path p, double delta,PGraphics g){
    s.set(g);
    Point pr = p.get(p.start()).toPoint();
    for(double t = p.start()+delta; t < p.end(); t += delta){
      Point pt = p.get(t).toPoint();
      //print(t);print(':');println(pr.displayY());
      g.line(pr.displayX(),pr.displayY(),pt.displayX(),pt.displayY());
      pr = pt;
    }
  }
}
class polyCurveBrush implements brush{
  style s;
  polyCurveBrush(style S){s=S;}
  polyCurveBrush(color C,float A,color FC,float FA){ s = new style(FC,FA,C,A);}
  brush copy(){
    return new polyCurveBrush(s.copy());
  }
  
  void Stroke(Path p,double r){
    s.set();
    beginShape();
    for(double t = p.start(); t < p.end(); t += r){
      Point pt = p.get(t).toPoint();
      curveVertex(pt.displayX(),pt.displayY());
    }
    endShape();
  }
  void Stroke(Path p, double delta,PGraphics g){
    s.set(g);
    g.beginShape();
    for(double t = p.start(); t < p.end(); t += delta){
      Point pt = p.get(t).toPoint();
      g.curveVertex(pt.displayX(),pt.displayY());
    }
    g.endShape();
  }
}

class polyBrush implements brush{
  style s;
  polyBrush(style S){ s=S;}
  polyBrush(color C,float A,color FC,float FA){ s = new style(FC,FA,C,A);}
  brush copy(){
    return new polyBrush(s.copy());
  }
  void Stroke(Path p,double r){
    s.set();
    beginShape();
    for(double t = p.start(); t < p.end(); t += r){
      Point pt = p.get(t).toPoint();
      vertex(pt.displayX(),pt.displayY());
    }
    endShape();
  }
  void Stroke(Path p, double delta,PGraphics g){
    s.set(g);
    g.beginShape();
    for(double t = p.start(); t < p.end(); t += delta){
      Point pt = p.get(t).toPoint();
      g.vertex(pt.displayX(),pt.displayY());
    }
    g.endShape();
  }
}
