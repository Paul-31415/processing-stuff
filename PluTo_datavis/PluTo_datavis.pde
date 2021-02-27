


class IVec{
   int[] coords;
   IVec(int... c){
     coords = c;
   }
}

PImage bg;

/* 
//case data
int[] dimOrder = {0,1,2,3,4,5,6,7};
int[] dimOrder_inv;
String[] dimNames = {"tile","l2tile","parallel","partlbtile",
                      "lbtile","multipar","innerpar","fuse"};
int[] dimVals  = {2,2,2,2,2,2,2,4};

color[] colors = {color(0x80,0,0),color(0,0x80,0),color(0,0,0x80),color(0x20,0,0),
                  color(0,0x20,0),color(0,0,0x20),color(8,8,0),color(0,2,4)};
color[] fontColors = {color(0,0,0),color(255,255,255),color(0,255,0),color(255,0,255)};

int[] dimStarts = {0,0,0,0,0,0,0,0};

boolean tile_data = false;

/*/
//case tile_data

int[] dimOrder = {0,1,2,3,4,5,6};
int[] dimOrder_inv;
String[] dimNames = {"parallel","l2tile","partlbtile",
                      "x","y","z","x=y=z"};
int[] dimVals  = {2,2,2,5,5,5,96-8};

int[] dimStarts = {0,0,0,0,0,0,8};

color[] colors = {color(0x80,0,0),color(0,0x80,0),color(0,0,0x80),
                  color(1,0,0),color(0,1,0),color(0,0,1),color(0,0,0)};
color[] fontColors = {color(0,0,0),color(255,255,255),color(0,255,0),color(255,0,255)};


boolean tile_data = false;
// */

color getFontColor(int n){
  if (n >= 0 && n < fontColors.length){
    return fontColors[n];
  }
  return color(255,255,192);
}

void calc_dimOrder_inv(){
  for(int i = 0;i < dimOrder.length; i ++){
   dimOrder_inv[dimOrder[i]] = i;   
  }
}

int getVal(IVec v){
  int r = 0;
  //for(int i = dimOrder.length-1; i >= 0; i --){
  if (!tile_data){
  for(int i = 0;i < dimOrder.length; i ++){
     r *= dimVals[dimOrder[i]];
     r += v.coords[dimOrder[i]]-dimStarts[dimOrder[i]]; 
  }
  }else{
    
    for(int i = 0;i < dimOrder.length; i ++){
      if (dimOrder[i] == dimOrder.length-1){
        if (v.coords[dimOrder.length-4] == v.coords[dimOrder.length-3] &&
            v.coords[dimOrder.length-3] == v.coords[dimOrder.length-2] ){
              
              r *= dimVals[dimOrder[i]];
              r += v.coords[dimOrder[i]-1]-dimStarts[dimOrder[i]];
              
              
        }
      }else{
        if (dimOrder[i] >= dimOrder.length-4){
          r *= 5;
          r += (v.coords[dimOrder[i]] & 16)/16+(v.coords[dimOrder[i]] & 32)/16+
               3*(v.coords[dimOrder[i]] & 64)/64+(v.coords[dimOrder[i]] & 128)/32
               ;
        }
        
      else{
         r *= dimVals[dimOrder[i]];
         r += (v.coords[dimOrder[i]]-dimStarts[dimOrder[i]]);
      }}
    }
  }
  
  return r;
}

class Datum{
  IVec xpos;
  double[] ypos;
  Datum(IVec x, double[] y){
    xpos = x; ypos = y;
  }
  double x(){
    return getVal(xpos);
  }
  double y(){
    double a = 0;
    for (double d : ypos){
      a += d;
    }
    return a/ypos.length;
  }
}



Datum[] data;

double x = 0;
double y = 0;
double sx = 12;
double sy = 12;

void setup(){
    size(800,800);
    data = parse(raw_data);
    dimOrder_inv = new int[dimOrder.length];
    calc_dimOrder_inv();
    
    
    reDraw();
}


float tx(double px){
  //transform about middle
  return (float)(width/2+(px+x)*sx);
}
double itx(float ttx){
  return (ttx-width/2)/sx-x;
}
float ty(double py){
  return (float)(height/2-(py+y)*sy);
}
double ity(float tty){
  return (height/2-tty)/sy-y;
}

