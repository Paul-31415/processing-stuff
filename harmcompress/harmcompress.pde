


int l = 20;
float[] mags;
float[] phases;
float mm;
float[] h;
float[] pg;
float[] pgd;
int over = 1;
void setup(){
  size(800,500,P2D);
  mags = new float[l];
  phases = new float[l];
  pg = new float[l];
  pgd = new float[l];
  h = new float[l];
  for (int i = 1; i <= l; i++){
    mags[i-1] = 0.25/sqrt(i);
    float fn = ((float)i)/l;
    //p_k = p_1 - 2pi sum(j=1...k-1,(k-j)(a_j^2)) for k = 2...K
    float pr = 0; 
    for (int j = 1; j < i; j++)
      pr += mags[j]*mags[j]*(i-j);
    phases[i-1] = pow(fn,.5);//pr/i;//(i%4)/4.-.25;//pr*i;
    h[i-1] = 1./256;
    pgd[i-1] = .01*pow(fn,.9); 
  }
  
  background(0);
  float[] pp = dw(color(255,255,255));
  mm = pp[0]-pp[1];
}


float[] dw(color c){

  float Mm = 0;
  float mm = 0;
  for (int xi = 0 ; xi < width*over; xi++){
    float x = 1.*xi/width/over;
    float v = 0;
    float vs = 0;
    for (int i = 0; i < l; i++){
      v += cos((x+phases[i])*(PI*2*(i+1)))*mags[i];
      vs += sin((x+phases[i])*(PI*2*(i+1)))*mags[i];
    }
    set(xi/over,(int)(((v+2)/4)*height),c);
    set(xi/over,(int)(((vs+2)/4)*height),c);
    float m2 = v*v+vs*vs;
    if (m2>Mm)
      Mm = m2;
    //if (v<mm)
    //  mm = v;
  }
  return new float[]{Mm,mm};
}

int which = 0;
int n = 4;


void draw(){
  background(0);
  for (int i = 0; i< n; i++){
    //float[] np = new float[l];
    //for (int p = 0; p < l; p++)
    //  np[p] = (phases[p]+randomGaussian()*h)%1;
    /*float op = phases[which];
    phases[which] = (op+randomGaussian()*h[which])%1;;*/
    float[] opg = pg;
    pg = new float[l];
    for (int p = 0; p < l; p++){
      pg[p] = (opg[p]+pgd[p]);
    }
    float[] op = phases;
    phases = pg;
    float[] pp = dw(color(255/4,255/4,0,64));
    float nm = pp[0]-pp[1];
    if (nm < mm){
      mm = nm;h[which]*=1.5;}
    else
      {phases = op;h[which]*=63.d/64;}
  }
  which = (which + 1)%l;
  float[] pp = dw(color(255,255,255));
  stroke(color(255,255,255,64));
  line(0,(((pp[0]+2)/4)*height),width,(((pp[0]+2)/4)*height));
  line(0,(((pp[1]+2)/4)*height),width,(((pp[1]+2)/4)*height));
}
