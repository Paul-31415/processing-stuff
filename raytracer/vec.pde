class vec{
  double[] v;
  boolean[] e;
  //dvector(double[] val){
  //  v = val;
  //}
  
  String toString(){
    String ans = "vec(";
    for( int i = 0; i < v.length; i++){
      if (e[i]){
        ans += (v[i])+",";
      }else{
        ans += "?,";
      }
    }
    return ans + ")";
  }
  
  vec(double... x){
    v = x;
    e = new boolean[v.length];
    for(int i = 0; i < v.length; i ++)
      e[i] = true;
  }
  
  vec(boolean[] d,double[] x){
    v = x;
    e = d;
  }
    
  
  vec cull(){
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
    return new vec(b,a);
  }
  
  double get(int i){
    return get(i,0);
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
  
  double dot(vec b){
    double total = 0.0;
    int min = min(v.length,b.v.length);
    for(int i = 0; i < min; i++){
      total += v[i]*b.get(i);
    }
    return total;
  }
  
  vec cross(vec b){ //assumes ≤ 3d
    return new vec(this.get(1)*b.get(2)-this.get(2)*b.get(1),this.get(2)*b.get(0)-this.get(0)*b.get(2),this.get(0)*b.get(1)-this.get(1)*b.get(0));
  }
  
  vec copy(){
    double[] c = new double[v.length];
    boolean[] d = new boolean[v.length];
    for(int i = 0; i < v.length; i++){
      c[i] = v[i];
      d[i] = e[i];
    }
    return new vec(d,c);
  }
  
  vec add(vec... s){
    int maxd = v.length;
    for (vec a:s){
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
    
    for (vec a:s){
      for(int i = 0; i < a.v.length; i++){
        ans[i] += a.get(i);
        anse[i] |= a.e[i];
      }
    }
    return new vec(anse,ans).cull();
  }
   
  
  vec neg(){
    vec ans = this.copy();
    for (int i = 0; i < ans.v.length; i ++){
      if (ans.e[i]){
        ans.v[i] = -ans.v[i];
      }
    }
    return ans;
  }
  
  vec mul(vec... s){
    int maxd = v.length;
    for (vec a:s){
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
    for (vec a:s){
      for(int i = 0; i < a.v.length; i++){
        ans[i] *= a.v[i];
        anse[i] |= a.e[i];
      }
    }
    return new vec(anse,ans).cull();
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
  
  vec scale(double m){
    double[] ans = new double[v.length];
    for(int i = 0; i < v.length; i++){
      ans[i] = v[i]*m;
    }
    return new vec(e,ans).copy();
  }
  
  vec rotate(double theta, int i, int j){
    vec ans = this.copy();
    double s = Math.sin(theta);
    double c = Math.cos(theta);
    ans.set(i,this.get(i)*c+this.get(j)*s);
    ans.set(j,this.get(j)*c-this.get(i)*s);
    return ans;
  }
  vec normalize(){
    return this.scale(1/this.mag());
  }
  
  vec polar(){
    if( v.length > 1){
    double m2 = this.mag2();
    double r = Math.sqrt(m2);
    vec ans = this.copy();
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
  
  vec cartesian(){
    if( v.length > 1){
    double sp = 1;
    vec ans = this.copy();
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
  
  
  vec simple3d(vec ofs, vec scale, vec dofs){
    vec un = this.add(ofs).mul(scale);
    return un.scale(1/(un.get(2))).add(dofs);
  }
  vec simple3dUnnormalized(vec ofs, vec scale){
    return this.add(ofs).mul(scale);
  }
}

vec[] getOrthoBasis(vec... in){
  double epsilon = 0.000001;
  in = orthogonalize(in);
  int n = 0;
  for( int i = 0; i < in.length; i++){
    if (in[i].mag2() > epsilon){
      n ++;
    }
  }
  vec[] out = new vec[n];
  int j = 0;
  for( int i = 0; i < in.length; i++){
    if (in[i].mag2() > epsilon){
      out[j] = in[i];
      j ++;
    }
  }
  return out;
}

vec[] orthogonalize(vec... in){
  for( int i = 1; i < in.length; i++){
    for(int j = 0; j < i; j++){
      double m = in[j].mag2();
      if (m!=0)
        in[i] = in[i].add(in[j].scale(-in[i].dot(in[j])/m));
    }
  }
  return in;
}
