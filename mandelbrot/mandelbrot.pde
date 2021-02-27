/*
Controls:
left click: zoom in
right click: zoom out
` or ~: reset zoom
_: increase precision (if using variable precision numeric types)
-: decrease precision
+: increase iterations
=: decrease iterations
s or S: toggle path (the trajectory of the point under the mouse) to be drawn at existing zoom or at default zoom
j: toggle julia set mode (zoom remains the same, so usually one would press j then ~)

*/
//import org.apfloat.*;
//import org.apfloat.internal.*;
//import org.apfloat.spi.*;


long prec = 8;
int radix = 32;

int iter = 256;//2048;
int pathSect = 16;
int sect = 1024;

int threads = 3;

int[] threadis;



Ndouble BAILOUT = new Ndouble(4);

Complex<Ndouble> shift = new Complex<Ndouble>(new Ndouble(0),new Ndouble(0));
Complex<Ndouble> scale = new Complex<Ndouble>(new Ndouble(2),new Ndouble(2));

int imageSizeX = 12288;
int imageSizeY = 8192;

Ndouble zoom =new Ndouble(0.5);

PImage bg;

int MINDIM;

boolean julia = false;
Complex<Ndouble> juliaSeed = shift;

public Complex<Ndouble> doStep(Complex<Ndouble> c, Complex<Ndouble> z,int inum)
{
  //return z.prod(c.mulInverse().sum(z.sum(c).mulInverse())).sum(c); // bailout 16 // c 
  //return z.realPow(new fix(1.5)).sum(c.prod(z.mulInverse()));//foam
  return z.mul(z).addEq(c.div(z));//foam
  //return z.mulEq(z).addEq(c);//mandelbrot
  //return z.mulEq(z.add(c)).addEq(c);//fractured mandelbrot
  
  //return z.mul(z).add(c.div(z.add(c)));//
  //return z.prod(z,z).sum(c.prod(z.mulInverse()));//foam
  //return z.prod(z,z,z,z,z,z).sum(c.prod(z.mulInverse()));//foam
  //return z.intPow(inum/32+2).sum(c.prod(z.mulInverse()));//foam
  //return z.intPow(inum%4+2).sum(c.prod(z.mulInverse()));//
  //return z.prod(z).sum(c);//mandelbrot
  //return z.intPow(inum/32+2).sum(c);//
  
  //return z.intPow(1112).sum(c);//
  //return z.prod(z,z,z,z).sum(z.prod(z,z,c.mulInverse()),c);
  //return z.pow(z).prod(c.mulInverse()).sum(z.conj(),c);//ferns
  //return z.pow(z.sum(c)).prod(c.mulInverse()).sum(z.conj(),c,c.prod(z.mulInverse()));//flow
  //return c.pow(z).prod(z.mulInverse()).sum(z);//stress field
  //return c.sum(c.prod(z,c.conj().mulInverse()));//stars
  //return c.prod(c.pow(z.conj()),z,z).sum(z.prod(c.conj().pow(c.prod(z,c.mulInverse().sum(z,c.conj(),z.mulInverse())))),c);//mirror eddies
  //return z.prod(z.sum(c)).sum(c,z.prod(c));//square mandel
  //return z.sum(c).pow(z.prod(c));//sharp flint
  /* these ones need to be updated to the new datatypes:
   //return new ComplexDouble((z.prod(z).imag-c.imag)%2,(z.prod(z).real-c.real)%2);//mandelbar mod
   //return new ComplexDouble((z.prod(z).sum(c).real)%2,(z.prod(z).sum(c).imag)%2);//mandelmod
   //return new ComplexDouble((z.prod(z).sum(c).real)%( 2 / (z.imag * c.real)),(z.prod(z).sum(c).imag)%( 2 / (z.real * c.imag)));//mandelmod2
  */
  //return z.conj().prod(z.conj()).sum(c);// mandelbar   
}



