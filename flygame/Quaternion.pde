class angle{
  double r,i,j,k;
  angle(){
    r=1;i=0;j=0;k=0;
  }
  String toString(){
    return "angle("+r+","+i+","+j+","+k+")";
  }
  angle randAngle()
  {
    vec v = new vec(randomGaussian(),randomGaussian(),randomGaussian()).norm();
    return fromAxisAngle(v.scaleEq(random(PI)));
  }
  angle(double a,double b,double c,double d){
    r=a;i=b;j=c;k=d;
  }
  angle _times(angle o) {
        return new angle(
            this.r * o.r - this.i * o.i - this.j * o.j - this.k * o.k,
            this.r * o.i + this.i * o.r + this.j * o.k - this.k * o.j,
            this.r * o.j - this.i * o.k + this.j * o.r + this.k * o.i,
            this.r * o.k + this.i * o.j - this.j * o.i + this.k * o.r);
  }
  double _dot(angle o) {
        return this.r * o.r + this.i * o.i + this.j * o.j + this.k * o.k;
  }
  angle _add(angle o) {
      return new angle(this.r + o.r, this.i + o.i, this.j + o.j, this.k + o.k);
  }
  angle fromAxisAngle(double x, double y , double z ) {
        final double mag = Math.sqrt(x * x + y * y + z * z);
        if (mag < 0.00000000001) {
            return new angle(1, 0, 0, 0);
        }
        final double f = Math.sin(mag / 2) / mag;
        return new angle(Math.cos(mag / 2), f * x, f * y, f * z);
    }
  angle fromEuler(double x, double y, double z){
     return new angle(); 
  }
  angle fromAxisAngle(vec v){return fromAxisAngle(v.x,v.y,v.z);}
  angle fromEuler(vec v){return fromEuler(v.x,v.y,v.z);} 
    angle plus(angle o ) {
        return o._times(this);
    }
    angle plusV(double[] v, double dt) {
        final double mag = Math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
        if (mag == 0) {
            return this;
        }
        final double f = Math.sin(mag * dt / 2) / mag;
        return this.plus(new angle(Math.cos(mag * dt / 2), v[0] * f, v[1] * f, v[2] * f));
        //return this.add(new QuaternionAngle(0, v[0] * dt / 2, v[1] * dt / 2, v[2] * dt / 2).times(this)).normalized();                    
    }

    angle mulinverse() {
        final double mag2 = this.r * this.r + this.i * this.i + this.j * this.j + this.k * this.k;
        return new angle(this.r / mag2, -this.i / mag2, -this.j / mag2, -this.k / mag2);
    }
    angle inverse() {
        return new angle(this.r, -this.i, -this.j, -this.k);
    }
    double[] apply(double x, double y, double z) {
        angle res = this._times(new angle(0, x, y, z))._times((this.inverse()));
        return new double[] {res.i, res.j, res.k};
    }
    vec apply(vec v){
      return new vec(this.apply(v.x,v.y,v.z));
    }
    angle minus( angle o){
        return o.inverse().plus(this);
    }
    angle scale(double n) { //to be used only for angular vel                                                                                 
        return new angle(this.r * n, this.i * n, this.j * n, this.k * n);

    }
    angle normalized() {
        final double mag = Math.sqrt(this.r * this.r + this.i * this.i + this.j * this.j + this.k * this.k);
        return new angle(this.r / mag, this.i / mag, this.j / mag, this.k / mag);
    }
    double[] axis() {
        final double mag = Math.sqrt(this.i * this.i + this.j * this.j + this.k * this.k);
        if (mag == 0) {
            return new double[]{1, 0, 0};
        } else {
            return new double[]{this.i / mag, this.j / mag, this.k / mag};
        }
    }
    double angle() {
        final double mag = Math.sqrt(this.i * this.i + this.j * this.j + this.k * this.k);
        return 2 * Math.atan2(mag, this.r);
    }
    double[] axisAngle() {
        final double mag = Math.sqrt(this.i * this.i + this.j * this.j + this.k * this.k);
        final double theta = 2 * Math.atan2(mag, this.r);
        final double s = Math.sin(theta / 2);
        if (s < 0.00000000001) {
            return new double[]{0, 0, 0};
        }
        if (Math.abs(theta) > Math.PI) {
            final double f = (theta + (theta > 0 ? -2 : 2) * Math.PI);
            return new double[]{f * this.i / s, f * this.j / s, f * this.k / s};
        }
        return new double[] {theta * this.i / s, theta * this.j / s, theta * this.k / s};
    }
    double[] eulerAngle(){
      double phi = Math.atan2(2*r*i+j*k,1-2*(i*i+j*j));
      double theta = Math.asin(2*(r*j-i*k));
      double psi = Math.atan2(2*r*k+i*j,1-2*(j*j+k*k));
      return new double[]{phi,theta,psi};
    }
    vec eulerVec(){
      double phi = Math.atan2(2*r*i+j*k,1-2*(i*i+j*j));
      double theta = Math.asin(2*(r*j-i*k));
      double psi = Math.atan2(2*r*k+i*j,1-2*(j*j+k*k));
      return new vec(phi,theta,psi);
    }
    PMatrix3D toMatrix() {
    return toMatrix(new PMatrix3D());
    }
    PMatrix3D toMatrix(PMatrix3D out){
      float w = (float)r;
      float x = (float)i;
      float y = (float)j;
      float z = (float)k;
      /*out.set((float)(1-(y*y*2+z*z*2)),(float)(x*y*2-w*z*2),(float)(x*z*2+w*z*2),0,
              (float)(x*y*2+w*z*2),(float)(1-(x*x*2+z*z*2)),(float)(y*z*2+w*x*2),0,
              (float)(x*z*2*w*y*2),(float)(y*z*2+w*x*2),(float)(1-(x*x*2+y*y*2)),0,
              0,0,0,1);
      */
      float x2 = x + x; float y2 = y + y; float z2 = z + z;
    float xsq2 = x * x2; float ysq2 = y * y2; float zsq2 = z * z2;
    float xy2 = x * y2; float xz2 = x * z2; float yz2 = y * z2;
    float wx2 = w * x2; float wy2 = w * y2; float wz2 = w * z2;
    out.set(
      1.0 - (ysq2 + zsq2), xy2 - wz2, xz2 + wy2, 0.0,
      xy2 + wz2, 1.0 - (xsq2 + zsq2), yz2 - wx2, 0.0,
      xz2 - wy2, yz2 + wx2, 1.0 - (xsq2 + ysq2), 0.0,
      0.0, 0.0, 0.0, 1.0);
      return out;
    }
    void push(){
      pushMatrix();
      applyMatrix(toMatrix());
    }
    void rotate_(){
      applyMatrix(toMatrix());
      //double[] rots = eulerAngle();
      //rotateZ((float)rots[2]);
      //rotateX((float)rots[0]);
      //rotateY((float)rots[1]);
      
      
    }
    void unrotate_(){
      applyMatrix(inverse().toMatrix());
      //double[] rots = eulerAngle();
      //rotateY(-(float)rots[1]);
      //rotateX(-(float)rots[0]);
      //rotateZ(-(float)rots[2]);
      
    }
}
