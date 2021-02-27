gasVoxel[][] field;
ArrayList<star> stars;


void setup(){
  size(256,256);
  field = new gasVoxel[width][height];
  stars = new ArrayList<star>();
  stars.add(new star(new double[]{64,128},new double[]{0,30},100));
  for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      field[x][y] = new gasVoxel(((x-width/2)*(x-width/2)+(y-height/2)*(y-height/2))<1000?random(16,16):0.1,new double[] {-(x-width/2)*0,-(y-height/2)*0},0.01);
    }
  }
  for(int dir = 0; dir < 2 ; dir++){
    for(int x = 0; x < width ; x++){
      for(int y = 0; y < height ; y++){ 
        field[x][y].setNeighbor(0,dir,field[(x-dir*2+1+width)%width][y]);
      }
    }
  }
  for(int dir = 0; dir < 2 ; dir++){
    for(int x = 0; x < width ; x++){
      for(int y = 0; y < height; y++){ 
        field[x][y].setNeighbor(1,dir,field[x][(y-dir*2+1+height)%height]);
      }
    }
  }
  thread("step");
}
int frameCounter = 0;
void draw(){
  frameCounter++;
  for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      set(x,y,color((int)(field[x][y].content.temp*field[x][y].content.mass),(int)field[x][y].content.mass,(int)field[x][y].content.mass));
    }
  }
  for(int i = 0; i < stars.size() ; i++){
    set((int)stars.get(i).pos[0],(int)stars.get(i).pos[1], color(255));
  }
  
  if (mousePressed){
    field[x][y].newCont.mass += 1;
    field[x][y].newCont.vel[0] += mouseX-x;
    field[x][y].newCont.vel[1] += mouseY-y;
  stroke(128);
  line(x,y,mouseX,mouseY);
  }
  
  if(keyPressed){
    if (key == 'd'){
      for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      int i = hash(x,y,frameCounter);
      set(x,y,color(i^(i+1)));
    }
  }
      
    }
    
    if (key=='h'){
      field[x][y].newCont.temp+=1;
    }
    if (key=='y'){
      field[x][y].newCont.temp+=100;
    }
    if (key=='6'){
      field[x][y].newCont.temp+=1000;
    }
    if (key=='f'){
      field[x][y].newCont.mass += 1;
      field[x][y].newCont.vel[0] += (mouseX-x)*100;
      field[x][y].newCont.vel[1] += (mouseY-y)*100;
    }
    if (key=='m'){
      field[x][y].newCont.mass+=100;
    }
    if (key=='n'){
      field[x][y].newCont.add(new gas(1000,new double[]{mouseX-x,mouseY-y},1));
    }
  }
}

int hash(int... a){
  int r = 0;
  for (int i : a){
    //r ^= i;
    //r = ((r&0x55555555)<<1)+((r&0xAAAAAAAA)>>1);
    r ^= ((i&0x33333333)<<2)+((r&0xCCCCCCCC)>>2);
    r -= ((i&0xC71C71C7)<<3)+((r&0x38E38E38)>>3);
    //r = ((r&0x0F0F0F0F)<<4)+((r&0xF0F0F0F0)>>4);
    r ^= ((i&0xC1F07C1F)<<5)+((r&0x3E0F83E0)>>5);
  }
  return r;
}
double dt = 0.01;
double g = 0.01;
double gThresh = 0.1;
double sgThresh = 0.0000001;
int simFrame = 0;

void step(){
  while(true){
    simFrame++;
    
  double[] p = new double[] {0,0};
  double M = 0;
  for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      field[x][y].next();
      double[] padd = field[x][y].content.p();
      for (int i = 0; i < p.length; i++){
        p[i] += padd[i];
      }
      M += field[x][y].content.mass;
    }
  }
  //print(M);
  //print(' ');
  /*if (M==M){
  for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      for (int i = 0; i < p.length; i++){
        field[x][y].content.vel[i] -= p[i]/M;
      }
    }
  }}*/
  
    
  
  for(int i = 0; i < stars.size() ; i++){
    star s = stars.get(i);
    s.step(dt);
    s.pos[0] %= width;
    s.pos[1] %= height;
    
    //star gravity
    double oldRange = 0;
    double mass = s.mass*dt;
    double range = Math.min(width,Math.sqrt(g*mass/sgThresh));
    //g*m/(r*r) = gThresh, r*r = g*m/thr
    int x = (int)s.pos[0];
    int y = (int)s.pos[1];
    
    
    for(int l = 1; ((l&simFrame) == 0 )&&(range<max(width,height)/2);l<<=1){
      
      

      for(int dx = (int)-range; dx < range ; dx++){
        for(int dy = (int)-range; dy < range ; dy++){
          int mag2 = (dx*dx+dy*dy);
          if(mag2<range*range && oldRange*oldRange<mag2){
            double[] v = field[(x+dx+width)%width][(y+dy+height)%height].newCont.vel;
            double m = field[(x+dx+width)%width][(y+dy+height)%height].content.mass;
            double d = g/(Math.sqrt(mag2)*mag2);
            v[0] -= mass*dx;
            v[1] -= mass*dy;
            //f = ma
            // a/m = f
            //a = f/m
            s.vel[0] += m*d*dx;
            s.vel[1] += m*d*dy;
            
          }
        }
      }
      oldRange = range;
      range *= Math.sqrt(2);
      mass *= 2;
      }
      
  }
  //gravity
  
  for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      double oldRange = 0;
      double mass = field[x][y].content.mass*dt;
      double range = Math.min(width,Math.sqrt(g*mass/gThresh));
      for(int l = 1; ((l&simFrame) == 0 )&&(range<max(width,height)/2);l<<=1){
      //g*m/(r*r) = gThresh, r*r = g*m/thr
       
      for(int dx = (int)-range; dx <= range ; dx++){
        for(int dy = (int)-range; dy <= range ; dy++){
          int mag2 = (dx*dx+dy*dy);
          if( mag2<range*range && oldRange*oldRange<mag2){
            gasVoxel b = field[(x+dx+width)%width][(y+dy+height)%height];
            double m = b.content.mass;
            double d = g/(Math.sqrt(mag2)*mag2);
            //m1m2
            b.newCont.vel[0] -= d*mass*dx;
            b.newCont.vel[1] -= d*mass*dy;
            // i = m*mass*d
            //f = ma
            // a/m = f
            //a = f/m
            //field[x][y].newCont.vel[0] += m*d*dx;
            //field[x][y].newCont.vel[1] += m*d*dy;
            
            //b.newCont.setTo(b.content);
            //field[x][y].newCont.setTo(field[x][y].content);
            
            assert (d==d);
              
            
          }
        }
      }
      oldRange = range;
      range *= Math.sqrt(2);
      mass *= 2;
      }
    }
  }
   //for(int x = 0; x < width ; x++){
    //for(int y = 0; y < height ; y++){
     // field[x][y].next();
    //}
   //}
  
  for(int x = 0; x < width ; x++){
    for(int y = 0; y < height ; y++){
      field[x][y].send(dt);
    }
  }
}}


int x;
int y;
void mousePressed(){
  x = mouseX;
  y = mouseY;
}
/*
void mouseReleased(){
  field[x][y].density += 255;
  field[x][y].vel[0] += mouseX-x;
  field[x][y].vel[1] += mouseY-y;
}
*/
