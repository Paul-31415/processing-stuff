

boolean paused = false;
int lifeType = 0;
int[][] colors = {{0,0,0}};
PImage bg; 

void setup()
{
  size(640,480);
  background(255);
}

void mouseClicked()
{
  if (mouseButton == LEFT)
  {
    stroke(colors[lifeType][0],colors[lifeType][1],colors[lifeType][2]);
    rect(mouseX,mouseY,0,0);
  }else{
    stroke(255,255,255);
    rect(mouseX,mouseY,0,0);
  }
}
void keyPressed()
{
  if (key == ' ' || key == ' ')
  {
       paused = !paused;
  }
}
void draw()
{
  bg = get();
  loadPixels();
  for ( int i  = 0 ; i < width * height; i++)
  {
    doRule(i);
  }
  updatePixels();
}
void doRule(int i)
{
  int acc = 0;
  for (int y = -1 ; i <= 1; i ++)
  {
   for (int x = -1 ; i <= 1; i ++)
    {
      if (pixels[(int) ((i+ width*y + x + width)%width + height * Math.floor((i+ width*y + x)/ width))] != color(255))
      {
        acc ++;
      }
    }
  }
  if (acc == 1)
  {
    bg.pixels[i] = color(0);
  }else{
    bg.pixels[i] = color(255);
  }
}