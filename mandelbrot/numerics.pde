abstract class Numeric<T extends Numeric<T>>{
  Numeric(double v){
  }
  abstract T copy();
  abstract T set(T other);
  
  T add(T other){return copy().addEq(other);}
  T sub(T other){return copy().subEq(other);}
  T mul(T other){return copy().mulEq(other);}
  T div(T other){return copy().divEq(other);}
  T neg(){return copy().neg();}
  T recip(){return copy().recip();}
  abstract T fromFloat(float v);
  T shiftRight(int n){return copy().shiftRightEq(n);}
  T abs(){
    if (this.lt(this.fromFloat(0))){
      return this.neg();
    }
    return (T) this;
  }
  
  abstract T addEq(T other);
  abstract T subEq(T other);
  abstract T mulEq(T other);
  abstract T divEq(T other);
  abstract T negEq();
  abstract T recipEq();
  abstract T shiftRightEq(int n);
  
  abstract boolean eq(T other);
  boolean neq(T other){return !this.eq(other);}
  abstract boolean leq(T other);
  boolean gt(T other){return !this.leq(other);}
  abstract boolean geq(T other);
  boolean lt(T other){return !this.geq(other);}
  
  abstract float toFloat();
  
  
  T sqrt(){
    T guess = (T)this;
    T oldOther = (T)this;
    T oldOldOther = (T)this;
    T other = this.div(guess);
    T diff = other.sub(guess); 
    while (diff.abs().gt((T)this) && oldOther.neq(other) && oldOldOther.neq(other)) {
      guess = diff.shiftRight(1).add(guess);
      oldOldOther = oldOther;
      oldOther = other;
      other = this.div(guess);
      diff = other.sub(guess); 
    }
    return guess;
  }
  
  abstract T log0();
}

class Complex<T extends Numeric<T>> extends Numeric<Complex<T>>{
  public T imag;
  public T real;

  Complex(T r, T i){
    super(0);
    real = r;
    imag = i;
  }
  
  Complex<T> copy(){
    return new Complex<T>(real.copy(),imag.copy());
  }
  Complex<T> set(Complex<T> other){
    real = other.real;
    imag = other.imag;
    return this;
  }
  
  Complex<T> add(Complex<T> o){
    return new Complex<T>(real.add(o.real),imag.add(o.imag));
  }
  Complex<T> sub(Complex<T> o){
    return new Complex<T>(real.sub(o.real),imag.sub(o.imag));
  }
  Complex<T> mul(Complex<T> o){
    return new Complex<T>(real.mul(o.real).subEq(imag.mul(o.imag)),real.mul(o.imag).addEq(imag.mul(o.real)));
  }
  Complex<T> div(Complex<T> o){
    return mul(o.recip());
  }
  Complex<T> neg(){
    return new Complex<T>(real.neg(),imag.neg());
  }
  Complex<T> conj(){
    return new Complex<T>(real,imag.neg());
  }
  Complex<T> recip(){
    return conj().realdiv(abs2());
  }
  Complex<T> addEq(Complex<T> o){
    real.addEq(o.real);
    imag.addEq(o.imag);
    return this;
  }
  Complex<T> subEq(Complex<T> o){
    real.subEq(o.real);
    imag.subEq(o.imag);
    return this;
  }
  Complex<T> mulEq(Complex<T> o){
    T tmp2 = real.mul(o.imag);
    T tmp = (imag.mul(o.imag));
    imag.mulEq(o.real).addEq(tmp2);
    real.mulEq(o.real).subEq(tmp);
    return this;
  }
  Complex<T> divEq(Complex<T> o){
    return mulEq(o.recip());
  }
  Complex<T> negEq(){
    real.negEq();imag.negEq();
    return this;
  }
  Complex<T> conjEq(){
    imag.negEq();
    return this;
  }
  Complex<T> recipEq(){
    return conjEq().realdivEq(abs2());
  }
  T abs2(){
    return real.mul(real).add(imag.mul(imag));
  }
  T r(){
    return abs2().sqrt();
  }
  Complex<T> abs(){
    return new Complex<T>(r(),real.sub(real));
  }
  Complex<T> realdiv(T n){
    return new Complex<T>(real.div(n),imag.div(n));
  }
  Complex<T> realmul(T n){
    return new Complex<T>(real.mul(n),imag.mul(n));
  }
  Complex<T> realdivEq(T n){
    real.divEq(n);imag.divEq(n);
    return this;
  }
  Complex<T> realmulEq(T n){
    real.mulEq(n);imag.mulEq(n);
    return this;
  }
  
