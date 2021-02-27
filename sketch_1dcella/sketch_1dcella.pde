
double ox = 0;
double oy = 0;
double sx = 1;
double sy = 1;
boolean doAntialias = false;
String seed = "Hello, World!";

int rule = 150;
//169 = 0b 1010 1001 inverted is 0b 0110 1010 (106) 
//57 = mountains
//
int stepsize;
boolean[][] world;
void setup(){
  size(512,512);
  //fullScreen();
  background(255);
  stroke(color(0));
  //l//ine(128,,128,128);
  world = new boolean[width*8][height*8];
  for (int y = 0; y < world[0].length; y++) {
    for (int x = 0; x < world.length; x++){
      world[x][y] = false;
    }
  }
  for( int c = 0; c < seed.length(); c++){
  for (int x = 0; x < 8; x++){
      world[x+c*8+(world.length+seed.length()*8)/2][0] = (seed.charAt(c)&(1<<x))!=0;
   }
  }
  //world[(int)(width/2)][0] = true;
  
  stepsize=(int)(height/4);
}

double speed = 32.1;
int h = 1;

void draw(){
  
  if (h < world[0].length){
    doRule(h,stepsize+1);
    h += stepsize;
    dispWorld();
  }
  if( mousePressed){
    if ((int)(mouseX*sx-ox)>=0 && (int)(mouseY*sy-oy)>=0&&(int)(mouseX*sx-ox)<world.length && (int)(mouseY*sy-oy)<world[0].length){
      world[(int)(mouseX*sx-ox)][(int)(mouseY*sy-oy)]= !(world[(int)(mouseX*sx-ox)][(int)(mouseY*sy-oy)]);
      h = (int)(mouseY*sy-oy+1);
      
    }
  }
  if (keyPressed){
    if( key == '='){
      sx /= 1.01;
      sy /= 1.01;
      dispWorld();
    }
    if (key == '-'){
      sx *= 1.01;
      sy *= 1.01;
      dispWorld();
    }
    if (key == 'w'){
      oy += sy*speed;
      dispWorld();
    }
    if (key == 's'){
      oy -= sy*speed;
      dispWorld();
    }
    if (key == 'a'){
      ox += sx*speed;
      dispWorld();
    }
    if (key == 'd'){
      ox -= sx*speed;
      dispWorld();
    }
    if(key == 'q'){
      doAntialias = !doAntialias;
      dispWorld();
    }
    if(key == '1'){
      sx = 1;
      sy = 1;
      dispWorld();
    }
    if(key == '8'){
      sx = 8;
      sy = 8;
      dispWorld();
    }
    if(key == '9'){
      sx /= 2;
      sy /= 2;
      dispWorld();
    }
    if(key == '0'){
      sx *= 2;
      sy *= 2;
      dispWorld();
    }
    
  }
}
void keyPressed(){
  if (key == 'g'){
    //get row
    
  }
}


void doRule(int s,int n){
  if (s+n > world[0].length)
    n = world[0].length-s;
  for (int y = s; y < s+n; y++) {
    for (int x = 1; x < world.length-1; x++){
      int r = (world[x-1][y-1]?1:0)+(world[x][y-1]?2:0)+(world[x+1][y-1]?4:0);
      world[x][y] = (((rule >> r) & 1) == 1);
    }
  }
}
double epsilon = 1e-10;

color getColor(double x, double y,double w, double h){
  if (!doAntialias){
    int xs = (int)x;
    int ys = (int)y;
    int g = 0;
    int r = 0;
    if (xs >= 0 && ys >= 0 && xs < world.length && ys < world[0].length){
      g = (world[xs][ys]?0:255);
    }else{
      r = 255;
    }
    return color(r+g,g,g);
  }
  
  double t = 0;
  double e = 0;
  double at = 0;
  for (int xs = (int)Math.floor(x) ; xs <= (int)Math.ceil(x+w);xs++){
    for (int ys = (int)Math.floor(y) ; ys <= (int)Math.ceil(y+h);ys++){
      double a = 1;
      if (xs == (int)Math.floor(x))
        a *= 1-(x-Math.floor(x));
      else if (xs == (int)Math.ceil(x+w))
        a *= x+w-Math.floor(x+w);
      
      if (ys == (int)Math.floor(y))
        a *= 1-(y-Math.floor(y));
      else if (ys == (int)Math.ceil(y+h))
        a *= y+h-Math.floor(y+h);
      at += a;
      if (xs >= 0 && ys >= 0 && xs < world.length && ys < world[0].length){
        t += (world[xs][ys]?0:a);
        
      }else{
        e += a;
      }
    }
  }

  t /= at;
  e /= at;
  
  int g = (int)(t*250);
  int r = (int)(e*250);
  return color(r+g,g,g);
}
  
void dispWorld(){
  
  loadPixels();
  for (int y = 0; y < height; y +=1){
    for (int x = 0; x < width;x+= 1){
      pixels[x+width*y] = getColor(x*sx-ox,y*sy-oy,sx,sy);
    }
  }
  updatePixels();
}
