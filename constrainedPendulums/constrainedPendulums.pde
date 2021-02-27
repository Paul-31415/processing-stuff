

double gy = 1;
double gx = 0;

double[] ms;
double[][] vs;
double[][] fs;
double[] as;
double[] avs;
double[] is;
double[] ls;

int n = 256;
void setup(){
  size(750,750);
  background(0);
  
  ms = new double[n];
  vs = new double[n][];
  fs = new double[n][];
  as = new double[n];
  avs = new double[n];
  is = new double[n];
  ls = new double[n];
  for (int i = 0; i < n; i++){
    ms[i] = 1;
    is[i] = 1;
    ls[i] = 5.*Math.sin((i+1));//Math.sqrt(i+1);
    as[i] = Math.PI/2;
    vs[i] = new double[2];
    fs[i] = new double[] {0,0};
    avs[i] = Math.cos(i+1);
  }
  for (int i = 0; i < path.length; i++){
    path[i] = new double[] {0,0};
  }
  
}


void calcVs(){
  //calculates the absolute velocities of each endpoint
  double vx = 0;
  double vy = 0;
  for (int i = 0; i < avs.length; i++){
    vx -= Math.sin(as[i])*avs[i]*ls[i];
    vy += Math.cos(as[i])*avs[i]*ls[i];
    vs[i][0] = vx;
    vs[i][1] = vy;
  }
}


void draw(){
  background(0);
  stroke(255);
  
  drawp();
  calcpath(60./60,16);
  step(60./60);
}


void step(double dt){
  for (int i = 0; i < avs.length; i++){
    as[i] += avs[i]*dt;
  }
  
}

double[][] path = new double[16384][];
int pathi = 0;
void calcpath(double dt,int steps){
  for(int step = 0; step < steps; step ++){
  double px = width/2;
  double py = height/2;
  for (int i = 0; i < avs.length; i++){
    double dx = Math.cos(as[i]+avs[i]*dt*step/steps)*ls[i];
    double dy = Math.sin(as[i]+avs[i]*dt*step/steps)*ls[i];
    px += dx; py += dy;
  }
  
  path[pathi][0] = px;
  path[pathi][1] = py;
  pathi = (pathi+1)%path.length;
  }
}
void drawp(){
  //
  
  //calculates the absolute positions of each endpoint
  stroke(255);
  double px = width/2;
  double py = height/2;
  for (int i = 0; i < avs.length; i++){
    double dx = Math.cos(as[i])*ls[i];
    double dy = Math.sin(as[i])*ls[i];
    line((float)px,(float)py,(float)(px+dx),(float)(py+dy));
    px += dx; py += dy;
  }
  
  path[pathi][0] = px;
  path[pathi][1] = py;
  /*
  for (int i = 0; i < path.length-1; i++){
    stroke(color((int)(i*1.99),i,0));
    line((float)path[(i+pathi)%path.length][0],(float)path[(i+pathi)%path.length][1]
    ,(float)path[(1+i+pathi)%path.length][0],(float)path[(1+i+pathi)%path.length][1]);
  }/*/
  for (int i = 0; i < path.length-1; i++){
    set((int)path[(i+pathi)%path.length][0],(int)path[(i+pathi)%path.length][1]
    ,color((int)(i*4*255/path.length),(int)(i*4*128/path.length),0));
  }//*/
  pathi = (pathi+1)%path.length;
  
}
