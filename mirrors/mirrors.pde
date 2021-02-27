






class vec{
  double x,y;
  vec(double X,double Y){
    x = X;y = Y;
  }
  vec(){
    x=0;y=0;
  }
  vec add(vec o){
    return new vec(x+o.x,y+o.y);
  }
  vec sub(vec o){
    return new vec(x-o.x,y-o.y);
  }
  vec neg(){
    return new vec(-x,-y);
  }
  vec scale(double s){
    return new vec(x*s,y*s);
  }
  double dot(vec o){
    return x*o.x+y*o.y;
  }
  double mag2(){
    return this.dot(this);
  }
  double mag(){
    return Math.sqrt(this.mag2());
  }
  vec rot90CCW(){
    return new vec(-y,x);
  }
  vec rot90CW(){
    return new vec(y,-x);
  }
  
}
class mline{
  vec a,b;
  mline(vec A,vec B){
    a=A;b=B;
  }
  void draw(){
    line((float)a.x,(float)a.y,(float)b.x,(float)b.y);
  }
  vec mirror(vec p){
    vec n = b.sub(a).rot90CCW();
    double d = n.dot(p.sub(a));
    if (d>=0){
      return p;
    }
    return p.sub(a).sub(n.scale(d*2./n.mag2())).add(a);
  }
  boolean side(vec p){
    vec n = b.sub(a).rot90CCW();
    double d = n.dot(p.sub(a));
    return (d<0);
  }
  void mirrorBG(){
    PImage bg = get();
    for (int x = 0; x < width;x++){
      for (int y = 0; y < height;y++){
        vec v = this.mirror(new vec(x,y));
        int rx = (int)v.x;
        int ry = (int)v.y;
        int c = color(random(255),random(255),random(255));
        if (rx >= 0 && rx < width && ry >= 0 && ry < height){
          c = bg.get(rx,ry);
        }
        set(x,y,c);
      }
    }
  }
}
PImage bg;
void setup(){
  size(1024,1024);
  background(0);
  bg = loadImage("e2wiznt6wbe41.jpg");
  image(bg,0,0);
  /*mline t = new mline(new vec(10,10),new vec(50,90));
  stroke(color(255,0,0));
  t.draw();
  t.mirrorBG();*/
  mirrors = new ArrayList<mline>();
}
ArrayList<mline> mirrors; 
vec start;
void mousePressed(){
  start = new vec(mouseX,mouseY);
}
void mouseReleased(){
  vec end = new vec(mouseX,mouseY);
  mline l = new mline(start,end);
  mirrors.add(l);
  re_draw();
  //l.mirrorBG();
}
void re_draw(){
  background(0);
  loadPixels();
  for (int x = 0; x < width;x++){
    for (int y = 0; y < height;y++){
      vec v = new vec(x,y);
      for(int i = 0; i < 100; i++){
        boolean got = false;
        for (mline m : mirrors){
          got |= m.side(v); 
          v = m.mirror(v);
        }
        if (!got){
          break;
        }
      }
        int rx = (int)v.x;
        int ry = (int)v.y;
        int c = color(random(255),random(255),random(255));
        if (rx >= 0 && rx < bg.width && ry >= 0 && ry < bg.height){
          c = bg.get(rx,ry);
        }
        pixels[x+width*y] = c;
      }
    }
    updatePixels();
}
void draw(){}
void keyPressed(){
  if (key == 'r'){
    mirrors.clear();
    re_draw();
  }
}
