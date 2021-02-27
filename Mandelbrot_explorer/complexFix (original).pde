/**
 * complex number fixed point
 * @author Paul
 */
 import java.math.BigInteger;
 import java.math.BigDecimal;
 static int prec = -8;

 static fixConst[] cordic;
 
 //static ArrayList<WeakReference<fix>> fixNums = new ArrayList<WeakReference<fix>>();
 

class fix extends num{
  
  num zero(){
    return new fix(0);
  }
  
  num fromDouble(double d){
    return new fix(d);
  }
  
  
  String toString()
  {
    BigDecimal half = new BigDecimal(BigInteger.TEN.shiftRight(1),1);
    BigDecimal two =  new BigDecimal(BigInteger.ONE.shiftLeft(1));
    
    BigDecimal thing = half;
    int exp = -prec;
    
    if (exp<0){
        thing = two;
        exp = -exp;
    }
        
      BigDecimal scl = BigDecimal.ONE;
      for(int i = 1<<(32-Integer.numberOfLeadingZeros(exp)); i > 0; i >>= 1){
        scl = scl.multiply(scl);
        if( (exp & i) != 0){
          scl = scl.multiply(thing);
        }
      }
      
      
    
    
    int s = ceil(prec*log(2)/log(10));
    return ((new BigDecimal(val)).multiply(scl)).setScale(1-s,BigDecimal.ROUND_HALF_UP).toString();
  }
  
  
  BigInteger val;
  fix(){
    val = BigInteger.ZERO;
  }
  fix(double v){
    val = BigDecimal.valueOf(v*256.*256.*256.*256.*256.*256.*256.*256.).toBigInteger().shiftRight(64+prec);
  }
  fix(BigInteger v){
    val = v;
  }
  fix(BigInteger v,int p){
    val = v.shiftLeft(p-prec);
  }
  fix(int v){
    val = new BigInteger(str(v)).shiftLeft(-prec);
  }
  double toDouble(){
    return val.doubleValue()*Math.pow(2,prec);
  }
   float toFloat(){
    return (float)this.toDouble();
  }
  
  
/*  void hiPrec(int dp,fix... ns){
    prec -= dp;
    for( fix f: ns){
      f.val = f.val.shiftLeft(dp);
    }
  }
  
  void loPrec(int dp,fix... ns){
    prec += dp;
    for( fix f: ns){
      f.val = f.val.shiftRight(dp);
    }
  }*/
  
  void hiPrec(int dp,fix[]... ars){
    prec -= dp;
    for( fix[] ns: ars){
      for( fix f: ns){
        f.val = f.val.shiftLeft(dp);
      }
    }
  }
  
  void loPrec(int dp,fix[]... ars){
    prec += dp;
    for( fix[] ns: ars){
      for( fix f: ns){
        f.val = f.val.shiftRight(dp);
      }
    }
  }
  
  
  fix one(){
    return new fix(BigInteger.ONE.shiftLeft(-prec));
  }
  fix pow2(int p){
    return new fix(BigInteger.ONE.shiftLeft(-prec+p));
  }
  
  num sum(num... o){
    BigInteger res = val;
    for (fix f :(fix[])o){
      res = res.add(f.val);
    }
    return new fix(res);
  }
  void add(num... o){
    fix tmp = (fix)this.sum(o);
    val = tmp.val;
  }
  
  num sub(num... o){
    BigInteger res = val;
    for (fix f :(fix[])o){
      res = res.subtract(f.val);
    }
    return new fix(res);
  }
  
  num neg(){
    return new fix(val.negate());}
  
  num prod(num... o){
    BigInteger res = val;
    for (fix f :(fix[])o){
      res = res.multiply(f.val).shiftRight(-prec);
    }
    return new fix(res);
  }
  
  void mul(num... o){
    fix tmp = (fix)this.prod(o);
    val = tmp.val;
  }
  
  fix prod(BigInteger... o){
    BigInteger res = val;
    for (BigInteger f :o){
      res = res.multiply(f);
    }
    return new fix(res);
  }
  
  num mulInverse(){
     return this.one().div(this); 
  }
  
  
  fix div(fix... o){
     BigInteger res = val;
    for (fix f :o){
      if (f.val.signum() == 0){
        res = res.shiftLeft(1-prec);
      }else{
      res = res.shiftLeft(-prec).divide(f.val);
      }
    }
    return new fix(res);
  }
  
  fix div(BigInteger... o){
     BigInteger res = val;
    for (BigInteger f :o){
      res = res.divide(f);
    }
    return new fix(res);
  }
  