void setup()
{
  size(1024,1024);
  MINDIM = (int)(min(width,height)/2);
  //plotScreen(1);
  bg = get();
  threadis = new int[threads];
  for (int i = 0; i < threads; i++){
    threadis[i] = -1;
  }
  resetThreads();
  
  /*int[] c = new int[] {width/2,height/2};
  for (int i = 0; i < width*height; i++){
    setColor(i);
    rect(c[0],c[1],0,0);
    coordSpiral(c,1);
  }*/
}
boolean stopThreads = false;
int activeThreads = 0;
void resetThreads(){
  stopThreads = true;
  int d = 0;
  while (activeThreads > 0 && d < 250){
    delay(1);
    stopThreads = true;
    d++;
  }
  
  stopThreads = false;
  for (int i = 0 ;i < threads; i++) {
      threadis[i] = i;
      thread("threadFunc"+i);
  }
  
}
void threadFunc(int i){
  activeThreads++;
  
  int[] xy = new int[]{width/2,height/2};
  coordSpiral(xy,threadis[i]);
  while (threadis[i] < width*height){
    if (stopThreads){
      activeThreads--;
      return;
    }
    plotPoint(xy[0],xy[1],iter);
    coordSpiral(xy,threads);
    if (stopThreads){
      activeThreads--;
      return;
    }
    threadis[i]+= threads;
  }
  threadis[i] = -1;
  activeThreads--;
  return;
}

void threadFunc0(){threadFunc(0);}
void threadFunc1(){threadFunc(1);}
void threadFunc2(){threadFunc(2);}
void threadFunc3(){threadFunc(3);}
void threadFunc4(){threadFunc(4);}
void threadFunc5(){threadFunc(5);}
void threadFunc6(){threadFunc(6);}
void threadFunc7(){threadFunc(7);}

int sign(int n){
  return (n>0)?1:-1;
}
void coordSpiral(int[] xy,int i){
  
  /*   k jih g
       l6 5 4f
       m7 0 3e
       n8 1 2d
       o 9ab c
  * /
  // in bottom coord:
  // 1,9,10,11,25,26,27,28,29
  // {n-(floor√n)^2 < root}
  // in top quad:
  // 5,17,18,19,
  int r = (int)sqrt(i);
  r *= r;
  int d = i-r;
  if (d < r
  */
  xy[0] -= width/2;
  xy[1] -= height/2;
  for (int n = 0; n < i; n++){
    if (abs(xy[0])>=abs(xy[1]+(xy[1]>0 && xy[0]>0?1:0)) ){
      xy[1] += sign(xy[0]);
      
      /*if (xy[1]<-height/2 || xy[1]>=height-height/2){
        //skip over x row;
        xy[0] -= xy[1];
        xy[1] -= sign(xy[0]);
      }*/
    }else{
      xy[0] -= sign(xy[1]);
      
      /*if (xy[0]<-width/2 || xy[0]>=width-width/2){
        //skip over y col;
        xy[1] -= xy[0];
        xy[0] += sign(xy[1]);
      }*/
    }
  }
  xy[0] += width/2;
  xy[1] += height/2;
}



public float[] getCoords(Complex<Ndouble> point)
{
  return new float[] { width/2.+ MINDIM*((point.real.sub(shift.real).divEq(scale.real).toFloat())),
                       height/2.+MINDIM*((point.imag.sub(shift.imag).divEq(scale.imag).toFloat()))};
}
public float[] getCoords(Complex<Ndouble> point,boolean defaultWindow)
{
  if(defaultWindow)
  {
    return new float[] { width/2.+ MINDIM*((point.real.toFloat())/2),
                       height/2.+MINDIM*((point.imag.toFloat())/2)};
  }else{
    return getCoords(point);
  }
}

public Complex<Ndouble> getPoint(int x,int y)
{
  Complex<Ndouble> r = shift.add(scale.getPoint((x -  width/2.)/MINDIM,(y -  height/2.)/MINDIM));
  return r;
  //return r.sum(r.prod(new ComplexDouble(4,-2)).mulInverse());
  //return r.sum(r.prod(new ComplexDouble(1)).mulInverse());
  //return r.sum(r.prod(new ComplexDouble(2)).mulInverse());
  //return r.sum(r.prod(new ComplexDouble(-2)).mulInverse());
  //return r.prod((new ComplexDouble(log((float)r.r()),r.theta())));
}

public void setColor(double depth)
{
  stroke(getColor(depth));
}
color getColor(double depth)
{
  if (depth < 0)
  {
    return color(0);
  }else{
    float r = 128-(sin((float)depth/11)*96);
    float g = 128-(sin((float)depth/13)*96);
    float b = 128-(sin((float)depth/17)*96);
    return color(r,g,b);
  }
}

public int testPoint(Complex<Ndouble> point, int iterations)
{
  
  int bailout = -1;
  Complex<Ndouble> z = point.copy();
  for (int i = 0; i < iterations; i++)
  {
    if ( z.abs2().gt(BAILOUT) ) 
    {
      bailout = i;
      break;
    }
    if (stopThreads){
      return iterations;
    }
    z = doStep(julia?juliaSeed.copy():point,z,i);
  }
  return bailout;
}