  float toFloat(){
    return 0;
  }
  Complex<T> fromFloat(float f){
    return new Complex<T>(real.sub(real),real.sub(real));
  }
  Complex<T> shiftRight(int n){
    return new Complex<T>(real.shiftRight(n),imag.shiftRight(n));
  }
  Complex<T> shiftRightEq(int n){
    real.shiftRightEq(n);imag.shiftRightEq(n);
    return this;
  }
  
  
  boolean geq(Complex<T> o){return false;}
  boolean eq(Complex<T> o){return real.eq(o.real)&&imag.eq(o.imag);}
  boolean leq(Complex<T> o){return false;}
  Complex<T> log0(){
    return new Complex<T>(real.log0(),real.sub(real));
  }
  
  Complex<T> getPoint(float x, float y){
    return new Complex<T>(real.mul(real.fromFloat(x)),imag.mul(imag.fromFloat(y)));
  }
  
}

class Ndouble extends Numeric<Ndouble>{
  double v;
  Ndouble(double V){
    super(V);
    v = V;
  }
  
  Ndouble copy(){
    return new Ndouble(v);
  }
  Ndouble set(Ndouble o){
    v = o.v;
    return this;
  }
  
  Ndouble add(Ndouble o){ return new Ndouble(v+o.v);}
  Ndouble sub(Ndouble o){ return new Ndouble(v-o.v);}
  Ndouble mul(Ndouble o){ return new Ndouble(v*o.v);}
  Ndouble div(Ndouble o){ return new Ndouble(v/o.v);}
  Ndouble neg(){ return new Ndouble(-v);}
  Ndouble recip(){ return new Ndouble(1/v);}
  Ndouble shiftRight(int n){ return new Ndouble(v*Math.pow(.5,n));}
  
  Ndouble addEq(Ndouble o){ v += o.v;return this;}
  Ndouble subEq(Ndouble o){ v -= o.v;return this;}
  Ndouble mulEq(Ndouble o){ v *= o.v;return this;}
  Ndouble divEq(Ndouble o){ v /= o.v;return this;}
  Ndouble negEq(){ v = -v;return this;}
  Ndouble recipEq(){ v = 1/v;return this;}
  Ndouble shiftRightEq(int n){ v *= Math.pow(.5,n);return this;}
  
  Ndouble fromFloat(float V){ return new Ndouble((double) V);}
  Ndouble abs(){ return new Ndouble(Math.abs(v));}
  
  boolean eq(Ndouble o){ return v == o.v;}
  boolean neq(Ndouble o){ return v != o.v;}
  boolean leq(Ndouble o){ return v <= o.v;}
  boolean gt(Ndouble o){ return v > o.v;}
  boolean geq(Ndouble o){ return v >= o.v;}
  boolean lt(Ndouble o){ return v < o.v;}
  
  float toFloat(){ return (float)v;}
  
  Ndouble sqrt(){return new Ndouble(Math.sqrt(v));}
  
  Ndouble log0(){return new Ndouble(((double)-1.)/0.);}
  void rePrec(){}
}

