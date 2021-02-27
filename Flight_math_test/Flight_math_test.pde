/*
radial function for drag in direction








*/




void setup()
{
  size(480,480);
  background(255);
  colorMode(RGB,255,255,255,255);
}
double[] pos = {width/2,height/2};
double vel = 0 
double vel

void draw()
{
  
  
  
}

/*
double[] pos = {width/2,height/2};
double theta = 0;
double vTheta = 0;
double[] vel = {0,0};
double drag = 0.99;
double dragMul = 0.05;
double angularDrag = 0.8;
double dir = 0.125;
double pushback = 0.021;
double eff = 0.25;
double grav = -0.098;
double fDrag(double theta)
{
  //return 0;
  return  drag + 2*(1-Math.cos(theta));
}
double dFDrag(double theta)
{
  //return 0;
  return 2*(Math.sin(theta));
  
  
}
void draw()
{
  /*
  double tmp = vel[1] * Math.cos(theta)-vel[0] * Math.sin(theta);
  vel[0] = vel[0]*drag + dir*tmp*Math.sin(theta) + dir*eff*tmp*Math.cos(theta);
  vel[1] = vel[1]*drag - dir*tmp*Math.cos(theta) + dir*eff*tmp*Math.sin(theta) - grav;
  
  tmp = (Math.atan2(vel[1],vel[0]) - theta)%(Math.PI/2);
  vTheta = vTheta * angularDrag + pushback * tmp * Math.cos(tmp) * (vel[0] * vel[0] + vel[1] * vel[1]);
  /
  double dTheta =  (vel[1] - theta)%(Math.PI);
  vTheta = vTheta * angularDrag + pushback * dFDrag(dTheta);
  
  vel[0] *= drag - dragMul*fDrag(dTheta); 
  vel[1] -= dir * dFDrag(dTheta);
  
  double tmp = Math.atan2(vel[0]*Math.sin(vel[1]) - grav,vel[0]*Math.cos(vel[1]));
  vel[1] =     Math.sqrt((vel[0]*Math.sin(vel[1]) - grav)*(vel[0]*Math.sin(vel[1]) - grav)+(vel[0]*Math.cos(vel[1]))*(vel[0]*Math.cos(vel[1])));
  vel[0] = tmp;
  
  theta = (theta + vTheta)%(2*Math.PI);
  pos[0] = (pos[0] + vel[0]*Math.cos(vel[1]) + width)%width;
  pos[1] = (pos[1] + vel[0]*Math.sin(vel[1]) + height)%height;
  
  background(255,255,255);
  stroke((int)(throttle*128),0,0);
  if (throttle == 0)
    stroke(0,0,64);
  line((float)(pos[0] + 10*Math.cos(theta)),(float)(pos[1] + 10*Math.sin(theta)),(float)(pos[0] - 10*Math.cos(theta+0.1)),(float)(pos[1] - 10*Math.sin(theta+0.1)));
  line((float)(pos[0] + 10*Math.cos(theta)),(float)(pos[1] + 10*Math.sin(theta)),(float)(pos[0] - 10*Math.cos(theta-0.1)),(float)(pos[1] - 10*Math.sin(theta-0.1)));

  if (keyPressed)
  {
  if (key == 'w')
  {
     tmp = Math.atan2(vel[0]*Math.sin(vel[1]) + thrust*Math.sin(theta),vel[0]*Math.cos(vel[1]) + thrust*Math.cos(theta));
  vel[1] =     Math.sqrt((vel[0]*Math.sin(vel[1]) + thrust*Math.sin(theta))*(vel[0]*Math.sin(vel[1]) + thrust*Math.sin(theta))+(vel[0]*Math.cos(vel[1]) + thrust*Math.cos(theta))*(vel[0]*Math.cos(vel[1]) + thrust*Math.cos(theta)));
  vel[0] = tmp;
    
  }else if(key == 'd'){
     vTheta += angularThrust * (1 + Math.sqrt(vel[0] * vel[0] + vel[1] * vel[1]));
  }else if(key == 'a'){
     vTheta -= angularThrust * (1 + Math.sqrt(vel[0] * vel[0] + vel[1] * vel[1]));
  }else if(key == 'q'){
    throttle = Math.min(throttle + 0.01, 1);
  }else if(key == 'e'){
       throttle = Math.max(throttle - 0.01, 0);
  }

  

  }
  
     tmp = Math.atan2(vel[1]*Math.sin(vel[0]) + throttle*thrust*Math.sin(theta),vel[0]*Math.cos(vel[1]) + throttle*thrust*Math.cos(theta));
  vel[1] =     Math.sqrt((vel[1]*Math.sin(vel[0]) + throttle*thrust*Math.sin(theta))*(vel[0]*Math.sin(vel[1]) + throttle*thrust*Math.sin(theta))+(vel[0]*Math.cos(vel[1]) + throttle*thrust*Math.cos(theta))*(vel[0]*Math.cos(vel[1]) + throttle*thrust*Math.cos(theta)));
  vel[0] = tmp;
  
}
double throttle = 0;

double thrust = 0.2;
double angularThrust = 0.025;
/*
void keyPressed()
{
  if (key == 'w')
  {
    vel[0] += thrust * Math.cos(theta);
    vel[1] += thrust * Math.sin(theta);
    
  }else if(key == 'd'){
     vTheta += angularThrust * (1 + Math.sqrt(vel[0] * vel[0] + vel[1] * vel[1]));
  }else if(key == 'a'){
     vTheta -= angularThrust * (1 + Math.sqrt(vel[0] * vel[0] + vel[1] * vel[1]));
  }
}



*/