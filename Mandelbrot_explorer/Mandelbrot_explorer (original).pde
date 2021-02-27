





int iter = 8;//2048;
int pathSect = 16;
int sect = 256;

num BAILOUT = new fix(4);

cn shift = new cn((num)new fix(0),(num)new fix(0));
cn scale = new cn((num)new fix(2),(num)new fix(2));

int imageSizeX = 12288;
int imageSizeY = 8192;

num zoom =new fix(0.5);

PImage bg;

int MINDIM;

public cn doStep(cn c, cn z,int inum)
{
  //return z.prod(c.mulInverse().sum(z.sum(c).mulInverse())).sum(c); // bailout 16 // c 
  //return z.realPow(new fix(1.5)).sum(c.prod(z.mulInverse()));//foam
  return z.prod(z).sum(c.prod(z.mulInverse()));//foam
  //return z.prod(z,z).sum(c.prod(z.mulInverse()));//foam
  //return z.prod(z,z,z,z,z,z).sum(c.prod(z.mulInverse()));//foam
  //return z.intPow(inum/32+2).sum(c.prod(z.mulInverse()));//foam
  //return z.intPow(inum%4+2).sum(c.prod(z.mulInverse()));//
  //return z.prod(z).sum(c);//mandelbrot
  //return z.intPow(inum/32+2).sum(c);//
  
  //return z.intPow(1112).sum(c);//
  //return z.prod(z,z,z,z).sum(z.prod(z,z,c.mulInverse()),c);
  //return z.pow(z).prod(c.mulInverse()).sum(z.conj(),c);//ferns
  //return z.pow(z.sum(c)).prod(c.mulInverse()).sum(z.conj(),c,c.prod(z.mulInverse()));//flow //<>//
  //return c.pow(z).prod(z.mulInverse()).sum(z);//stress field
  //return c.sum(c.prod(z,c.conj().mulInverse()));//stars
  //return c.prod(c.pow(z.conj()),z,z).sum(z.prod(c.conj().pow(c.prod(z,c.mulInverse().sum(z,c.conj(),z.mulInverse())))),c);//mirror eddies
  //return z.prod(z.sum(c)).sum(c,z.prod(c));//square mandel
  //return z.sum(c).pow(z.prod(c));//sharp flint
  //return new ComplexDouble((z.prod(z).imag-c.imag)%2,(z.prod(z).real-c.real)%2);//mandelbar mod
  //return new ComplexDouble((z.prod(z).sum(c).real)%2,(z.prod(z).sum(c).imag)%2);//mandelmod
  //return new ComplexDouble((z.prod(z).sum(c).real)%( 2 / (z.imag * c.real)),(z.prod(z).sum(c).imag)%( 2 / (z.real * c.imag)));//mandelmod2
  //return z.conj().prod(z.conj()).sum(c);// mandelbar   
}








public float[] getCoords(cn point)
{
  return new float[] { width* (1+2*(point.real.sub(shift.real).div(scale.real).toFloat())),
                       height*(1+2*(point.imag.sub(shift.imag).div(scale.imag).toFloat()))};
}

public float[] getCoords(cn point,boolean defaultWindow)
{
  if(defaultWindow)
  {
    return new float[] { width* (1+2*(point.real.toFloat())),
                       height*(1+2*(point.imag.toFloat()))};
  }else{
    return getCoords(point);
  }
}

public cn getPoint(int x,int y)
{
  cn r = shift.sum(scale.getPoint((x -  width/2)/MINDIM,(y -  height/2)/MINDIM));
  return r;
  //return r.sum(r.prod(new ComplexDouble(4,-2)).mulInverse());
  //return r.sum(r.prod(new ComplexDouble(1)).mulInverse());
  //return r.sum(r.prod(new ComplexDouble(2)).mulInverse());
  //return r.sum(r.prod(new ComplexDouble(-2)).mulInverse());
  //return r.prod((new ComplexDouble(log((float)r.r()),r.theta())));
}