  fix mod(fix f){
    return new fix(val.mod(f.val));
  }
  
  
  fix abs(){
    return new fix(val.abs());
  }
  boolean eq(num o){return val.compareTo(((fix)o).val) == 0;}
  boolean neq(num o){return val.compareTo(((fix)o).val) != 0;}
  boolean leq(num o){return val.compareTo(((fix)o).val) <= 0;}
  boolean lt(num o){return val.compareTo(((fix)o).val) < 0;}
  boolean geq(num o){return val.compareTo(((fix)o).val) >= 0;}
  boolean gt(num o){return val.compareTo(((fix)o).val) > 0;}
  
  
  fix nRoot(int n){
    fix guess = pow2(intLog2()/n);
    //x^n-this = 0
    //next = x-(x^n-this)/(n*(x^(n-1)))
    //fix old = new fix();
    fix delta = one();
    while (delta.neq(new fix())){
      delta = (fix)guess.intPow(n).sub(this).neg().div(new fix(n).prod(guess.intPow(n-1)));
      guess.add(delta);
    }
    return guess;
  }
  
  fix sqrt(){
    return sqrt(this);
  }
  
  fix sqrt(fix p){
    fix guess = new fix( BigInteger.ZERO.setBit((this.val.bitLength()+prec)/2-prec));
    fix oldOther = new fix();
    fix oldOldOther = new fix();
    fix other = (fix)this.div(guess);
    fix diff = (fix)other.sub(guess); 
    while (diff.abs().gt(p) && oldOther.neq(other) && oldOldOther.neq(other)) {
      //print(guess);
      guess.val = diff.val.shiftRight(1).add(guess.val);
      oldOldOther = oldOther;
      oldOther = other;
      other = (fix)this.div(guess);
      diff = (fix)other.sub(guess); 
      
    }
    return guess;
  }
  
  fix ln(){
    return (fix)log2(this).prod(new fixConst_ln2().val());
  }
  fix ln(fix p){
    return (fix)log2(p).prod(new fixConst_ln2().val());
  }
  
  fix log2(){
    return log2(this);
  }
  
  fix log2(fix p){
    if (p.eq(new fix()))
      return new fix(prec-1);
    fix ans = new fix( p.intLog2());
    p = p.shiftRight(p.val.bitLength()+prec-1);
    fix p2 = one();
    while(p2.neq(new fix())){
      //println(p2);
      //println(ans);
      p2 = p2.shiftRight(1);
      p = (fix)p.prod(p);
      if (p.geq(new fix(2))){
        ans.add(p2);
        p = p.shiftRight(1);
      }
    }
    return ans;
  }
  
  fix e(){
    return e(this);
  }
  
  
  fix iPart(){
    return new fix(val.and(new fix(-1).val));
  }
  fix fPart(){
    return new fix(val.and(one().val.subtract(BigInteger.ONE)));
  }
  
  fix e(fix exp){
    if(exp.geq(new fix(-1)) && exp.leq(one())){
    BigInteger t = BigInteger.ONE;
    fix term = one();
    fix res = new fix();
    while (term.val.signum() != 0){
      res.add(term);
      term.mul(exp);
      term = term.div(t);
      t = t.add(BigInteger.ONE);
    }
    return res;
    }
    return (fix)new fixConst_e().val().intPow((int)exp.iPart().toDouble()).prod(exp.fPart().e());
    
  }
  
  
  int intLog2(){
    return intLog2(this);
  }
  
  int intLog2(fix p){
    return p.val.bitLength()+prec-1;
  }
  
  num pow(num exp){
    return ((fix)this.ln().prod(exp)).e();
  }
  
  fix intPow( int exp)
  {
      if (exp<0)
        return ((fix)one().div(this)).intPow(-exp);
      fix ans = one();
      for(int i = 1<<(32-Integer.numberOfLeadingZeros(exp)); i > 0; i >>= 1){
        ans.mul(ans);
        if( (exp & i) != 0){
          ans.mul(this);
        }
      }
      return ans;
  }
  
  fix shiftLeft(int n){
    return new fix(val.shiftLeft(n));}
  fix shiftRight(int n){
    return new fix(val.shiftRight(n));}
  
  num sin(){
    return sin(this);
  }
  num cos(fix n){
    return (new fixConst_pi().val().shiftRight(1)).sum(n).sin();
  }
  num cos(){
    return cos(this);
  }
  
