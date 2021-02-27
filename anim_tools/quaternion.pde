

class Q{
  public double r;
  public vec v;
   Q(){ 
     r = 1;
     v = new vec();
   }
   Q(double R){ 
     r = R;
     v = new vec();
   }
   Q(double R, double x, double y, double z){ 
     r = R;
     v = new vec(x,y,z);
   }
   Q(vec rot){
     double m = rot.mag();
     r = Math.cos(m/2);
     v = rot.times(Math.sin(m/2));
   }
   Q(double R, vec V){
     r = R;
     v = V;
   }
   double mag2(){
     return r*r+v.mag2();
   }
   double mag(){
     return Math.sqrt(mag2());
   }
   
   Q normalized(){ 
     double m = mag();
     return new Q(r/m,v.over(m));
   }
   Q normalizedEq(){ 
     double m = mag();
     r/=m;
     v.overEq(m);
     return this;
   }
   
   Q inverse(){
     double m = mag2();
     return new Q(r/m,v.negative().overEq(m));
   }
   Q inverseEq(){
     double m = mag2();
     r/=m;
     v.negativeEq().overEq(m);
     return this;
   }
   
   Q conj(){return new Q(r,v.negative());}
   Q conjEq(){r = -r; v.negativeEq();return this;}
   
   
   Q plus(Q o){return new Q(r+o.r,v.plus(o.v));}
   Q plusEq(Q o){r+=o.r;v.plusEq(o.v); return this;}
   
   Q rtimes(double s){
     return new Q(r*s,v.times(s));
   }
   Q rtimesEq(double s){
     r*=s;v.timesEq(s);
     return this;
   }
   
   Q times(Q o){
     return new Q(r*o.r-v.dot(o.v),o.v.times(r).plusEq(v.times(o.r)).plusEq(v.cross(o.v)));
   }
   Q timesEq(Q o){
     double tmpr=r;
     r*=o.r;
     r-=v.dot(o.v);
     vec crs = v.cross(o.v);
     vec tmpv = v.times(o.r);
     o.v.timesEq(tmpr).plusEq(tmpv).plusEq(crs);
     return this;
   }
   Q semit(Q o){
     return new Q(r*o.r-v.dot(o.v),o.v.times(r).plusEq(v.times(o.r)).plusEq(o.v.cross(v)));
   }
   Q semitEq(Q o){
     double tmpr=r;
     r*=o.r;
     r-=v.dot(o.v);
     vec crs = o.v.cross(v);
     vec tmpv = v.times(o.r);
     o.v.timesEq(tmpr).plusEq(tmpv).plusEq(crs);
     return this;
   }
   double dot(Q o){return r*o.r+v.dot(o.v);}
   
   Q over(Q o){return times(o.inverse());}
   Q overEq(Q o){return timesEq(o.inverse());}
   Q revo(Q o){return inverse().semitEq(o);}
   Q revoEq(Q o){return inverseEq().semitEq(o);}
   
   // A suffix for angular operations
   vec applyA(vec p){return times(new Q(0,p)).v;} 
   Q plusA(Q o){ return semit(o);}
   Q plusAEq(Q o){ return semitEq(o);}
   
   Q minusA(Q o){  return o.conj().semitEq(this);}
   Q minusAEq(Q o){  return timesEq(o.conj());}
   
   Q plusA(vec av){ return plusA(new Q(av));}
   Q plusAEq(vec av){ return plusAEq(new Q(av));}
 
   vec axisAngle(){
     double theta = 2 * Math.atan2(v.mag(),r);
     double s = Math.sin(theta/2);
     if (s < 1e-32){
       return new vec();
     }
     if (Math.abs(theta)>Math.PI){
       double f = (theta + (theta > 0 ? -2 : 2) * Math.PI);
       return v.times(f/s);
     }
     return v.times(theta/s);
   }
   
   
}
