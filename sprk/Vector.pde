class dvector{
  double[] v;
  boolean[] e;
  //dvector(double[] val){
  //  v = val;
  //}
  
  dvector(double... x){
    v = x;
    e = new boolean[v.length];
    for(int i = 0; i < v.length; i ++)
      e[i] = true;
  }
  
  dvector(boolean[] d,double[] x){
    v = x;
    e = d;
  }
    
  
  dvector cull(){
    int len = v.length;
    for(int i = v.length-1;i >= 0; i--){
      if(e[i])
        break;
      len --;
    }
    double[] a = new double[len];
    boolean[] b = new boolean[len];
    for(int i = 0;i < len ;i++){
      a[i] = v[i];
      b[i] = e[i];
    }
    return new dvector(b,a);
  }
  
  double get(int i){
    if(i < v.length)
     if(e[i])
      return v[i];
    return 0;
  }
  double get(int i,double def){
    if(i < v.length)
     if (e[i])
      return v[i];
    return def; 
  }
  
  void set(int i, double val){
    if(i < v.length){
      v[i] = val;
      e[i] = true;
    }else{
      double[] w = new double[i+1];
      boolean[] f = new boolean[i+1];
      for(int a = 0; a < v.length; a ++){
        w[a] = v[a];
        f[a] = e[a];
      }
      for(int a = v.length; a < i; a ++){
        f[a] = false;
      }
      w[i] = val;
      f[i] = true;
      v = w;
      e = f;
    }
  }
  void clear(int i){
    if (i < e.length){
      e[i] = false;
      v[i] = 0;
    }
  }
  
  double dot(dvector b){
    double total = 0.0;
    int min = min(v.length,b.v.length);
    for(int i = 0; i < min; i++){
      total += v[i]*b.get(i);
    }
    return total;
  }
  
  dvector cross(dvector b){ //assumes ≤ 3d
    return new dvector(this.get(1)*b.get(2)-this.get(2)*b.get(1),this.get(2)*b.get(0)-this.get(0)*b.get(2),this.get(0)*b.get(1)-this.get(1)*b.get(0));
  }
  
  dvector copy(){
    double[] c = new double[v.length];
    boolean[] d = new boolean[v.length];
    for(int i = 0; i < v.length; i++){
      c[i] = v[i];
      d[i] = e[i];
    }
    return new dvector(d,c);
  }
  
  dvector add(dvector... s){
    int maxd = v.length;
    for (dvector a:s){
      if(a.v.length>maxd)
        maxd = a.v.length;
    }
    double[] ans = new double[maxd];
    boolean[] anse=new boolean[maxd];
    for(int i = 0; i < v.length; i++){
      ans[i] = v[i];
      anse[i] = e[i];
    }
    for(int i = v.length; i < maxd; i++){
      ans[i] = 0;
      anse[i] = false;
    }
    
    for (dvector a:s){
      for(int i = 0; i < a.v.length; i++){
        ans[i] += a.get(i);
        anse[i] |= a.e[i];
      }
    }
    return new dvector(anse,ans).cull();
  }
  dvector mul(dvector... s){
    int maxd = v.length;
    for (dvector a:s){
      if(a.v.length>maxd)
        maxd = a.v.length;
    }
    double[] ans = new double[maxd];
    boolean[] anse=new boolean[maxd];
    for(int i = 0; i < v.length; i++){
      ans[i] = v[i];
      anse[i] = e[i];
    }
    for(int i = v.length; i < maxd; i++){
      ans[i] = 1;
      anse[i] = false;
    }
    for (dvector a:s){
      for(int i = 0; i < a.v.length; i++){
        ans[i] *= a.v[i];
        anse[i] |= a.e[i];
      }
    }
    return new dvector(anse,ans).cull();
  }
  
  double mag2(){
    double tot = 0;
    for(int i = 0; i < v.length; i++){
      if(e[i])
       tot += v[i]*v[i];
    }
    return tot;
  }
  
  double mag(){
    return Math.sqrt(this.mag2());
  }
  
  dvector scale(double m){
    double[] ans = new double[v.length];
    for(int i = 0; i < v.length; i++){
      ans[i] = v[i]*m;
    }
    return new dvector(e,ans);
  }
  
  dvector rotate(double theta, int i, int j){
    dvector ans = this.copy();
    double s = Math.sin(theta);
    double c = Math.sin(theta);
    ans.set(i,this.get(i)*c+this.get(j)*s);
    ans.set(j,this.get(j)*c-this.get(i)*s);
    return ans;
  }
  dvector normalize(){
    return this.scale(1/this.mag());
  }
  
  dvector polar(){
    if( v.length > 1){
    double m2 = this.mag2();
    double r = Math.sqrt(m2);
    dvector ans = this.copy();
    ans.set(0,r);
    for(int i = 1; i < v.length-1; i++){
      double a = 0;
      if(e[i-1])
        a = v[i-1];  
      m2 -= a*a;
      ans.set(i,Math.atan2(Math.sqrt(m2),a));
    }
    ans.set(v.length-1,Math.atan2(this.get(v.length-1),m2+this.get(v.length-2)));
    return ans;
    }else{
      return this.copy();
    }
  }
  
  dvector cartesian(){
    if( v.length > 1){
    double sp = 1;
    dvector ans = this.copy();
    for(int i = 1; i < v.length ; i++){
      ans.set(i-1,sp*v[0]*Math.cos(v[i]));
      sp *= Math.sin(v[i]);
    }
    ans.set(v.length-1,sp*v[0]);
    return ans;
    }else{
      return this.copy();
    }
  }
  dvector simple3d(dvector ofs, dvector scale, dvector dofs){
    dvector un = this.add(ofs).mul(scale);
    return un.scale(1/(un.get(2))).add(dofs);
  }
  dvector simple3dUnnormalized(dvector ofs, dvector scale){
    return this.add(ofs).mul(scale);
  }
}