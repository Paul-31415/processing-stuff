
class vector{
  float[] v;
  
  //vector(float[] val){
  //  v = val;
  //}
  
  vector(float... x){
    v = x;
  }
  
  vector cull(){
    int len = v.length;
    for(int i = v.length-1;i >= 0; i--){
      if(v[i] != 0)
        break;
      len --;
    }
    float[] a = new float[len];
    for(int i = 0;i < len ;i++){
      a[i] = v[i];
    }
    return new vector(a);
  }
  
  float get(int i){
    if(i < v.length)
     return v[i];
    return 0;
  }
  
  void set(int i, float val){
    if(i < v.length)
      v[i] = val;
    else{
      float[] w = new float[i+1];
      for(int a = 0; a < w.length-1; a ++){
        w[a] = this.get(a);
      }
      w[w.length-1] = val;
      v = w;
    }
  }
  
  float dot(vector b){
    float total = 0.0;
    int min = min(v.length,b.v.length);
    for(int i = 0; i < min; i++){
      total += v[i]*b.get(i);
    }
    return total;
  }
  
  vector cross(vector b){ //assumes ≤ 3d
    return new vector(this.get(1)*b.get(2)-this.get(2)*b.get(1),this.get(2)*b.get(0)-this.get(0)*b.get(2),this.get(0)*b.get(1)-this.get(1)*b.get(0));
  }
  
  vector copy(){
    float[] c = new float[v.length];
    for(int i = 0; i < v.length; i++){
      c[i] = v[i];
    }
    return new vector(c);
  }
  
  vector add(vector... s){
    int maxd = v.length;
    for (vector a:s){
      if(a.v.length>maxd)
        maxd = a.v.length;
    }
    float[] ans = new float[maxd];
    for(int i = 0; i < maxd; i++){
      ans[i] = this.get(i);
    }
    for (vector a:s){
      for(int i = 0; i < a.v.length; i++){
        ans[i] += a.v[i];
      }
    }
    return new vector(ans).cull();
  }
  vector mul(vector... s){
    int maxd = v.length;
    for (vector a:s){
      if(a.v.length>maxd)
        maxd = a.v.length;
    }
    float[] ans = new float[maxd];
    for(int i = 0; i < maxd; i++){
      ans[i] = this.get(i);
    }
    for (vector a:s){
      for(int i = 0; i < a.v.length; i++){
        ans[i] *= a.v[i];
      }
    }
    return new vector(ans).cull();
  }
  
  float mag2(){
    float tot = 0;
    for(int i = 0; i < v.length; i++){
      tot += v[i]*v[i];
    }
    return tot;
  }
  
  float mag(){
    return sqrt(this.mag2());
  }
  
  vector scale(float m){
    float[] ans = new float[v.length];
    for(int i = 0; i < v.length; i++){
      ans[i] = v[i]*m;
    }
    return new vector(ans);
  }
  
  vector rotate(float theta, int i, int j){
    vector ans = this.copy();
    float s = sin(theta);
    float c = sin(theta);
    ans.set(i,this.get(i)*c+this.get(j)*s);
    ans.set(j,this.get(j)*c-this.get(i)*s);
    return ans;
  }
  vector normalize(){
    return this.scale(1/this.mag());
  }
  
  vector polar(){
    if( v.length > 1){
    float m2 = this.mag2();
    float r = sqrt(m2);
    vector ans = this.copy();
    ans.set(0,r);
    for(int i = 1; i < v.length-1; i++){
      m2 -= v[i-1]*v[i-1];
      ans.set(i,atan2(sqrt(m2),v[i-1]));
    }
    ans.set(v.length-1,atan2(v[v.length-1],m2+v[v.length-2]));
    return ans;
    }else{
      return this.copy();
    }
  }
  
  vector cartesian(){
    if( v.length > 1){
    float sp = 1;
    vector ans = this.copy();
    for(int i = 1; i < v.length ; i++){
      ans.set(i-1,sp*v[0]*cos(v[i]));
      sp *= sin(v[i]);
    }
    ans.set(v.length-1,sp*v[0]);
    return ans;
    }else{
      return this.copy();
    }
  }
}

vector[] points;
vector[] pointsV;
void setup(){
  size(256,256);
  background(0);
  points = new vector[2];
  pointsV = new vector[2];
  for (int i = 0; i < points.length; i++){
    points[i] = new vector(0,i*32);
    pointsV[i] = new vector(0,0);
  }
  
}
float g = 0.1;
void draw(){
  vector old = new vector(0,0);
  stroke(color(255));
  for (int i = 0; i < points.length; i++){
    line(old.get(0)+width/2,old.get(1),points[i].get(0)+width/2,points[i].get(0));
    old = points[i];
  }
  for (int i = 0; i < points.length; i++){
    points[i] = points[i].add(pointsV[i]);
    pointsV[i].set(1,pointsV[i].get(1)+g);
  }
  for (int i = 0; i < points.length; i++){
    points[i] = points[i].add(pointsV[i]);
    pointsV[i].set(1,pointsV[i].get(1)+g);
  }
}