  num sin(num n){
    n = ((fix)n).mod(new fixConst_pi().val().shiftLeft(1));
    if (n.geq(new fixConst_pi().val()))
      return sin(n.sub(new fixConst_pi().val())).neg();
    
    if (n.gt(new fixConst_pi().val().shiftRight(1)))
      return sin(new fixConst_pi().val().sub(n));
      
    fix[] taylorCs;
    BigInteger[] dm = ((fix)n.sum(new fixConst_pi().val().shiftRight(3))).val.divideAndRemainder(new fixConst_pi().val().shiftRight(2).val);
    n = new fix(dm[1]).sub(new fixConst_pi().val().shiftRight(3));
    taylorCs = new fix[][] {
      {new fix(),new fix(1)},
      {new fixConst_r2().val().shiftRight(1),new fixConst_r2().val().shiftRight(1)},
      {new fix(1),new fix()}
    } [dm[0].intValue()];
      
    BigInteger t = BigInteger.ONE;
    fix term = one();
    fix res = new fix();
    int i = 0;
    
    while (term.val.signum() != 0){
      
      //print(res);
      if (i > 1)
        term = (fix)term.neg();
        
      //print(term);print(' ');
      res.add(term.prod(taylorCs[i%2]));
      if (i > 1)
        term = (fix)term.neg();
     
      
      term = ((fix)term.prod(n)).div(t);
      //print(x);
     
       
      
      t = t.add(BigInteger.ONE);
      i = (i + 1)%4;
      
    }
    return res;
    
    
  }
  
  
  
  
  //modified CORDIC in vectoring mode:
  // squaring doubles angle, so if can always rotate it by pi/2 back to the right side of axes, no need to have angle table
  // would have to normalize frequently to keep it small
  
  // or binary search with sin : too expensive
  
  //nah, I'll jsut use normal CORDIC
  num atan2with(num x){
    return this.atan2(this,(fix)x);
  }
  
  fix atan2(fix y, fix x){
    fix z0 = new fix();
    if (x.lt(z0))
      return (fix)new fixConst_pi().val().sub(atan2(y,(fix)x.neg()));
      
    fix angle = z0;
    int i = 0;
    
    while (y.neq(z0)){
      //print(y);
      fix oy = y;
      if (y.lt(z0)){
        y.add(x.shiftRight(i));
        x = (fix) x.sub(oy.shiftRight(i));
        angle = (fix)angle.sub(new fixConstSeries_cordicAngles().val(i));
      }else{
        y = (fix) y.sub(x.shiftRight(i));
        x.add(oy.shiftRight(i));
        angle.add(new fixConstSeries_cordicAngles().val(i));
      }
      //print(y);
      i++;
    }
    return angle;
  }
  
}
 
 

public class ComplexFix
{
    public fix imag;
    public fix real;
    

    public String toString()
    {
  if(this.imag.lt(new fix()))
      {
    return this.real.toString() +" - "+ (new fix().sub(this.imag)).toString() + 'i';
      }else{
      return this.real.toString() +" + "+ this.imag.toString() + 'i';
  }
    }

    
    /** constructors
     * make 0 + 0i
     */
    public ComplexFix()
    {
  imag = new fix();
  real = new fix();
    }

    /** make a + 0i
     * @param real fix of real part
     */
    public ComplexFix(fix real)
    {
  this.real = real;
        imag = new fix();
    }

    
    /** construct real + imag i
     * @param real fix of real part
     * @param imag fix of imaginary part
     */
    public ComplexFix(fix real, fix imag)
    {
  this.imag = imag;
  this.real = real;
    }
    /** add ex: a.sum(b) returns a + b
     */
    public ComplexFix sum( ComplexFix... nums)
    {
  fix realPart = this.real;
        fix imagPart = this.imag;
  for ( ComplexFix n : nums)
      {
    realPart.add(n.real);
    imagPart.add(n.imag);
      }
  return new ComplexFix(realPart, imagPart);
    }
    /** increment ex: a.add(b) sets a to a + b
     */
    public void add(ComplexFix... nums)
    {/*
  for ( ComplexFix n : nums)
      {
    this.real += n.real;
    this.imag += n.imag;
      }*/
  ComplexFix tmp = this.sum(nums);
  this.imag = tmp.imag;
  this.real = tmp.real;
  
    }
    /** return the complex conjugate
     */
    public ComplexFix conj()
    {
  return new ComplexFix(this.real,(fix)this.imag.neg());
    }
    
