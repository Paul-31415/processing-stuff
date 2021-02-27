


double[][] state;

double dt = 1d;
int substeps = 16;
double damp = 0.01d;

double speed = 0*1d/16;
double rem=0;
//https://en.wikipedia.org/wiki/Shallow_water_equations
// A(x,t) is area
// u(x,t) is flow
// ζ(x,t) is height
// P(x,t) is wet perimeter of channel
// τ(x,t) is shear stress along P
// ρ is density
// g is gravity
//
//dA/dt = -d(Au)/dx
//du/dt = -P/A * τ/ρ - u du/dx - g dζ/dx
double channel_width = 1d;
double channel_speed = 0*-1d;
double density = 1;
double gravity = 1;
double dx(int i,int j){
  if (i > 0){
      if (i < state[0].length-1){
        return (state[j][i+1]-state[j][i-1])/2;
      }else{
        return state[j][i]-state[j][i-1];
      }
    }else{
      return state[j][i+1]-state[j][i];
    }
}

void update(double dt){
  // [0] is ζ
  // [1] is u
  // [2] is scratch
  //rect channel
  // A = k*ζ
  // P = k+2*ζ
  // τ = damp*u*|u|
  double flt;
  
  
  
  //double[] tmp;// = state[0];
  
  for (int i = 0; i < state[0].length; i++){
    double P = channel_width+2*state[0][i];
    double A = channel_width*state[0][i];
    double tau = (key=='v'?100*damp:damp)*(state[1][i]-channel_speed)*Math.abs(state[1][i]-channel_speed);
    double patr = A==0?0:P/A*tau/density;
    double dudx = dx(i,1);
    double u = state[1][i];
    double dzdx = dx(i,0);
    state[3][i] = state[1][i] - (patr + u*dudx + gravity*dzdx)*dt;
  }
  state[3][0] = channel_speed;
  state[3][state[2].length-1] = channel_speed;
  
  flt = dt*dt;
  state[1][0] = (state[3][0]*(1-flt)+flt*(state[3][1]));
  state[1][state[0].length-1] = (state[3][state[0].length-1]*(1-flt)+flt*(state[3][state[0].length-2]));
  for(int i = 1; i < state[0].length-1;i++){
    double a = Math.min(state[0][i-1],Math.min(state[0][i],state[0][i+1]));
    double cap = a*.25; 
    flt = dt*dt/a;
    state[1][i] = Math.min(cap,Math.max(-cap,(state[3][i]*(1-flt)+flt*(state[3][i-1]+state[3][i+1])/2))); 
  }
  
  for (int i = 0; i < state[0].length; i++){
    double delt;
    if (i > 0){
      if (i < state[0].length-1){
        delt = (state[0][i+1]*state[1][i+1]-state[0][i-1]*state[1][i-1])/2*dt;
      }else{
        delt = (state[0][i]*state[1][i]-state[0][i-1]*state[1][i-1])*dt;
      }
    }else{
      delt = (state[0][i+1]*state[1][i+1]-state[0][i]*state[1][i])*dt;
    }
    
    state[2][i] = Math.max(0,state[0][i]-delt);
  }
  
  flt = dt*dt;
  state[0][0] = (state[2][0]*(1-flt)+flt*(state[2][1]));
  state[0][state[0].length-1] = (state[2][state[0].length-1]*(1-flt)+flt*(state[2][state[0].length-2]));
  for(int i = 1; i < state[0].length-1;i++){
    //flt = state[2][i] *dt*dt;
    state[0][i] = (state[2][i]*(1-flt)+flt*(state[2][i-1]+state[2][i+1])/2);
  }
    
  
  
  
  for (int i = 0; i < state[0].length; i++){
  if (key=='c'){
    state[0][i] = 1;
    state[1][i] = channel_speed;
  }
  if (key=='g'){
    state[0][i] *= 1.01d;
    state[1][i] -= channel_speed;
    state[1][i] *= 1.01d;
    state[1][i] += channel_speed;
  }
  if (key=='h'){
    state[0][i] /= 1.01d;
    state[1][i] -= channel_speed;
    state[1][i] /= 1.01d;
    state[1][i] += channel_speed;
  }
  
  }
  if (key == 'f'){
    state[1][min(state[0].length-1,max(0,mouseX))] += dt*dt;
  }
  if (key == 'F'){
    for (int i = mouseX - mouseY/10; i <= mouseX + mouseY/10;i++){
      double d = 6*(i-mouseX)/(1+mouseY/10);
      state[1][min(state[0].length-1,max(0,i))] += dt*dt;//+Math.exp(-d*d);
    }
  }
  rem += speed;
  if (rem > 1){
    rem -= 1;
    for (int i = 1; i < state[0].length; i++){
      state[1][i-1] = state[1][i] ;
      state[0][i-1] = state[0][i] ;
    }
  }
}

