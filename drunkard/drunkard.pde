

void setup()
{
  size(640,480);
  background(255);
  colorMode(RGB,255,255,255,255);
}

int x = width/2;
int y = height/2;
boolean halt = false;
int iter = 1;
void draw()
{
  background(255,12);
  for (int i = 0; i < 1000; i++)
  {
  int dir = (int) random(0,4);
  if (dir < 2)
  {
    x += 1 - 2*(dir%2);
  }else{
    y += 1 - 2*(dir%2);
  }
  setColor(iter);
  rect(Math.abs(x%width),Math.abs(y%height),0,0);
  
  iter++;
  
  }
  
 
}


public void setColor(double depth)
{
  if (depth < 0)
  {
    stroke(0,0,0);
  }else{
    float r = 128-(sin((float)depth/11)*96);
    float g = 128-(sin((float)depth/13)*96);
    float b = 128-(sin((float)depth/17)*96);
    stroke(r,g,b);
  }
}