    /** multiply ex: a.mul(b) returns ab
     */
    public ComplexFix prod( ComplexFix... nums)
    {
  fix imagPart = this.imag;
  fix realPart = this.real;
  for ( ComplexFix n : nums)
      {
    fix tempReal = realPart;
    realPart = (fix)n.real.prod(realPart).sub(n.imag.prod(imagPart));
    imagPart = (fix)n.real.prod(imagPart).sum(tempReal.prod(n.imag));        
      }
  return new ComplexFix(realPart, imagPart);
    }
    /** multiply by
     */
    public void mul( ComplexFix... nums)
    {
  /*  for ( ComplexFix n : nums)
      {
    double tempReal = this.real;
    this.real = n.real * this.real - n.imag * this.imag;
    this.imag = n.real * this.imag + tempReal* n.imag;
    }*/
  ComplexFix tmp = this.prod(nums);
  this.imag = tmp.imag;
  this.real = tmp.real;
    }
    /** return the inverse (multiplicative)
     */
    public ComplexFix mulInverse()
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
  fix divisor = this.abs2();
  return new ComplexFix( (fix)this.real.div(divisor), (fix)new fix().sub(this.imag.div(divisor)));
    }
    /* divide
     *
    public ComplexFix dividend( ComplexFix... nums)
    {
  ComplexFix runningTotal = this;
  for ( ComplexFix n : nums)
      {
    runningTotal.mul(n.mulInverse());
      }
  return runningTotal;
    }
    
    /** divide                                           
     *
    public void divide( ComplexFix... nums)
    {
  for ( ComplexFix n : nums)
      {
    this.mul(n.mulInverse());
      }
    }
    */
    /** get the R of R * e^i*theta
     */
    public fix r()
    {
  return this.abs();
    }
    /** get the theta
     */
    public fix theta()
    {
  
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
      return new fix().atan2(this.imag,this.real);
      
    }
    /** make rect cplx out of polar coords
     */
    public ComplexFix(fix a, fix b, boolean polar)
    {
  if (polar)
      {
    imag = (fix)a.prod(b.sin());
    real = (fix)a.prod(b.cos());
      }else{
      imag = b;
      real = a;
  }
    }    
    
    /** a.pow(b) = a ^ b
     
(r * e^itheta) ^ n = r^n * e^(n*i*theta)


     */
    public ComplexFix realPow( fix exp)
    {
  fix theta = this.theta();
  fix r = this.r();
  r = (fix)r.pow(exp);
  theta = (fix)theta.prod(exp);
  return new ComplexFix( r, theta, true);
    }
    public ComplexFix intPow( int exp)
    {
      if (exp<0)
        return this.mulInverse().intPow(-exp);
      ComplexFix ans = new ComplexFix(new fix(1));
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

     */
    public ComplexFix realBase(fix base)
    {
  fix r = (fix)base.pow(this.real);
  fix theta = (fix)(base.ln().prod(this.imag));
  return new ComplexFix( r, theta, true);
    }
    /** raise cplx to imag power                      
n ^ bi = (n^b)^i                                      
                                                      
(a+bi) ^ i = e ^ ln(a+bi)i                            
                                                      
ln(a + bi)                                            
                                                      
                                                      
(a + bi) ^ i = (a + bi) ^ (-1 ^ (1/2))                
                                                      
(re^itheta) ^(bi) = r^(bi) * e ^(i theta (bi))
r ^ bi * e ^ (-b * theta)
    */
    public ComplexFix imagPow( fix exp)
    {
  ComplexFix power = new ComplexFix(new fix(0),exp);
  power = power.realBase(this.r());
  fix mult = ((fix) this.theta().prod(exp)).e();
  return new ComplexFix((fix)power.real.prod(mult), (fix)power.imag.prod(mult));
    }

    
    /** raise complex number to complex number!

(a + bi) ^ (c + di)

(a + bi) ^ c     *   (a + bi) ^ di
   
                                                      
(re^itheta) ^(a+bi) = r^(a+bi) * e ^(i theta (a + bi))
   

                                                   
    */
    public ComplexFix pow(ComplexFix power)
    {
  ComplexFix a = this.realPow( power.real );
  ComplexFix b = this.imagPow( power.imag );
  return a.prod(b);
    }

    public fix abs()
    {
  return this.abs2().sqrt();
    }
    public fix abs2()
    {
  return (fix)(real.prod(real).sum(imag.prod(imag)));
    }
    
    public boolean bailout(fix b){
       return this.abs2().gt(b); 
    }
    public float[] toCoords(){
      return new float[] {(float)real.toDouble(),(float)imag.toDouble()};
    }
    
    public ComplexFix real(){
      return new ComplexFix(real,new fix(0)); 
    }
    public ComplexFix imag(){
      return new ComplexFix(imag,new fix(0));
    }
}
