

ComplexDouble[] time;
ComplexDouble[] freq;

ComplexDouble exp( double theta)
{
  return new ComplexDouble(1,theta,true);
}
ComplexDouble exp( ComplexDouble theta)
{
  return theta.realBase(Math.exp(1));
}

ComplexDouble[] fft(ComplexDouble[] x)
{
  int n = x.length;
  if ( n <= 1)
    return x;
  ComplexDouble[] even = new ComplexDouble[n/2];
  ComplexDouble[] odd = new ComplexDouble[n/2];
  for (int i = 0; i <  n ; i+=2)
  {
    even[i/2] = x[i];
    odd[i/2] = x[i+1];
  }
  even = fft(even);
  odd = fft(odd);
  ComplexDouble[] twiddle = new ComplexDouble[n/2];
  for (int i = 0 ; i < n/2; i++)
    twiddle[i] = exp(new ComplexDouble(0,-2*Math.PI*((double)(i))/n)).prod(odd[i]);
  ComplexDouble[] result = new ComplexDouble[n];
  for (int i = 0; i < n ; i ++)
    if (i < n/2)
      result[i] = even[i%(n/2)].sum(twiddle[i%(n/2)]);
    else
      result[i] = even[i%(n/2)].sum(new ComplexDouble(-twiddle[i%(n/2)].real,-twiddle[i%(n/2)].imag));
  return result;
}

ComplexDouble[] ifft(ComplexDouble[] x)
{
  ComplexDouble[] res = fft(x);
  for(ComplexDouble c : res){
    c.imag = -c.imag;
  }
  return res;
}
float scaleX = 4;
void setup(){
    size(1024,768);
    time = new ComplexDouble[(int)(width/scaleX)];
    freq = new ComplexDouble[(int)(width/scaleX)];
for (int i = 0; i < time.length; i ++)
{
  time[i] = new ComplexDouble();
  freq[i] = new ComplexDouble();
}

  background(255);
}

float yscale = 50;
void draw()
{
  background(255);
  for(int x = 0; x < time.length-1 ; x++)
  {
    stroke(255,0,0);
    line(scaleX*x,(float)(yscale*time[x].real + height/4),scaleX*(x+1),(float)(yscale*time[x+1].real + height/4));
    line(scaleX*x,(float)(yscale*freq[x].real + 3*height/4),scaleX*(x+1),(float)(yscale*freq[x+1].real + 3*height/4));
    stroke(0,0,255);
    line(scaleX*x,(float)(yscale*time[x].imag + height/4),scaleX*(x+1),(float)(yscale*time[x+1].imag + height/4));
    line(scaleX*x,(float)(yscale*freq[x].imag + 3*height/4),scaleX*(x+1),(float)(yscale*freq[x+1].imag + 3*height/4));
  }
  
    if(mousePressed){
  if (mouseY < height/2){
    if (mouseButton == 37){
      time[(int)(mouseX/scaleX)].real = (mouseY-height/4)/yscale;
    }else{
      time[(int)(mouseX/scaleX)].imag = (mouseY-height/4)/yscale;
    }
    freq = fft(time);
  }else{
    if (mouseButton == 37){
      freq[(int)(mouseX/scaleX)].real = (mouseY-3*height/4)/yscale;
    }else{
      freq[(int)(mouseX/scaleX)].imag = (mouseY-3*height/4)/yscale;
    }
    time = ifft(freq);
  }
  }
  
  
}












public class ComplexDouble
{
    public double imag;
    public double real;

    public String toString()
    {
  if(this.imag < 0)
      {
    return this.real +" - "+ (-this.imag) + 'i';
      }else{
      return this.real +" + "+ this.imag + 'i';
  }
    }

    
    /** constructors
     * make 0 + 0i
     */
    public ComplexDouble()
    {
  imag = 0.0;
  real = 0.0;
    }

    /** make a + 0i
     * @param real double of real part
     */
    public ComplexDouble(double real)
    {
  this.real = real;
        imag = 0.0;
    }

    
    /** construct real + imag i
     * @param real double of real part
     * @param imag double of imaginary part
     */
    public ComplexDouble(double real, double imag)
    {
  this.imag = imag;
  this.real = real;
    }
    /** add ex: a.sum(b) returns a + b
     */
    public ComplexDouble sum( ComplexDouble... nums)
    {
  double realPart = this.real;
        double imagPart = this.imag;
  for ( ComplexDouble n : nums)
      {
    realPart += n.real;
    imagPart += n.imag;
      }
  return new ComplexDouble(realPart, imagPart);
    }
    /** increment ex: a.add(b) sets a to a + b
     */
    public void add(ComplexDouble... nums)
    {/*
  for ( ComplexDouble n : nums)
      {
    this.real += n.real;
    this.imag += n.imag;
      }*/
  ComplexDouble tmp = this.sum(nums);
  this.imag = tmp.imag;
  this.real = tmp.real;
  
    }
    /** return the complex conjugate
     */
    public ComplexDouble conj()
    {
  return new ComplexDouble(this.real,-this.imag);
    }
    
