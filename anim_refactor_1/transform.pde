interface transform{
  Point apply(Point p);
}

class coordTransform implements transform{
    Point x,y,z,w;
    coordTransform inverseCache;
    boolean cacheValid;
    coordTransform(){
      x = new Point(1,0,0,0);
      y = new Point(0,1,0,0);
      z = new Point(0,0,1,0);
      w = new Point(0,0,0,1);
      cacheValid = false;
    }
    
    String toString(){
      return "transform["+x.x+",\t"+y.x+",\t"+z.x+",\t"+w.x+"\t]\n" +
             "         ["+x.y+",\t"+y.y+",\t"+z.y+",\t"+w.y+"\t]\n" +
             "         ["+x.z+",\t"+y.z+",\t"+z.z+",\t"+w.z+"\t]\n" +
             "         ["+x.w+",\t"+y.w+",\t"+z.w+",\t"+w.w+"\t]\n";
      
    }
    coordTransform(Point X,Point Y,Point Z,Point W){
      x = X;y = Y;z = Z;w = W;}
    Point apply(Point p){
      return x.mtimes(p.x)
      .mplusEq( y.mtimes(p.y) )
      .mplusEq( z.mtimes(p.z) )
      .mplusEq( w.mtimes(p.w) ); 
    }
    /*transform(Q q){
      coordTransform t1 = new coordTransform(
      new Point(q.r,-q.v.z,q.v.y,-q.v.x),
      new Point(q.v.z,q.r,-q.v.x,-q.v.y),
      new Point(-q.v.y,q.v.x,q.r,-q.v.z),
      new Point(q.v.x,q.v.y,q.v.z,q.r));
      
      x = new Point(q.r,-q.v.z,q.v.y,q.v.x);
      y = new Point(q.v.z,q.r,-q.v.x,q.v.y);
      z = new Point(-q.v.y,q.v.x,q.r,q.v.z);
      w = new Point(-q.v.x,-q.v.y,-q.v.z,q.r);
       
      this.semitEq(t1);
    }*/
    coordTransform copy(){return new coordTransform(x.copy(),y.copy(),z.copy(),w.copy());}
    
    coordTransform times(coordTransform o){
      return new coordTransform(apply(o.x),apply(o.y),apply(o.z),apply(o.w));}
    coordTransform timesEq(coordTransform o){
      cacheValid = false;
      Point tmpx = apply(o.x);
      Point tmpy = apply(o.y);
      Point tmpz = apply(o.z);
     this.w = apply(o.w);
     this.z = tmpz;
     this.y = tmpy;
     this.x = tmpx;
     return this;}
    coordTransform semit(coordTransform o){
      return o.times(this);}
    coordTransform semitEq(coordTransform o){
      x = o.apply(this.x);
      y = o.apply(this.y);
      z = o.apply(this.z);
      w = o.apply(this.w);
    return this;}
    
    coordTransform transpose(){
       return new coordTransform(
       new Point(x.x,y.x,z.x,w.x),
       new Point(x.y,y.y,z.y,w.y),
       new Point(x.z,y.z,z.z,w.z),
       new Point(x.w,y.w,z.w,w.w));      
    }
    coordTransform inverse(){
      if (!cacheValid){
      //output undefined for noninvertible transformations
      double[][] work = new double[][] {
        new double[] {x.x,y.x,z.x,w.x,1,0,0,0},
        new double[] {x.y,y.y,z.y,w.y,0,1,0,0},
        new double[] {x.z,y.z,z.z,w.z,0,0,1,0},
        new double[] {x.w,y.w,z.w,w.w,0,0,0,1}};
        
      for(int col = 0;col < 4; col++){
         
         int maxRow = col;
         for(int row = col+1;row < 4; row++){
           if (Math.abs(work[row][col]) > Math.abs(work[maxRow][col]))
             maxRow = row;
         }
         //swap row with maxRow
         double[] tmp = work[col];
         work[col] = work[maxRow];
         work[maxRow] = tmp;
         //normalize row
         for (int i = 7; i >=col; i--){
           work[col][i] /= work[col][col];
           
         }
         
         //zero other entries
         for(int row = 0; row < 4; row++){
           if(row != col){
             //println(">"+row+","+col+":"+work[row][col]);
             for (int i = 7; col <= i ; i--){
               //println("D"+row+","+i+":"+work[row][i]);
               //println("S"+col+","+i+":"+work[col][i]);
               work[row][i] -= work[col][i]*work[row][col];
               //println("d"+row+","+i+":"+work[row][i]);
             }
             
           }
         }
         
         /*for (double[] dd : work){
           for (double d : dd){
             print(d+"\t");
           }
           print('\n');
         }
         print('\n');*/
      }
      //rref complete
      inverseCache = new coordTransform(
      new Point(work[0][4],work[1][4],work[2][4],work[3][4]),
      new Point(work[0][5],work[1][5],work[2][5],work[3][5]),
      new Point(work[0][6],work[1][6],work[2][6],work[3][6]),
      new Point(work[0][7],work[1][7],work[2][7],work[3][7]));
      cacheValid = true;
      }
      return inverseCache.copy();
    }
    
    /*Point apply(vector v){
      Point p = apply(((vnd)v).toPoint()); 
      return ((vnd)v).mask(new vnd(p.x,p.y,p.z,p.w));
    }*/
}
