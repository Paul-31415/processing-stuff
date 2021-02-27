
float baseline(float in){
  return log(in)/log(2);
  
  
}
int mMask = (Float.floatToIntBits(1)^(Float.floatToIntBits(1)-1));
int eMask = -1^mMask;
int intLog(int a){
  return (int)((mMask+1)*(log(mMask+1+a)/log(mMask+1)));
  
}
int div = ((Float.floatToIntBits(1)^(Float.floatToIntBits(1)-1))+1)/2;
float approx(float in){
  int n = Float.floatToIntBits(in);
  int m = n&mMask;
  int e = n&eMask;
  return (float)(intLog(m)+e-Float.floatToIntBits(1))/div;//Float.intBitsToFloat(e|m);
  
}

float x = 1;
float y = 0;
float sx;
float sy;
void setup(){
  surface.setResizable(true);
  size(256,256);
  background(255);
  
  graph();
  sx = 1./width;
  sy = 1./height;
  
}
void mouseReleased(){
  background(255);
  
  graph();
  
  
}
int oldx;
int oldy;

void draw(){
  if (mousePressed){
    x -= (mouseX-oldx)*sx;
    y += (mouseY-oldy)*sy;
    background(255);
    graph();
    
  }
  
  oldx = mouseX;
  oldy = mouseY;
}


void graph(){
  stroke(0);
  float[] oldYs = {baseline(x),approx(x)};
  for(int wx = 0; wx < width ; wx++){
    float xp = sx*((float)wx)+x;
    float[] newYs = {baseline(xp),approx(xp)};
    for(int i = 0; i < newYs.length; i++){
      stroke(color(0,0,i*128));
      line(wx-1,(height-(oldYs[i]-y)/sy),wx,(height-(newYs[i]-y)/sy));
    }
    oldYs = newYs;
  }
  
  float oldY = baseline(x)-approx(x);
  for(int wx = 0; wx < width ; wx++){
    float xp = sx*((float)wx)+x;
    float newY = baseline(xp)-approx(xp);
    for(int i = 0; i < 60; i+= 4){
      stroke(color(255,0,0,i+4)); //<>//
      line(wx-1,(height-(oldY*(1<<i)-y)/sy),wx,(height-(newY*(1<<i)-y)/sy));
    }
    oldY = newY;
  }
}
