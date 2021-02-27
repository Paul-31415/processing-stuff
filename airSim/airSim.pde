AirPx[][] air;
ArrayList<Ion> ions = new ArrayList<Ion>();


double g = 0.008;
int cpf = 16; 
int ipa = 0;
double efact = 1;
double qe = 0.01*efact;
double afe = 0.01*efact;
double ape = 0.001*efact;
double ade = 0.001*efact;
int cMode = 1;


void setup()
{
  size(128,128);
  background(255);
  air = new AirPx[width][height];
  for (int x=0; x < width; x++){
    for (int y=0; y < height; y++){
      air[x][y] = new AirPx(3*exp((float)((y-height)*g)),300,new double[] {0,0,0,0});
    }
  }
  frameRate(1024);
  //air[64][64].newDensity = 32;
  //thread("doAirRepeat");
  //thread("doAirRepeat");
}




void dampFlow(AirPx a, double amount){
  for(int i = 0; i < a.flow.length ; i ++)
    a.newFlow[i] *= amount;
}


void doAir(){
  for (int x=0; x < width; x++){
    for (int y=0; y < height; y++){
      //flow
      if(x < width - 1)
        air[x][y].move(air[x+1][y],air[x][y].flow[0] * afe);
      else{
        air[x][y].newFlow[2] += air[x][y].flow[0] * afe/2;
        air[x][y].newFlow[3] += air[x][y].flow[0] * afe/2;
        air[x][y].newFlow[0] -= air[x][y].flow[0] * afe;
      }
      if(x > 0)
        air[x][y].move(air[x-1][y],air[x][y].flow[1] * afe);
      else{
        air[x][y].newFlow[2] += air[x][y].flow[1] * afe/2;
        air[x][y].newFlow[3] += air[x][y].flow[1] * afe/2;
        air[x][y].newFlow[1] -= air[x][y].flow[1] * afe;
      }
      if(y < height - 1)
        air[x][y].move(air[x][y+1],air[x][y].flow[2] * afe);
      else{
        air[x][y].newFlow[0] += air[x][y].flow[2] * afe/2;
        air[x][y].newFlow[1] += air[x][y].flow[2] * afe/2;
        air[x][y].newFlow[2] -= air[x][y].flow[2] * afe;
      }
      if(y > 0)
        air[x][y].move(air[x][y-1],air[x][y].flow[3] * afe);
      else{
        air[x][y].newFlow[0] += air[x][y].flow[3] * afe/2;
        air[x][y].newFlow[1] += air[x][y].flow[3] * afe/2;
        air[x][y].newFlow[3] -= air[x][y].flow[3] * afe;
      }
      
      // pressure    flowx += dp/dx
      if(x < width - 1)
        air[x][y].newFlow[0] += ( air[x][y].pressure() - air[x+1][y].pressure() ) * ape;
      if(x > 0)
        air[x][y].newFlow[1] += ( air[x][y].pressure() - air[x-1][y].pressure() ) * ape;
      if(y < height - 1)
        air[x][y].newFlow[2] += ( air[x][y].pressure() - air[x][y+1].pressure() ) * ape;
      if(y > 0)
        air[x][y].newFlow[3] += ( air[x][y].pressure() - air[x][y-1].pressure() ) * ape;
      //gravity f = mg
      if (g > 0)
        if(y < height - 1)
          air[x][y].newFlow[2] += g*air[x][y].density;
      if (g < 0)
        if(y > 0)
          air[x][y].newFlow[3] -= g*air[x][y].density;
      
      
    }
  }
  for (int x=0; x < width; x++){
    for (int y=0; y < height; y++){
      air[x][y].update((float)afe * 10);
      dampFlow(air[x][y],1-ade);
      air[x][y].update((float)afe * 10);
    }
  }
}

double p = 0.0001;
double ien = 0.000001;
double iv = 0.01;


