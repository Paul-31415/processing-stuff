




int oldX = 0;
int oldY = 0;
int iter = 512;

double shiftX = 0;
double shiftY = 0;
double scaleX = 2;
double scaleY = 2;

PImage bg;

int MINDIM;

void setup()
{
  size(1500,1000);
  MINDIM = (int)(min(width,height)/2);
  background(196,255,128);
  for(int x = 0;x<width;x++)
  {
   for(int y = 0; y < height; y++)
   {
  double imagC = shiftX + scaleX * ((double)(y - height/2)/MINDIM);
  double realC =  shiftY + scaleY * ((double)(x - width/2)/MINDIM);
  
 double imagZ = imagC;
  double realZ = realC;
  
  int bailoutIters = -1;
  
  for(int h = 0; h<iter; h ++ )
  {
    if( realZ * realZ + imagZ * imagZ > 4)
    {
       bailoutIters = h;
       break; 
    }
    double tmpRZ = realZ * realZ - imagZ * imagZ + realC;
    imagZ = imagZ * realZ * 2 + imagC;
    realZ = tmpRZ;
  }
  if(bailoutIters < 0)
  {
    stroke(0,0,0);
  }else{
    stroke(128-(sin((float)bailoutIters/11)*96),128-(sin((float)bailoutIters/13)*96),128-(sin((float)bailoutIters/17)*96));
  }
  rect(x,y,0,0);
   }
  }
  bg = get();
  
  
}




void draw()
{
  if(mousePressed && (mouseButton == LEFT))
  {
    //iter = (int) (iter + 0.125 * iter);
    //println(iter);

    shiftX +=  scaleX * ((double)(mouseX - width/2)/MINDIM);
    shiftY +=   scaleY * ((double)(mouseY - height/2)/MINDIM);
    scaleX *= 0.5;
    scaleY *= 0.5;
  for(int x = 0;x<width;x++)
  {
   for(int y = 0; y < height; y++)
   {
  double imagC = shiftY + scaleY * ((double)(y - height/2)/MINDIM);
  double realC =  shiftX + scaleX * ((double)(x - width/2)/MINDIM);
  
 double imagZ = imagC;
  double realZ = realC;
  
  int bailoutIters = -1;
  
  for(int h = 0; h<iter; h ++ )
  {
    if( realZ * realZ + imagZ * imagZ > 4)
    {
       bailoutIters = h;
       break; 
    }
    double tmpRZ = realZ * realZ - imagZ * imagZ + realC;
    imagZ = imagZ * realZ * 2 + imagC;
    realZ = tmpRZ;
  }
  if(bailoutIters < 0)
  {
    stroke(0,0,0);
  }else{
    stroke(128-(sin((float)bailoutIters/11)*96),128-(sin((float)bailoutIters/13)*96),128-(sin((float)bailoutIters/17)*96));
  }
  rect(x,y,0,0);
   }
  }
  bg = get();
  }else if(((mouseX - pmouseX) != 0) || (0 != ( mouseY - pmouseY)))
  {

  /*
  if (mousePressed)
  {
    background(128,196,255);
  }
  */
  image(bg,0,0);
  int x = mouseX;
  int y = mouseY;
  double imagC = shiftY + scaleY * ((double)(y - height/2)/MINDIM);
  double realC =  shiftX + scaleX * ((double)(x - width/2)/MINDIM);
  
 double imagZ = imagC;
  double realZ = realC;
  
  int bailoutIters = -1;
  
  for(int h = 0; h<iter; h ++ )
  {
    if( realZ * realZ + imagZ * imagZ > 4)
    {
       bailoutIters = h;
       break; 
    }
    double oldRZ = width/2+MINDIM*(realZ-shiftX)/scaleX;
    double oldIZ = height/2+MINDIM*(imagZ-shiftY)/scaleY;
    double nsOldRZ = width/2+MINDIM*(realZ)/2;
    double nsOldIZ = height/2+MINDIM*(imagZ)/2;
    double tmpRZ = realZ * realZ - imagZ * imagZ + realC;
    imagZ = imagZ * realZ * 2 + imagC;
    realZ = tmpRZ;
    double nsNewRZ = width/2+MINDIM*(realZ)/2;
    double nsNewIZ = height/2+MINDIM*(imagZ)/2;
    double newRZ = width/2+MINDIM*(realZ-shiftX)/scaleX;
    double newIZ = height/2+MINDIM*(imagZ-shiftY)/scaleY;
    stroke(160-(sin((float)h/11)*96),160-(sin((float)h/13)*96),160-(sin((float)h/17)*96));
    line((float) oldRZ,(float) oldIZ,(float) newRZ,(float) newIZ);
    //line((float) nsOldRZ,(float) nsOldIZ,(float) nsNewRZ,(float) nsNewIZ);

  }
  if(bailoutIters < 0)
  {
    stroke(0,0,0);
  }else{
    stroke(128-(sin((float)bailoutIters/11)*96),128-(sin((float)bailoutIters/13)*96),128-(sin((float)bailoutIters/17)*96));
  }
  rect(x,y,0,0);
  
  }else if (keyPressed && (key == 'p')){}
    
  /*
  line(mouseX,mouseY,oldX,oldY);
  oldX = mouseX;
  oldY = mouseY;
  */
}