abstract class drawable extends stepable implements Comparable<drawable> {
  dvector pos;
  boolean removeMeFromDrawables = false;
  
  abstract void draw(dvector offset,dvector scale,dvector drawOffset);
  boolean visible(dvector offset,dvector scale,dvector drawOffset){
   return pos.simple3dUnnormalized(offset,scale).get(2)>0;
  }
  int compareTo(drawable other){
    return ((Double)other.pos.get(2)).compareTo(this.pos.get(2));
  } //closer sprites are "greater than" farther sprites (on the z direction)
  
}