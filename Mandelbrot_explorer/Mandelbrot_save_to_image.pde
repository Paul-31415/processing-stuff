private ComplexDouble getPoint(int x,int y,double shiftX, double shiftY, double scaleX, double scaleY,int pictWidth, int pictHeight)
{
  int minDim = (min(pictWidth,pictHeight)/2);
  return new ComplexDouble( shiftX + scaleX * ((double)(x -  pictWidth/2)/minDim),
                             shiftY + scaleY * ((double)(y - pictHeight/2)/minDim));
}

public color getColor(double depth)
{
  if (depth < 0)
  {
    return color(0,0,0);
  }else{
    float r = 128-(sin((float)depth/11)*96);
    float g = 128-(sin((float)depth/13)*96);
    float b = 128-(sin((float)depth/17)*96);
    return color(r,g,b);
  }
}
/*
public PImage CalcScreen(double xscale, double yscale, double xoffset, double yoffset, int iter,int xDim, int yDim)
{
  ComplexDouble point = new ComplexDouble();
  PImage pict;
  pict = createImage(xDim,yDim,RGB);
  pict.loadPixels();
  int index = 0;
  for(int y = 0; y < yDim; y++)
   {
  for(int x = 0;x<xDim;x++)
  {
   
    point = getPoint(x,y,xoffset,yoffset,xscale,yscale,xDim,yDim);
        
    int i = testPoint(point,iter);

    pict.pixels[index] = getColor((double) i);
    if (index % ((xDim*yDim)/100) == 0)
    {
      println( (100 * index)/(xDim*yDim) + "%");
      text((100 * index)/(xDim*yDim) + "%",0,0);
    }
    index ++;
   }
  }
  return pict;
}*/
