interface volume{
  //expresses a volume
  abstract boolean intersects(volume other);
  abstract boolean intersects(dvector other); //tests if point is inside volume
  //abstract dvector candidatePoint(volume other);
}

class nullVolume implements volume{
  nullVolume(){
  }
  boolean intersects(volume other){ return false;}
  boolean intersects(dvector other){ return false;}
  //dvector candidatePoint(volume other){
  //}
}



interface collidable{
  boolean doesIntersect(dvector start, dvector move);// finds if n s.t. start + (n*move) is on boundary, 1>n>0
  double findIntersect(dvector start, dvector move); // finds n s.t. start + (n*move) is on boundary
  boolean near(dvector start, dvector move); // implements a fast check to see if findIntersect should be used
}