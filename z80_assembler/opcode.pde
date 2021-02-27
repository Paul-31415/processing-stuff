
interface opcode extends chary{
  abstract byte[] bytes(); //compiled code bytes
  abstract int byteLength(); //for labels
  abstract boolean isValid(); //has no errors (eg: jr out of range, ld h,ixl, bit c,b...)
  abstract int cycles(state in); // clock cycles
  abstract state apply(state in);
}
//can use instanceof opcode

//zero argument opcodes:
abstract class zero_arg_opcode implements opcode{
  byte[] bytes;
  int byteLength() { return bytes.length;}
  boolean isValid() { return true;}
  byte[] bytes() { return bytes;}
  
  String name;
  float width() { 
    return textWidth(name);
  }
  float[] put(float... xy){
    text(name,xy[0],xy[1]);
    xy[0] += this.width();
    return xy;
  }
  
}
  
class o_nop extends zero_arg_opcode{
  o_nop(){}
  byte[] bytes = new byte[] {0};
  int cycles(state in) { return 4;}
  state apply(state in){ return in;}
  String name = "nop";
}
class o_rlca extends zero_arg_opcode{
  o_rlca(){}
  byte[] bytes = new byte[] {0x07};
  int cycles(state in) { return 4;}
  state apply(state in){ in.af[0] =(byte)((in.af[0]<<1) | ((in.af[0]&0x80)>>7)); in.af[1] =(byte)((in.af[1]&0xfe) | (in.af[0]&0x01)); return in;}
  String name = "rlca";
}
