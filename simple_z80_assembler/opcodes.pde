abstract class opcode{
  abstract byte[] compile();
  abstract boolean valid();
  abstract int size();
  abstract int time();
  abstract z80 put(float x, float y, z80 in);
  abstract z80 run(z80 in);
}


class ld extends opcode{
  String from;
  String to;
  byte[] bytes;
  int time;
  ld(String f, String t){
    from = f;
    to = t;
  }
  byte[] compile(){
    return bytes;
  }
  boolean valid(){
    return true;
  }
  int size(){
    return bytes.length;
  }
  int time(){
    return time;
  }
  z80 put(float x, float y, z80 in){
    
    return run(in);
  }
  z80 run(z80 in){
    
    return in;
  }
}
