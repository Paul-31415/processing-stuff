abstract class num<t>{
    abstract public t sum(t... nums);
    public t sub(t o){return this.sum(o.neg());}
    abstract public void add(t... nums);
    abstract public t prod(t... nums);
    public t div(t o){
      return this.prod(o.mulInverse());
    }
    abstract public t fromDouble(double d);
    abstract public void mul(t... nums);
    abstract public t neg();
    abstract public t mulInverse();
    abstract public t pow(t power);
    abstract public boolean leq(t b);
    public boolean gt(t b){ return !leq(b);}
    abstract public boolean geq(t b);
    public boolean lt(t b){ return !geq(b);}
    abstract public boolean eq(t b);
    public boolean neq(t b){ return !eq(b);}
    abstract public float toFloat();
    abstract public t atan2with(num x);
    abstract public t sin();
    abstract public t cos();
    abstract public t one();
    abstract public t zero();
    abstract public t sqrt();
    public t div2(){ return this.div(this.one().sum(this.one()));}
}




class cn<t extends num>
{
    public t imag;
    public t real;
    public cn(t real, t imag)
    {
  this.imag = imag;
  this.real = real;
    }
    /** add ex: a.sum(b) returns a + b
     */
    public cn<t> sum( cn<t>... nums)
    {
  t realPart = this.real;
        t imagPart = this.imag;
  for ( cn n : nums)
      {
    realPart.add(n.real);
    imagPart.add(n.imag);
      }
  return new cn(realPart, imagPart);
    }
    /** increment ex: a.add(b) sets a to a + b
     */
    public void add(cn... nums)
    {
  cn<t> tmp = this.sum(nums);
  this.imag = tmp.imag;
  this.real = tmp.real;
  
    }
    /** return the complex conjugate
     */
    public cn conj()
    {
  return new cn(this.real,this.imag.neg());
    }
    
    /** multiply ex: a.mul(b) returns ab
     */
    public cn<t> prod( cn<t>... nums)
    {
  t imagPart = this.imag;
  t realPart = this.real;
  for ( cn<t> n : nums)
      {
    t tempReal = realPart;
    realPart = n.real.prod(realPart).sum(n.imag.prod(imagPart).neg());
    imagPart = n.real.prod(imagPart).sum(tempReal.prod(n.imag));        
      }
  return new cn(realPart, imagPart);
    }
    /** multiply by
     */
    public void mul( cn<t>... nums)
    {
  cn<t> tmp = this.prod(nums);
  this.imag = tmp.imag;
  this.real = tmp.real;
    }
    /** return the inverse (multiplicative)
     */
    public cn<t> mulInverse()
    {
  t divisor = this.abs2();
  return new cn<t>( this.real.div(divisor), this.imag.div(divisor).neg());
    }
    
    /** get the R of R * e^i*theta
     */
    public t r()
    {
  return this.abs();
    }
    /** get the theta
     */
    public t theta()
    {
      return this.imag.atan2with(this.real);
    }
    /** make rect cplx out of polar coords
     */
    public cn(t a, t b, boolean polar)
    {
  if (polar)
      {
    imag = a.prod(b.sin());
    real = a.prod(b.cos());
      }else{
      imag = b;
      real = a;
  }
    }    
    