void doIons(){
  for(int i = 0; i < ions.size() ; i++){
    ions.get(i).addVel();
    if (ions.get(i).pos[0] < 0 || ions.get(i).pos[1] < 0 || ions.get(i).pos[0] > width-1 || ions.get(i).pos[1] > height-1){
      ions.remove(i);
      i --;
      
    }else{
    ions.get(i).vel[0] += p*ions.get(i).charge/ions.get(i).mass;
    int x = (int)(ions.get(i).pos[0]);
    int y = (int)(ions.get(i).pos[1]);
    set(x,y,color(0,0,255));
    if(Math.random() > pow( 0.9999   ,(float)(air[x][y].density * ions.get(i).velR()))){
      //interact
      Ion s = ions.remove(i);
      i --;
      if(s.energy() > ien){
        
        int c = 0;
        for (int n = 0 ; n < sqrt((float)(s.energy()/ien)) ; n ++){
          
           
          double[] pos = new double[s.pos.length];
          for(int p = 0; p < pos.length ; p++)
            pos[p] = s.pos[p];
          ions.add(new Ion(pos,new double[] {(Math.random()-0.5)*iv,(Math.random()-0.5)*iv},-1,1));
          
          
          c++;
        }
        ions.add(new Ion(s.pos,new double[] {0,0.0001},c,16));
      }
    }
    }
    
  }
}

void doAirRepeat(){
  while(true)
    doAir();
}

void draw()
{
  for (int x=0; x < width; x++){
    for (int y=0; y < height; y++){
      set(x,y,air[x][y].Color(cMode));
    }
  }
  //air[64][64].newDensity = 3;

  //for( int i = 0; i < cpf ; i ++){
    doAir();
    //for( int j = 0; j < ipa ; j ++)
     // doIons();
    
    if (mousePressed){
      if(mouseButton == 37){
      //air[(int)(mouseX)][(int)(mouseY)].newTemp *= 2;
      
      air[(int)(mouseX)][(int)(mouseY)].newTemp += 200;
      air[(int)(mouseX)][(int)(mouseY)].newDensity /= 1;
      //air[(int)(mouseX)][(int)(mouseY)].newFlow[0] += 100;
      }else{
      
      air[(int)(mouseX)][(int)(mouseY)].newTemp /= 1;
      air[(int)(mouseX)][(int)(mouseY)].newDensity += 10;
      //air[(int)(mouseX)][(int)(mouseY)].newDensity = 00;/**/
      //ions.add(new Ion(new double[] {mouseX,mouseY},new double[] {0,0},-1,1));
    }
    
  }
  if(keyPressed){
    if (key == 'v')
      air[mouseX][mouseY].flow[0] += 100;
    if (key == 'b'){
      air[(int)(mouseX)][(int)(mouseY)].newTemp += 5000;
      air[(int)(mouseX)][(int)(mouseY)].newDensity += 200;
    }
    if (key == 'g'){
      air[(int)(mouseX)][(int)(mouseY)].newTemp = 0;
      air[(int)(mouseX)][(int)(mouseY)].newDensity += 2000;
    }
    if (key == 'd'){
      //air[(int)(mouseX)][(int)(mouseY)].newTemp = ;
      air[(int)(mouseX)][(int)(mouseY)].newDensity = 0;
    }
    if (key == 'x'){
      air[(int)(mouseX)][(int)(mouseY)].newTemp /= 1.1;
    }
      
    if (key == 'c')
      for (int x=0; x < width; x++){
        for (int y=0; y < height; y++){
          air[x][y].newTemp /= 1.05;
        }
      }
     if (key == 'h')
      for (int x=0; x < width; x++){
        for (int y=0; y < height; y++){
          air[x][y].newTemp *= 1.05;
        }
      }
     if (key == 'z')
      for (int x=0; x < width; x++){
        for (int y=0; y < height; y++){
          air[x][y].newDensity /= 1.05;
        }
      }
    
    
    
    
  }
  
  
  //println(air[64][64].density,air[64][64].temp,air[64][64].flow[0],air[64][64].flow[1],air[64][64].flow[2],air[64][64].flow[3]);
  
  
}

void keyPressed(){
  if (key == 'f')
    g = -g;
}