    /** multiply ex: a.mul(b) returns ab
     */
    public ComplexDouble prod( ComplexDouble... nums)
    {
  double imagPart = this.imag;
  double realPart = this.real;
  for ( ComplexDouble n : nums)
      {
    double tempReal = realPart;
    realPart = n.real * realPart - n.imag * imagPart;
    imagPart = n.real * imagPart + tempReal * n.imag;        
      }
  return new ComplexDouble(realPart, imagPart);
    }
    /** multiply by
     */
    public void mul( ComplexDouble... nums)
    {
  /*  for ( ComplexDouble n : nums)
      {
    double tempReal = this.real;
    this.real = n.real * this.real - n.imag * this.imag;
    this.imag = n.real * this.imag + tempReal* n.imag;
    }*/
  ComplexDouble tmp = this.prod(nums);
  this.imag = tmp.imag;
  this.real = tmp.real;
    }
    /** return the inverse (multiplicative)
     */
    public ComplexDouble mulInverse()
    {
  /*
(a + bi) ( c + di ) = 1
ac - bd = 1
bc + ad = 0

c = 1/a + bd/a
c = -ad/b

d = - 1/b + ac/b
d = -bc/a

b/a + bbd/a = -ad
b + bbd = -aad
-ad - bd = 1


1/(a + bi) =  (a - bi) / (a ^ 2 - b ^ 2)

a/(a^2-b^2) - ib/(a^2-b^2)
(a/(a^2-b^2) - ib/(a^2-b^2)) * (a + bi) = a^2/(a^2-b^2) + b^2/(a^2-b^2)




  */
  double divisor = (this.real * this.real + this.imag * this.imag);
  return new ComplexDouble( this.real / divisor, - this.imag / divisor);
    }
    /* divide
     *
    public ComplexDouble dividend( ComplexDouble... nums)
    {
  ComplexDouble runningTotal = this;
  for ( ComplexDouble n : nums)
      {
    runningTotal.mul(n.mulInverse());
      }
  return runningTotal;
    }
    
    /** divide                                           
     *
    public void divide( ComplexDouble... nums)
    {
  for ( ComplexDouble n : nums)
      {
    this.mul(n.mulInverse());
      }
    }
    */
    /** get the R of R * e^i*theta
     */
    public double r()
    {
  return Math.sqrt(this.real * this.real + this.imag * this.imag);
    }
    /** get the theta
     */
    public double theta()
    {
  if (this.r() == 0)
      {
    return (double) 0.0;
      }else{
      /* tan(theta) = this.imag/this.real
       * theta = arctan(this.imag/this.real) = arccot(this.real/this.imag)

       * sin(theta) = this.imag/r
       * theta = arcsin(this.imag/r) = arccos(this.real/r)

       * arctan has from -pi/2 to pi/2
       * arccot has from 0 to pi
       * we can use (for each quadrant rotated 45°)
       \ 2 /
        \|/
------3--+--1-----
        /|\
       / 4 \
if x > y, in quad 1 or 4
if -x > y,in quad 3 or 4
1: theta = arctan(im/re)
2: theta = arccot(re/im)
3: theta = #1 + pi
4: theta = #2 + pi
if - x > y theta += pi

if in 1 or 3 use arctan
if -x > y xor x > y : arctan
       
      double theta;
      if ( ( this.real > this.imag ) ^ ( - this.real > this.imag ) )
    {
        theta = Math.arctan(this.imag/this.real);
    }else{
    theta = Math.arccot(this.real/this.imag);
      }
      

      if ( -this.real >  this.imag)
    {
        theta += Math.PI;
    }
      */
      return Math.atan2(this.imag,this.real);
      }
    }
    /** make rect cplx out of polar coords
     */
    public ComplexDouble(double a, double b, boolean polar)
    {
  if (polar)
      {
    imag = a * Math.sin(b);
    real = a * Math.cos(b);
      }else{
      imag = b;
      real = a;
  }
    }    
    
    /** a.pow(b) = a ^ b
     
(r * e^itheta) ^ n = r^n * e^(n*i*theta)


     */
    public ComplexDouble realPow( double exp)
    {
  double theta = this.theta();
  double r = this.r();
  r = Math.pow(r,exp);
  theta *= exp;
  return new ComplexDouble( r, theta, true);
    }
    /** raise real to cplx power

 (a + bi)     a    bi
n          = n  * n

n^bi = e^(ln(n)bi)

     */
    public ComplexDouble realBase(double base)
    {
  double r = Math.pow(base,this.real);
  double theta = (Math.log(base)*this.imag);
  return new ComplexDouble( r, theta, true);
    }
    /** raise cplx to imag power                      
n ^ bi = (n^b)^i                                      
                                                      
(a+bi) ^ i = e ^ ln(a+bi)i                            
                                                      
ln(a + bi)                                            
                                                      
                                                      
(a + bi) ^ i = (a + bi) ^ (-1 ^ (1/2))                
                                                      
(re^itheta) ^(bi) = r^(bi) * e ^(i theta (bi))
r ^ bi * e ^ (-b * theta)
    */
    public ComplexDouble imagPow( double exp)
    {
  ComplexDouble power = new ComplexDouble(0,exp);
  power = power.realBase(this.r());
  double mult = Math.exp(- this.theta() * exp);
  return new ComplexDouble(power.real * mult, power.imag * mult);
    }

    
    /** raise complex number to complex number!

(a + bi) ^ (c + di)

(a + bi) ^ c     *   (a + bi) ^ di
   
                                                      
(re^itheta) ^(a+bi) = r^(a+bi) * e ^(i theta (a + bi))
   

                                                   
    */
    public ComplexDouble pow(ComplexDouble power)
    {
  ComplexDouble a = this.realPow( power.real );
  ComplexDouble b = this.imagPow( power.imag );
  return a.prod(b);
    }

    public double abs()
    {
  return Math.sqrt(real * real + imag * imag);
    }
    public double abs2()
    {
  return (real * real + imag * imag);
    }
}