/*
class AP extends Numeric<AP>{
  Apfloat val;
  AP(double V){
    super(V);
    val = new Apfloat(V,prec,radix);
  }
  AP(Apfloat V){
    super(0);
    val = V;
  }
  
  AP copy(){
    return new AP(val);
  }
  AP set(AP o){
    val = o.val;
    return this;
  }
  
  AP add(AP o){ return new AP(val.add(o.val));}
  AP sub(AP o){ return new AP(val.subtract(o.val));}
  AP mul(AP o){ return new AP(val.multiply(o.val));}
  AP div(AP o){ 
  if (o.val.compareTo(new Apfloat(0,prec,radix)) == 0){
    return new AP(1e30);
  }
  return new AP(val.divide(o.val));}
  AP neg(){ return new AP(val.negate());}
  AP recip(){ return new AP(new Apfloat(1,prec,radix).divide(val));}
  AP shiftRight(int n){ return new AP(val.multiply(ApfloatMath.pow(new Apfloat(.5,prec,radix),n)));}
  
  AP addEq(AP o){ return this.set(this.add(o));}
  AP subEq(AP o){ return this.set(this.sub(o));}
  AP mulEq(AP o){ return this.set(this.mul(o));}
  AP divEq(AP o){ return this.set(this.div(o));}
  AP negEq(){ return this.set(this.neg());}
  AP recipEq(){ return this.set(this.recip());}
  AP shiftRightEq(int n){ return this.set(this.shiftRight(n));}
  
  AP fromFloat(float V){ return new AP((double) V);}
  AP abs(){ return new AP(ApfloatMath.abs(val));}
  
  boolean eq(AP o){ return val.compareTo(o.val)==0;}
  boolean leq(AP o){ return val.compareTo(o.val)<=0;}
  boolean geq(AP o){ return val.compareTo(o.val)>=0;}
  
  float toFloat(){ return val.floatValue();}
  
  AP sqrt(){return new AP(ApfloatMath.sqrt(val));}
  
  AP log0(){return new AP(((double)-1.)/0.);}
  
  void rePrec(){
    val = val.precision(prec);
  }
  
}
*/
/*
class FastComplex extends Numeric<FastComplex>{
  double dreal;
  double dimag;
  boolean isApcomplex;  
  Apcomplex val;
  FastComplex(double r, double i){
    super(0);
    dreal = r;
    dimag = i;
    isApcomplex = false;
  }
  FastComplex(Apfloat r, Apfloat i){
    super(0);
    val = new Apcomplex(r,i);
    isApcomplex = true;
  }
  
  
  FastComplex copy(){
    if (isApcomplex){
      return new FastComplex(val.real(),val.imag());
    }else{
      return new FastComplex(dreal,dimag);
    }
  }
  FastComplex set(FastComplex other){
    dreal = other.dreal;
    dimag = other.dimag;
    val = other.val;
    isApcomplex = other.isApcomplex;
    return this;
  }
  
  FastComplex add(FastComplex o){
    if (isApcomplex)
    return new Complex<T>(real.add(o.real),imag.add(o.imag));
  }
  Complex<T> sub(Complex<T> o){
    return new Complex<T>(real.sub(o.real),imag.sub(o.imag));
  }
  Complex<T> mul(Complex<T> o){
    return new Complex<T>(real.mul(o.real).subEq(imag.mul(o.imag)),real.mul(o.imag).addEq(imag.mul(o.real)));
  }
  Complex<T> div(Complex<T> o){
    return mul(o.recip());
  }
  Complex<T> neg(){
    return new Complex<T>(real.neg(),imag.neg());
  }
  Complex<T> conj(){
    return new Complex<T>(real,imag.neg());
  }
  Complex<T> recip(){
    return conj().realdiv(abs2());
  }
  Complex<T> addEq(Complex<T> o){
    real.addEq(o.real);
    imag.addEq(o.imag);
    return this;
  }
  Complex<T> subEq(Complex<T> o){
    real.subEq(o.real);
    imag.subEq(o.imag);
    return this;
  }
  Complex<T> mulEq(Complex<T> o){
    T tmp2 = real.mul(o.imag);
    T tmp = (imag.mul(o.imag));
    imag.mulEq(o.real).addEq(tmp2);
    real.mulEq(o.real).subEq(tmp);
    return this;
  }
  Complex<T> divEq(Complex<T> o){
    return mulEq(o.recip());
  }
  Complex<T> negEq(){
    real.negEq();imag.negEq();
    return this;
  }
  Complex<T> conjEq(){
    imag.negEq();
    return this;
  }
  Complex<T> recipEq(){
    return conjEq().realdivEq(abs2());
  }
  T abs2(){
    return real.mul(real).add(imag.mul(imag));
  }
  T r(){
    return abs2().sqrt();
  }
  Complex<T> abs(){
    return new Complex<T>(r(),real.sub(real));
  }
  Complex<T> realdiv(T n){
    return new Complex<T>(real.div(n),imag.div(n));
  }
  Complex<T> realmul(T n){
    return new Complex<T>(real.mul(n),imag.mul(n));
  }
  Complex<T> realdivEq(T n){
    real.divEq(n);imag.divEq(n);
    return this;
  }
  Complex<T> realmulEq(T n){
    real.mulEq(n);imag.mulEq(n);
    return this;
  }
  
  float toFloat(){
    return 0;
  }
  Complex<T> fromFloat(float f){
    return new Complex<T>(real.sub(real),real.sub(real));
  }
  Complex<T> shiftRight(int n){
    return new Complex<T>(real.shiftRight(n),imag.shiftRight(n));
  }
  Complex<T> shiftRightEq(int n){
    real.shiftRightEq(n);imag.shiftRightEq(n);
    return this;
  }
  
  
  boolean geq(Complex<T> o){return false;}
  boolean eq(Complex<T> o){return real.eq(o.real)&&imag.eq(o.imag);}
  boolean leq(Complex<T> o){return false;}
  Complex<T> log0(){
    return new Complex<T>(real.log0(),real.sub(real));
  }
  
  Complex<T> getPoint(float x, float y){
    return new Complex<T>(real.mul(real.fromFloat(x)),imag.mul(imag.fromFloat(y)));
  }
  
}
*/
