



class BrushedBezierPath extends BezierPath implements drawable{
  brush brush;
  double delta;
  BrushedBezierPath(brush b,double r){
    super();
    brush = b;
    delta = 1./r;
  }
  BrushedBezierPath(brush b,double r,Bezier... be){
    super(be);
    brush = b;
    delta = 1./r;
  }
  void draw(transform t,PGraphics g){
    transform tmp = orientation;
    orientation = orientation.semit(t);
    brush.Stroke((Path)this,delta,g);
    orientation = tmp;
  }
  void draw(transform t){
    transform tmp = orientation;
    orientation = orientation.semit(t);
    brush.Stroke((Path)this,delta);
    orientation = tmp;
  }
}

























//testing thingy

void quadStrokeBezier(Bezier b,double dt){
  beginShape();
  Point oldP = ((vnd) b.get(0)).toPoint();
  vertex(oldP.displayX(),oldP.displayY());
  for( double t = dt; t < 1; t += dt){
    Point p = ((vnd)b.get(t)).toPoint();
    Point hp = ((vnd)b.get(t-dt/2)).toPoint();
    quadraticVertex(hp.displayX(),hp.displayY(),p.displayX(),p.displayY());
    oldP = p;
  }
  endShape();
}
