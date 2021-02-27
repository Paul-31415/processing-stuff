
static abstract class fixConst{
  
  abstract fix val();
  
}
static abstract class fixConstSeries{
  
  abstract fix val(int n);
  
}

static abstract class fixConstSeries_cordicAngles_cache extends fixConstSeries{
  static BigInteger[] cordic = new BigInteger[0];
  static int cachePrec = 0;
}
class fixConstSeries_cordicAngles extends fixConstSeries_cordicAngles_cache{
  String toString(){ return "CORDIC angles instance";}
  fixConstSeries_cordicAngles(){
  }
  
  void recalc(){
    new fix().hiPrec(8);
    
    cordic = new BigInteger[(int)ceil(-prec/3.0)];
    fix pow2 = new fix(1).shiftRight(1);
    cordic[0] = new fixConst_pi().val().val.shiftRight(10);
    for( int i = 1; i < cordic.length ; i++){
      // arctan approx
      //print(i);
      BigInteger t = BigInteger.ONE;
      fix term = pow2;
      fix res = new fix();
      fix x = pow2;
    
      while (term.val.signum() != 0){
      
        term = x.div(t);
        res.add(term);
        x = (fix)x.prod(pow2,pow2).neg();
        t = t.add(BigInteger.ONE).add(BigInteger.ONE);
      
      }
      cordic[i] = res.val.shiftRight(8);
      pow2.val = pow2.val.shiftRight(1);
    //print(":\t");
    //println(res);
    }
    new fix().loPrec(8);
    cachePrec = prec;
    
  }
  
  fix val(int n){
    if (prec < cachePrec){
      int dp = abs(prec);
      new fix().hiPrec(dp);
      recalc();
      new fix().loPrec(dp);
    }
    if (n < cordic.length){
      return new fix(cordic[n],cachePrec);
    }else{
      return new fix().pow2(-n);
    }
  }
  
  
  
}


static abstract class fixConst_pi_cache extends fixConst{
  static BigInteger cache = BigInteger.ONE.shiftLeft(1).add(BigInteger.ONE);
  static int cachePrec = 0;
} 
class fixConst_pi extends fixConst_pi_cache{
  String toString(){ return "const(π)";}
  fixConst_pi(){
  }
  fix calc(){
    fix pi = new fix();
    for(int k = 0; k < (-prec/4)+2; k++){
      pi.add(new fix().pow2(-k*4).prod(new fix(4).div(new fix(8).prod(new fix(k)).sum(new fix(1))).sub(
      new fix(2).div(new fix(8).prod(new fix(k)).sum(new fix(4)))).sub(new fix(1).div(new fix(8).prod(new fix(k)).sum(new fix(5)))).sub(new fix(1).div(new fix(8).prod(new fix(k)).sum(new fix(6))))
      ));
    }
    return pi;
  }
  fix val(){
    if (prec < cachePrec){
      int dp = abs(prec)+8;
      new fix().hiPrec(dp);
      cache = calc().val.shiftRight(8);
      cachePrec = prec+8;
      new fix().loPrec(dp);
    }
    return new fix(cache,cachePrec);
  }
  
  
}

static abstract class fixConst_e_cache extends fixConst{
  static BigInteger cache = BigInteger.ONE.shiftLeft(1).add(BigInteger.ONE);
  static int cachePrec = 0;
} 
class fixConst_e extends fixConst_e_cache{
  String toString(){ return "const(e)";}
  fixConst_e(){
  }
  
  fix val(){
    if (prec < cachePrec){
      int dp = abs(prec)+8;
      new fix().hiPrec(dp);
      cache = new fix(1).e().val.shiftRight(8);
      cachePrec = prec+8;
      new fix().loPrec(dp);
    }
    return new fix(cache,cachePrec);
  }
  
  
}

static abstract class fixConst_ln2_cache extends fixConst{
  static BigInteger cache = BigInteger.ONE;
  static int cachePrec = 0;
} 
class fixConst_ln2 extends fixConst_ln2_cache{
  String toString(){ return "const(ln(2))";}
  fixConst_ln2(){
  }
  
  fix val(){
    if (prec < cachePrec){
      int dp = abs(prec)+8;
      new fix().hiPrec(dp);
      cache = ((fix)new fix(1).div(new fix(1).e().log2())).val.shiftRight(8);
      cachePrec = prec+8;
      new fix().loPrec(dp);
    }
    return new fix(cache,cachePrec);
  }
  
  
}


static abstract class fixConst_r2_cache extends fixConst{
  static BigInteger cache = BigInteger.ONE;
  static int cachePrec = 0;
} 
class fixConst_r2 extends fixConst_r2_cache{
  String toString(){ return "const(√2)";}
  fixConst_r2(){
  }
  
  fix val(){
    if (prec < cachePrec){
      int dp = abs(prec)+8;
      new fix().hiPrec(dp);
      cache = new fix(2).sqrt().val.shiftRight(8);
      cachePrec = prec+8;
      new fix().loPrec(dp);
    }
    return new fix(cache,cachePrec);
  }
  
}
