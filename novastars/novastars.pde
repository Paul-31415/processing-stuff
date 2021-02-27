import java.util.Random;

double s = 64;

ArrayList<star> getStars(double x, double y, double w, double h){
  ArrayList<star> ans = new ArrayList<star>();
  
  for (long tx = (long)Math.floor(x);tx < x+w;tx++){
    for (long ty = (long)Math.floor(y);ty < y+h;ty++){
      getStarsTile(tx,ty,ans);
    }
  }
  
  return ans;
}

Random posFunc(long x, long y){
  Random r = new Random(x);
  for(int i = 0; i < 20; i++){
    r.nextLong();
  }
  r.setSeed(r.nextLong()^y);
  for(int i = 0; i < 20; i++){
    r.nextLong();
  }
  return r;
}

void getStarsTile(long tx, long ty, ArrayList<star> ans){
  Random r = posFunc(tx,ty);
  for(int i = 0; i < r.nextDouble()*5-1; i++){
    ans.add(new star(r.nextDouble()+tx,r.nextDouble()+ty,r.nextDouble()+1,(r.nextDouble()*1+0.1)/s,color(255)));
  }
}


double x = 0;
double y = 0;



void setup(){
  size(512,512);
}
class star{
  double x,y,z,sz;
  color c;
  star(double X,double Y,double Z, double S, color C){
    x = X;y = Y;z = Z;sz = S;c = C;
  }
  void draw(double x,double y){
    stroke(this.c);
    fill(this.c);
    ellipse((float)(((this.x-x)*s-width/2)/this.z)+width/2,(float)(((this.y-y)*s-height/2)/this.z)+height/2,(float)(this.sz*s/this.z),(float)(this.sz*s/this.z));
  }
}
void drawStars(){
  new star(0,0,1,10,color(255)).draw(x,y);
  new star(0,0,2,10,color(255,0,0)).draw(x,y);
  for (star st : getStars(x,y,width/s,height/s)){
    st.draw(x,y);
  }
}

void draw(){
  background(0);
  drawStars();
  if (keyPressed){
    if (key == 'd'){
    x += 1/s;
  }
  if (key == 'a'){
    x -= 1/s;
  }
  if (key == 'w'){
    y -= 1/s;
  }
  if (key == 's'){
    y += 1/s;
  } 
  }
}
