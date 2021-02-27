


//http://extremelearning.com.au/unreasonable-effectiveness-of-quasirandom-sequences/

double harmonius(int n){
  double p = 1;
  for(int i = 0; i < 8192; i++){
    p = Math.pow(1+p,1./n);
  }
  return p;
}
double x = 0;
double y = 0;
double phi = 1.6180339887498948482;
double psi = 1.4655712318767680266567312;
double plas = 1.32471795724474602596;
double dx = harmonius(2);//phi;//1.3247179572447460260;
double dy = harmonius(3);//plas;//1.3802775690976141157;


void setup(){
  size(768,768);
  pixelDensity(2);
  background(255);
  
  double g = harmonius(1+2);
  dx = 1/g;
  dy = dx/g;
}



int s = 1;
void draw(){
  stroke(0);
  for (int i = 0; i <= s/64;i++){
    point((float)(x),(float)(y));
    x = (x+dx*width)%width;
    y = (y+dy*height)%height;
    s += 1;
  }
}