public int testPoint(cn point, int iterations)
{
  int bailout = -1;
  cn z = point.sum();
  for (int i = 0; i < iterations; i++)
  {
    if ( z.bailout(BAILOUT) ) 
    {
      bailout = i;
      break;
    }
    z = doStep(point,z,i);
  }
  return bailout;
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

public int drawPath(int[] coords, int iterations)
{
  int bailout = -1;
  cn z = getPoint(coords[0],coords[1]);
  cn c = getPoint(coords[0],coords[1]);
  for (int i = 0; i < iterations; i++)
  {
    setColor(i);
    
    float[] oldCoords = getCoords(z);
    if ( z.bailout(BAILOUT) ) 
    {
      bailout = i;
      break;
    }
    z = doStep(c,z,i);
    float[] newCoords = getCoords(z);
    line(oldCoords[0],oldCoords[1],newCoords[0],newCoords[1]);
  }
  return bailout;
}


boolean pathMode = false;
int pathIndex = 0;
cn pathZ =  shift.sum();
cn pathC =  shift.sum();
public void contPath(int n)
{
  for(int i = 0 ; i < n ; i++)
  {
    if(pathZ.abs2().lt(BAILOUT))
    {
      
      setColor(pathIndex);
      float[] oldCoords = getCoords(pathZ,pathMode);
      pathZ = doStep(pathC,pathZ,pathIndex);
      float[] newCoords = getCoords(pathZ,pathMode);
      line(oldCoords[0],oldCoords[1],newCoords[0],newCoords[1]);
      pathIndex ++;
    }
  }
}

public void plotRow(int y, int iter)
{
  cn point;
  for(int x = 0;x<width;x++)
  {
    point = getPoint(x,y);
    int i = testPoint(point,iter);
    setColor((double) i);
    rect(x,y,0,0);
  }
}
public void plotCol(int x, int iter)
{
  cn point;
  for(int y = 0;y<height;y++)
  {
    point = getPoint(x,y);
    int i = testPoint(point,iter);
    setColor((double) i);
    rect(x,y,0,0);
  }
}



public void plotScreen( int iter)
{
  cn point;
  for(int ix = 0;ix<width;ix++)
  {
    int x = (width/2)+((ix%2==0)?ix/2:-(ix+1)/2);
   for(int y = 0; y < height; y++)
   {
    point = getPoint(x,y);
        
    int i = testPoint(point,iter);

    setColor((double) i);
    rect(x,y,0,0);
   }
  }
}
  
  



void setup()
{
  //fullScreen();
  
  //prec =- 32;
  print(new fix(2).pow(new fix(8)));
  //print("\nAAA");
  //print(sin((float)(consts[0].div(new fix(6)).toDouble())));
  //print("\n!@WERF");
  //print((consts[0].div(new fix(6)).toDouble()));
  size(1024,768);
  MINDIM = (int)(min(width,height)/2);
  //plotScreen(1);
  bg = get();
}


void mouseClicked()
  {
    //iter = (int) (iter + 0.125 * iter);
    //println(iter);
    if(mouseButton == RIGHT)
    {
      zoom = zoom.mulInverse();
    }
    background(255,255,255);
    imageMode(CENTER);
    image(bg, width/2 - (mouseX - width/2)/(float)zoom.toFloat(),height/2 - (mouseY -height/2)/(float)zoom.toFloat(),(width/(float)zoom.toFloat()),(height/(float)zoom.toFloat()));
    imageMode(CORNER);
    shift.add(scale.getPoint((mouseX - width/2)/MINDIM,(mouseY - height/2)/MINDIM));
    scale.real.mul(zoom);
    scale.imag.mul(zoom);
    bg = get();
    //plotScreen(iter);
    y = 0;
    //bg = get();
    if(mouseButton == RIGHT)
    {
      zoom = new fix(1).div(zoom);
    }
}

void mouseMoved() 
{
    image(bg,0,0);
    pathZ = getPoint(mouseX,mouseY);
    pathC = getPoint(mouseX,mouseY);
    pathIndex = 0;
    contPath(pathSect);
}

void keyPressed()
{
  if (key == '_'){
    new fix().hiPrec(8,new fix[] {(fix)BAILOUT,(fix)shift.real,(fix)shift.imag,(fix)scale.real,(fix)scale.imag,(fix)zoom});
  }
  if (key == '-'){
    new fix().loPrec(8,new fix[] {(fix)BAILOUT,(fix)shift.real,(fix)shift.imag,(fix)scale.real,(fix)scale.imag,(fix)zoom});
  }
  if (key == '='){
    iter /= 2;
  }
  if (key == '+'){
    iter = iter*2+1;
  }
  if (key == '`' || key == '~')
  {
       shift.real = shift.real.zero();
       shift.imag = shift.imag.zero();
       scale.real = shift.real.one().sum(shift.real.one());
       scale.imag = shift.imag.one().sum(shift.real.one());
       y = 0;
  }else
  if (key == 'S' || key == 's')
  {
    pathMode = !pathMode;
    image(bg,0,0);
    pathZ = getPoint(mouseX,mouseY);
    pathC = getPoint(mouseX,mouseY);
    pathIndex = 0;
    contPath(pathSect);
  }
  if (key == 'p' || key == 'P')
  {
    //CalcScreen(scaleX,scaleY,shiftX,shiftY,iter,imageSizeX,imageSizeY).save("out.png");
  }
  
  
}

int y = 0;
void draw()
{
  if( y < height)
  {
    image(bg,0,0);
    for ( int i = 0; i < (height/sect); i++)
    {
      //print(i);
      plotRow( (height/2)+(((y+i)%2==0)?(i+y)/2:-(y+1+i)/2) ,iter);
    }
    bg = get();
    y += height/sect;
  }
  contPath(pathSect);
}
