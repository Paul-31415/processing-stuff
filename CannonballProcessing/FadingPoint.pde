public class FadingPoint
{
  private int life;
  private float x;
  private float y;
  private float size;
  private float maxLife;
  
  public FadingPoint(float x,float y, int life, float size)
  {
    this.x = x;
    this.y = y;
    this.life = life;
    this.maxLife = life;
    this.size = size;
  }
  
  public boolean draw()
  {
    if (life < 0 )
      return false;
    
    ellipse(x,y,size*(life/maxSize),size*(life/maxSize));
    life --;
    return true;
  }
  
}