void keyPressed(){
  double s = 100d*mouseY/height;
  if (key == 'd'){
    for (int i = max(0,mouseX - mouseY/10); i <= mouseX + mouseY/10 && i < state[0].length;i++){
      double d = 6*(i-mouseX)/(1+mouseY/10);
      state[0][i] += 1;//+Math.exp(-d*d);
    }
  }
  if (key == 'D'){
    for (int i = max(0,mouseX - mouseY/10); i <= mouseX + mouseY/10 && i < state[0].length;i++){
      double d = 6*(i-mouseX)/(1+mouseY/10);
      state[0][i] *= .75;//+Math.exp(-d*d);
    }
  }
  if (key == 'e'){
    for (int i = max(0,mouseX - (int)(s*5)); i <= mouseX + (int)(s*5) && i < state[0].length;i++){
      double d = (i-mouseX)/s;
      state[1][i] += d*Math.exp(-d*d);
    }
  }
  if (key == 'E'){
    for (int i = max(0,mouseX - (int)(s*5)); i <= mouseX + (int)(s*5) && i < state[0].length;i++){
      double d = (i-mouseX)/s;
      state[1][i] -= d*Math.exp(-d*d);
    }
  }
  if (key == 'w'){
    for (int i = max(0,mouseX - (int)(s*5)); i <= mouseX + (int)(s*5) && i < state[0].length;i++){
      double d = (i-mouseX)/s;
      state[1][i] -= Math.exp(-d*d);
    }
  }
  if (key == 'r'){
    for (int i = max(0,mouseX - (int)(s*5)); i <= mouseX + (int)(s*5) && i < state[0].length;i++){
      double d = (i-mouseX)/s;
      state[1][i] += Math.exp(-d*d);
    }
  }
  if (key == 'W'){
    for (int i = max(0,mouseX - (int)(s*5)); i <= mouseX + (int)(s*5) && i < state[0].length;i++){
      double d = (i-mouseX)/s;
      state[0][i] += Math.exp(-d*d);
      state[1][i] -= Math.exp(-d*d);
    }
  }
  if (key == 'R'){
    for (int i = max(0,mouseX - (int)(s*5)); i <= mouseX + (int)(s*5) && i < state[0].length;i++){
      double d = (i-mouseX)/s;
      state[0][i] += Math.exp(-d*d);
      state[1][i] += Math.exp(-d*d);
    }
  }
}



color col(double i){
  return color((int)(-Math.cos(i)*96+159),
  (int)(-Math.cos(i*Math.sqrt(2))*96+159),
  (int)(Math.cos(i*Math.sqrt(3))*96+159));
}

double offs;
double scale;
int pressX;
int pressY;
void draw(){
  //for (int step = 0; step < 16; step++){
  //background(0,0,0,128);
  
    stroke(color(255,0,0,128));
    double p = 0;
    double xp = mousePressed?pressX:mouseX;
    double yp = mousePressed?pressY:mouseY;
    for(int x = 1; x < state[0].length; x++){
      double ps = 100d*yp/height;
      double dx = x-xp;
      double v = Math.exp(-dx*dx/ps/ps);
      if (mousePressed){
        double pp = .1d*abs(mouseX-pressX);
        double pm = 8d*(mouseY-pressY)/height;
        v *= Math.cos(dx*2*Math.PI/pp)*pm;
      }
      
      line(x-1,(float)(p*scale+offs),x,(float)(v*scale+offs));
      p = v;
    }
  
  noStroke();
  fill(color(0,0,0,128));
  rect(0,0,width,height);
  for(int i = state.length-1; i >= 0; i--){
    stroke(col(i));
    color c = col(i);
    p = state[i][0];
    for(int x = 1; x < state[i].length; x++){
      line(x-1,(float)(p*scale+offs),x,(float)(state[i][x]*scale+offs));
      line(x-1,(float)(p*scale/32+offs),x,(float)(state[i][x]*scale/32+offs));
      p = state[i][x];
      //set(x,(int)(state[i][x]*scale+offs),c);
    }
  }
  for (int step = 0; step < substeps; step++){
  update(dt/substeps);
  }
}




void mousePressed(){
  pressX = mouseX;
  pressY = mouseY;
}

void mouseReleased(){
  double ps = 100d*pressY/height;
  double pp = .1d*abs(mouseX-pressX);
  double pm = 8d*(mouseY-pressY)/height;
  
  for (int x = max(1,(int)(pressX-ps*5)); x < min(state[0].length-1,(int)(pressX+ps*5));x++){
    double dx = x-pressX;
    state[0][x] += Math.cos(dx*2*Math.PI/pp)*Math.exp(-dx*dx/ps/ps)*pm;
  } 
}

void setup(){
  size(1536,512,P2D);
  state = new double[4][width];
  for (int i = 0; i < state[0].length; i++){
    double x = (((double)i)/state[0].length)*2-1;
    state[0][i] = 1+0*Math.sin(x*Math.PI*40)*Math.exp(-40*x*x)*3;
  }
  /*for (int i = -10; i <= 10; i++){ 
  state[width/2+i][0] = (i+10)/20.;
  }
  
  */for (int i = 1; i < width/2; i++){
    state[0][i] = 1;
  }//*/
  //state[128][0] = 1;
  offs = height*3 /4;
  scale = -height/2/8;
  //scale = -1;
}