    /** a.pow(b) = a ^ b
     
(r * e^itheta) ^ n = r^n * e^(n*i*theta)


     */
    public cn<t> realPow( num exp)
    {
  t theta = this.theta();
  t r = this.r();
  r = r.pow(exp);
  theta.mul(exp);
  return new cn( r, theta, true);
    }
    public cn intPow( int exp)
    {
      if (exp<0)
        return this.mulInverse().intPow(-exp);
      cn ans = new cn(real.one(),real.zero());
      for(int i = 1<<(32-Integer.numberOfLeadingZeros(exp)); i > 0; i >>= 1){
        ans.mul(ans);
        if( (exp & i) != 0){
          ans.mul(this);
        }
      }
      return ans;
  
    }
    
    
    /** raise real to cplx power

 (a + bi)     a    bi
n          = n  * n

n^bi = e^(ln(n)bi)

     *
    public cn realBase(num base)
    {
  num r = base.pow(this.real);
  num theta = (base.ln().mul(this.imag));
  return new cn( r, theta, true);
    }
    /** raise cplx to imag power                      
n ^ bi = (n^b)^i                                      
                                                      
(a+bi) ^ i = e ^ ln(a+bi)i                            
                                                      
ln(a + bi)                                            
                                                      
                                                      
(a + bi) ^ i = (a + bi) ^ (-1 ^ (1/2))                
                                                      
(re^itheta) ^(bi) = r^(bi) * e ^(i theta (bi))
r ^ bi * e ^ (-b * theta)
    *
    public cn imagPow( num exp)
    {
  cn power = new cn(new fix(0),exp);
  power = power.realBase(this.r());
  num mult = this.theta().mul(exp).e();
  return new cn(power.real.mul(mult), power.imag.mul(mult));
    }

    
    /** raise complex number to complex number!

(a + bi) ^ (c + di)

(a + bi) ^ c     *   (a + bi) ^ di
   
                                                      
(re^itheta) ^(a+bi) = r^(a+bi) * e ^(i theta (a + bi))
   

                                                   
    *
    public cn pow(cn power)
    {
  cn a = this.realPow( power.real );
  cn b = this.imagPow( power.imag );
  return a.prod(b);
    }
/*
*/
    public t abs()
    {
  return this.abs2().sqrt();
    }
    public t abs2()
    {

      return (real.prod(real).sum(imag.prod(imag)));
    }
    
    public boolean bailout(t b){
       return this.abs2().gt(b); 
    }
    public float[] toCoords(){
      return new float[] {real.toFloat(),imag.toFloat()};
    }
    public cn<t> getPoint(float x, float y){
       return new cn<t>(real.prod(real.fromDouble(x)),imag.prod(real.fromDouble(y))); 
    }
}




class Ndouble extends num {
    double v;
    Ndouble(double V){v=V;}
    public num sum(num... nums){
      double tot = v;
      for (Ndouble n : (Ndouble[])nums){
        tot += n.v;
      }
      return new Ndouble(tot);
    }
    public void add(num... nums){
      for (Ndouble n : nums){
        v += n.v;
      }
    }
    public Ndouble prod(Ndouble... nums){
      double tot = v;
      for (Ndouble n : nums){
        tot *= n.v;
      }
      return new Ndouble(tot);
    }
    public Ndouble div(Ndouble o){
      return new Ndouble(v/o.v);
    }
    public void mul(Ndouble... nums){
      for (Ndouble n : nums){
        v *= n.v;
      }
    }
    public num fromDouble(double d){return new Ndouble(d);}
    public Ndouble neg(){ return new Ndouble(-v);}
    public Ndouble mulInverse() { return new Ndouble(1/v);}
    public Ndouble pow(Ndouble power) {return new Ndouble(Math.pow(v,power.v));}
    public boolean lte(Ndouble b) {return v <= b.v;}
    public boolean gte(Ndouble b) {return v >= b.v;}
    public boolean lt(Ndouble b) {return v < b.v;}
    public boolean gt(Ndouble b) {return v > b.v;}
    public boolean eq(Ndouble b) {return v == b.v;}
    public boolean neq(Ndouble b) {return v != b.v;}
    public float toFloat() { return (float)v;}
    public Ndouble atan2with(Ndouble x){ return new Ndouble(Math.atan2(v,x.v));}
    public Ndouble sin(){return new Ndouble(Math.sin(v));}
    public Ndouble cos(){return new Ndouble(Math.cos(v));}
    public Ndouble one(){return new Ndouble(1);}
    public Ndouble zero(){return new Ndouble(0);}
    public Ndouble div2(){ return new Ndouble(v/2);}
    public Ndouble sqrt(){ return new Ndouble(Math.sqrt(v));}
    public Ndouble sub(Ndouble o){return new Ndouble(v-o.v);}
}
