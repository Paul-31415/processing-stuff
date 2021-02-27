class convexHull{ //normals outwards
  plane[] planes;
  convexHull(plane[] p){
    planes = p;
  }
  
  boolean in(hvec p){
     for (plane pl : planes){
       if (!pl.side(p)){
         return false;
       }
     }
     return true;
  }
  
  
}
  
  
