void setup(){
  size(512,256);
  background(64);
  
}


double bar = 1;
boolean attacked = true;
float rumble = 0;
int last_damage = 0;
void draw(){
  background(63+rumble*rumble/6);
  if (attacked)
   fill(color((int)(255-bar*255),(int)(bar*255*(1.5-bar)/.6),(int)(255*bar)));
  else
   fill(color((int)(255-bar*bar*255),(int)(bar*bar*bar*255/.1*(1-bar)),(int)(64*(1-bar)*bar/.25)));
   
  double attackpower = bar*bar*bar*(1-bar)/.1;
  
  float rx = random(rumble)-rumble/2;
  float ry = random(rumble)-rumble/2;
  rect(64+rx,64+ry,(float)(bar*(512-128)),64);
  rumble *= .875;
  
  fill(color(255,0,0));
  text(last_damage,64+rx,192+ry);
  fill(color(255,128,0));
  if (!attacked)
  text((int)(attackpower*1000),192+rx,192+ry);
  
  if (!attacked){
    bar = (bar-.3)*.99+.3;
    if (mousePressed){
      attacked = true;
      
      attackpower *= attackpower; //make the peak sharper
      last_damage = (int)(attackpower*1000);
      rumble = (float)(32*attackpower);
      background(192);
      bar = 0;
    }
  }else{
    bar += .01;
    if (bar >= 1){
      bar = 1;
      attacked = false;
    }
  }
}
