enum abstractionLevel { 
  Bit, Bits, Byte, Bytes
}

class allocation implements chary{
  ArrayList<allocation> parents;
  ArrayList<allocation> children;
  //ArrayList<allocation> semiChildren;
  //ArrayList<allocation> semiParents;
  //abstractionLevel level;
  stringy description;
  
  allocation addChild(allocation other){
    children.add(other);
    other.parents.add(this);
    return this;
  }
  allocation addParent(allocation other){
    other.children.add(this);
    parents.add(other);
    return this;
  }
//  ArrayList<operation> operations;
  allocation(stringy d){
    description = d;
    parents = new ArrayList<allocation>();
    children = new ArrayList<allocation>();
    //operations = new ArrayList<operation>();
  }
  stringy getTopLevelDescription(){
    return description;
  }
  chary getNestedDescription(int l){
    return description;
  }
  float[] put(float... xy){
    if(xy.length < 3){
      xy = new float[] {xy[0],xy[1],0};
    }
    
    //sorry...
    if (Float.floatToRawIntBits(xy[2]) == 0){
      return xy;
    }
    xy[2] = Float.intBitsToFloat(Float.floatToRawIntBits(xy[2])-1);
    
    return description.put(xy);
  }
  
}


    
class allocatedByte{
  allocation[] bitallocs;
  //allocation parentAlloc;
  short val;
  allocatedByte(byte v){
    bitallocs = new allocation[8];
    val = v;
  }
  //allocatedByte(byte v,allocation alloc){
  //  bitallocs = new allocation[8];
   // for(int i = 0)
  //  val = v;
  //}
  byte get(){
    return (byte)(val&0xff);
  }
  
  
  
  
}