public int drawPath(int[] coords, int iterations)
{
  int bailout = -1;
  Complex<Ndouble> z = getPoint(coords[0],coords[1]);
  Complex<Ndouble> c = getPoint(coords[0],coords[1]);
  for (int i = 0; i < iterations; i++)
  {
    setColor(i);
    
    float[] oldCoords = getCoords(z);
    if ( z.abs2().gt(BAILOUT) ) 
    {
      bailout = i;
      break;
    }
    z = doStep(julia?juliaSeed.copy():c,z,i);
    float[] newCoords = getCoords(z);
    line(oldCoords[0],oldCoords[1],newCoords[0],newCoords[1]);
  }
  return bailout;
}


boolean pathMode = false;
int pathIndex = 0;
Complex<Ndouble> pathZ =  shift.copy();
Complex<Ndouble> pathC =  shift.copy();
public void contPath(int n)
{
  for(int i = 0 ; i < n ; i++)
  {
    if(pathZ.abs2().lt(BAILOUT))
    {
      
      setColor(pathIndex);
      float[] oldCoords = getCoords(pathZ,pathMode);
      pathZ = doStep(julia?juliaSeed.copy():pathC,pathZ,pathIndex);
      float[] newCoords = getCoords(pathZ,pathMode);
      line(oldCoords[0],oldCoords[1],newCoords[0],newCoords[1]);
      pathIndex ++;
    }
  }
}
public void plotPoint(int x,int y, int iter)
{
     Complex<Ndouble> point = getPoint(x,y);
    int i = testPoint(point,iter);
    color c = getColor((double) i);
    set(x,y, c);
    bg.set(x,y, c);
}
public void plotRow(int y, int iter)
{
  Complex<Ndouble> point;
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
  Complex<Ndouble> point;
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
  Complex<Ndouble> point;
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
  
  






void mouseClicked()
  {
    //iter = (int) (iter + 0.125 * iter);
    //println(iter);
    if(mouseButton == RIGHT)
    {
      zoom.recipEq();
    }
    background(255,255,255);
    imageMode(CENTER);
    image(bg, width/2. - (mouseX - width/2.)/(float)zoom.toFloat(),height/2. - (mouseY -height/2.)/(float)zoom.toFloat(),(width/(float)zoom.toFloat()),(height/(float)zoom.toFloat()));
    imageMode(CORNER);
    shift.addEq(scale.getPoint((mouseX - width/2.)/MINDIM,(mouseY - height/2.)/MINDIM));
    scale.realmulEq(zoom);
    bg = get();
    //plotScreen(iter);
    y = 0;
    resetThreads();
    //bg = get();
    if(mouseButton == RIGHT)
    {
      zoom.recipEq();
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
    //new fix().hiPrec(8,new fix[] {(fix)BAILOUT,(fix)shift.real,(fix)shift.imag,(fix)scale.real,(fix)scale.imag,(fix)zoom});
    prec += 8;  
    BAILOUT.rePrec();
    shift.real.rePrec();
    shift.imag.rePrec();
    scale.real.rePrec();
    scale.imag.rePrec();
    zoom.rePrec();
  }
  if (key == '-'){
    //new fix().loPrec(8,new fix[] {(fix)BAILOUT,(fix)shift.real,(fix)shift.imag,(fix)scale.real,(fix)scale.imag,(fix)zoom});
    prec -= 8;
    BAILOUT.rePrec();
    shift.real.rePrec();
    shift.imag.rePrec();
    scale.real.rePrec();
    scale.imag.rePrec();
    zoom.rePrec();
  }
  if (key == '='){
    iter /= 2;
  }
  if (key == '+'){
    iter = iter*2+1;
  }
  if (key == '`' || key == '~')
  {
       shift.real = shift.real.fromFloat(0);
       shift.imag = shift.imag.fromFloat(0);
       scale.real = shift.real.fromFloat(2);
       scale.imag = shift.imag.fromFloat(2);
       y = 0;
       resetThreads();
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
  if (key == 'j'){
    juliaSeed = getPoint(mouseX,mouseY);
    julia = !julia;
    y=0;
    resetThreads();
  }
  
}

int y = 0;
void draw()
{
  /*if( y < height)
  {
    image(bg,0,0);
    for ( int i = 0; i < (sect/width); i++)
    {
      //print(i);
      plotRow( (height/2)+(((y+i)%2==0)?(i+y)/2:-(y+1+i)/2) ,iter);
    }
    bg = get();
    y += (sect/width);
  }
  */
  contPath(pathSect);
}
