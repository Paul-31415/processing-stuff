int mode = 0;
float[] gaussVals; 
float[] term; 
boolean[] added;
float hscale = 0.25;

int delay = 64;

void setup(){
  size(512,512);
  background(255);
  gaussVals = new float[width];
  term = new float[width];
  added = new boolean[width];
  for(int i = 0; i < width; i++){added[i] = false;gaussVals[i] = 0;term[i] = 0;}
  drawGraph(term,-height/3,height/2,255,0,0);
  drawGraph(gaussVals,-height/3,height/2,0,0,0);
  if (mode == 1){
    term = cosArr(0);
    addArr(gaussVals,term);
    addArr(gaussVals,term);
    added[width/2] = true;
  }
}
float max = 8;
float i = 0;
float istep = max;
int frameI = 0;
boolean prevMouse = false;
int prevMouseX=0;
void draw(){
  if(mode == 1){
    if(mousePressed  ){
      
      background(255);
      
      float vscale = 1;
      int d = 0;
      int start = mouseX;
      if(prevMouse){
        start = prevMouseX;
        d = Integer.signum(mouseX-start);
      }
      if(!added[mouseX%width]){
          added[mouseX%width] = true;
          term = cosArr(hscale*hscale*((mouseX%width)-width/2));
          vscale = 2*addArr(gaussVals,term);
          drawGraph(term,-height/3/vscale,height/2,255,0,0);
      }
      for(int mx = start; mx != mouseX; mx += d){
        if(!added[mx%width]){
          added[mx%width] = true;
          term = cosArr(hscale*hscale*((mx%width)-width/2));
          vscale = 2*addArr(gaussVals,term);
          drawGraph(term,-height/3/vscale,height/2,255,0,0);
        }
      }
      drawGraph(gaussVals,-height/3/vscale,height/2,0,0,0);
      stroke(0,0,255,128);
      for(int x = 0; x < width; x++){
        if(!added[x]){line(x,0,x,height);}}
        
    }
    prevMouse = mousePressed;
    prevMouseX = mouseX;
  }
  if(frameI == 0 && mode == 0){
  background(255);
  fill(0);
  text("step:",0,12);
  text(istep,30,12);
  text("term:",0,24);
  text(i,30,24);
  text("delay:",0,36);
  text(delay,40,36);
  term = cosArr(i);
  float vscale = 2*addArr(gaussVals,term);
  

  drawGraph(term,-height/3/vscale,height/2,255,0,0);
  

  drawGraph(gaussVals,-height/3/vscale,height/2,0,0,0);
  
  
  i += istep;
  if(i>max){
    i = 0;
    istep /= 2;
    i += istep/2;
    delay = delay*2/3 + 1;
  }
  }
  frameI = (frameI+1)%delay;
}

float addArr(float[] a, float[] b){
  float max = 0;
  for(int x = 0; x < a.length; x++){
    a[x] += b[x];
  if(a[x]> max){max = a[x];} }
  return max;
}

float[] cosArr(float i){
  float[] res = new float[width];
  float g = gaussian(i);
  if (i == 0){ g /= 2;}
  for(int j = 0; j < width; j++){
    float x = (j-width/2)*hscale;
    res[j] = g*cos(x*i);
  }
  return res;
}

float gaussian(float x){
  return exp(-(x*x));
}
void keyPressed(){
  if (key == '+' && delay > 1){
    delay--;
  }
  if (key == '-'){
    delay++;
  }
}

void drawGraph(float[] vals,float s,float o,int r,int g, int b){
  for(int x = 0; x < vals.length-1; x++){
    int a = 255;
    for( int y = 1; a > 0;y<<=4){ 
      stroke(r,g,b,a);
      a >>= 1;
      line(x,s*vals[x]*y+o,x+1,s*vals[x+1]*y+o);}}
}