color c(Datum v){
  color r = 0;
  for (int i = 0; i < v.xpos.coords.length; i ++){
    r += v.xpos.coords[i]*colors[i];
    
  }
  return r; 
}
float barWidth = 0.8;
void plotData(){
  calc_dimOrder_inv();
  if (hover != -1){
    stroke(color(64));
    fill(color(64));
    rect(0,ty(-hover),width,(float)sy);
  }
  if (dragging != -1){
    stroke(color(128));
    fill(color(128));
    rect(0,ty(-dragging),width,(float)sy);
  }
  
  for(int i = 0; i < 21; i++){
    stroke(color((i%5==0)?((i%10==0)?255:192):128));
    line(0,ty(i),width,ty(i));
  }
  textSize((float)sx);
  stroke(255);
  fill(255);
   
     
       if (tx(-10)>0){
         for (int i = 0; i < dimOrder.length; i++){
       text(str(dimOrder.length-i),tx(-1),ty(-i-1));
       //text(str(dimOrder.length-i),tx(-1),ty(-dimOrder[i]-1));
         text(dimNames[dimOrder[i]],tx(-10),ty(-i-1));
         }
       }else{
         
         if (hover != -1){
          stroke(color(64));
          fill(color(64));
          rect(0,ty(-hover-dimOrder.length),(float)sx*10,(float)sy);
          stroke(255);
          fill(255);
         }
         if (dragging != -1){
          stroke(color(128));
          fill(color(128));
          rect(0,ty(-dragging-dimOrder.length),(float)sx*10,(float)sy);
          stroke(255);
          fill(255);
         }
         for (int i = 0; i < dimOrder.length; i++){
       text(str(dimOrder.length-i),tx(-1),ty(-i-1));
       //text(str(dimOrder.length-i),tx(-1),ty(-dimOrder[i]-1));
         text(dimNames[dimOrder[i]],0,ty(-i-1-dimOrder.length));
       }
     }
  
   for( Datum d : data){ // draw bars
     if (tx(d.x()) > -50 && tx(d.x()) < width+50){
     fill(c(d));
     stroke(255);
     rect(tx(d.x()),ty(d.y()),(float)sx*barWidth,(float)(d.y()*sy));
     
     stroke(color(255,224,255));
     for (int i = 0; i < d.ypos.length; i++){
        line( tx(d.x()+i*barWidth/d.ypos.length),ty(d.ypos[i]),tx(d.x()+(i+1)*barWidth/d.ypos.length),ty(d.ypos[i]));
     }
     
     for (int i = 0; i < d.xpos.coords.length; i++){
       fill(getFontColor(d.xpos.coords[dimOrder[i]]));
       text(str(d.xpos.coords[dimOrder[i]]),tx(d.x()),ty(-i-1));
     }
     
     }
   }
   
   
   
   
   
}
void draw(){
  image(bg,0,0);
  fill(255);
  if (ity(mouseY)>0){ 
    text(getHoveredName(),mouseX,mouseY);
  }
}
void reDraw(){
  background(80);
  plotData();
  bg = get();
}

double speed_div=8;
int hover = -1;
void keyPressed(){
  if (key == 'a'){
    x += width/sx/speed_div;
  }
  if (key == 'd'){
    x -= width/sx/speed_div;
  }
  if (key == 'w'){
    y -= height/sy/speed_div;
  }
  if (key == 's'){
    y += height/sy/speed_div;
  }
  
  if (key == 'A'){
    x += width/sx/speed_div/speed_div;
  }
  if (key == 'D'){
    x -= width/sx/speed_div/speed_div;
  }
  if (key == 'W'){
    y -= height/sy/speed_div/speed_div;
  }
  if (key == 'S'){
    y += height/sy/speed_div/speed_div;
  }
  
  if (key == 'r'){
    if (hover>-1){
      int i = dimOrder[hover];
      dimStarts[i] -= dimVals[i];
      dimVals[i] *= -1;
    }
  }
  
  if (key == '+'){
    sx *= 1.125;
    sy *= 1.125;
  }
  if (key == '-'){
    sx /= 1.125;
    sy /= 1.125;
  }
  
  
  if ("12345678".indexOf(key) > -1){
    int si = "12345678".indexOf(key);
    for(int i = 0; i < dimOrder.length-1; i++){
      dimOrder[i] = dimOrder[i+1];
    }
    dimOrder[dimOrder.length-1]=si;
  }
  
  if ("!@#$%^&*".indexOf(key) > -1){
    int si = "!@#$%^&*".indexOf(key);
    dimVals[si] = 1;
    
  }
  
  reDraw();
  
}

String getHoveredName(){
  int n = (int)Math.floor(itx(mouseX));
  if (n < 0){
    return "";
  }
  String r = "syr2k_";
  for(int i = dimNames_raw.length-1; i >= 0 ; i--){
    if (dimNames_raw[dimOrder[i]].length != 0){
    if (n%dimVals[dimOrder[i]] != 0){
      r = r + dimNames_raw[dimOrder[i]][(n%dimVals[dimOrder[i]])-1];
    }
    }else{
      r = r + "(" + (new String[]{"x=","y=","z=","xyz="}[dimOrder[i]-3]) + str(n%dimVals[dimOrder[i]]+dimStarts[dimOrder[i]])+")";
    }
    n /= dimVals[dimOrder[i]];
  }
  return r;
}



int getSelectedDim(){
  int p = -1-(int)Math.floor(ity(mouseY));
  if (p>= 0 && p < dimOrder.length){
    return p;
  }
  if (tx(-10)<=0){
    if (mouseX < 10*sx){
      p = (-1-(int)Math.floor(ity(mouseY)))-dimOrder.length;
      if (p>= 0 && p < dimOrder.length){
        return p;
      }
    }    
  }
  return -1;
}




void mouseMoved(){
  int p = getSelectedDim();
  if (p >= 0 && p < dimOrder.length&& hover != p){
    
    hover = p;
    reDraw();
  }
}


int dragging = -1;
void mousePressed(){
  int r =  getSelectedDim();
   if (r >= 0 &&  r < dimOrder.length){
     dragging = r;
   }
   //println(dragging);
  
}



void mouseDragged(){
  int p =  getSelectedDim();
  if (p!=dragging && dragging >= 0 && p >= 0 && p < dimOrder.length){
    int tmp = dimOrder[p];
    dimOrder[p] = dimOrder[dragging];
    dimOrder[dragging] = tmp;
    dragging = p;
    reDraw();
    /*for(int i = 0; i < 8; i++){
      print(dimOrder[i]);
    }
    println();
    for(int i = 0; i < 8; i++){
      print(dimOrder_inv[i]);
    }*/
    
  }
}

void mouseReleased(){
  dragging = -1;
}
