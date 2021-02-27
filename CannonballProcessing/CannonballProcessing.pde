


void setup()
{  size(400,400);
  background(255);
}


ArrayList<Cannonball> balls = new ArrayList<Cannonball>();
ArrayList<FadingPoint> pts  = new ArrayList<FadingPoint>();

double res = 0.01;
void draw()
{
  for (Cannonball c : balls)
  {
    c.move(res);
    c.draw();
    
  }
  
  for (int i= 0; i<pts.size() ;i++)
  {
    if (!pts.get(i).draw())
      {
        pts.remove(i);
        i--;
      }
  }
  
  
}