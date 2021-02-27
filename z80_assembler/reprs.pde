abstract class repr{
  abstract String str(byte in);
  abstract String str(short in);
}

class binRepr extends repr{
  binRepr(){}
  String str(byte in){
    String res = "";
    for(int i = 0x80; i > 0; i >>= 1){
      res += (in&i)==0?"0":"1";
    } return res;
  }
  String str(short in){
    String res = "";
    for(int i = 0x8000; i > 0; i >>= 1){
      res += (in&i)==0?"0":"1";
    } return res;
  }
}

class hexRepr extends repr{
  hexRepr(){}
  final String[] digits = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"};
  String str(byte in){
    String res = "";
    for(int i = 4; i > 0; i -= 4){
      res += digits[(in&(0xf<<i))>>i];
    } return res;
  }
  String str(short in){
    String res = "";
    for(int i = 12; i > 0; i -= 4){
      res += digits[(in&(0xf<<i))>>i];
    } return res;
  }
}

class decRepr extends repr{
  decRepr(){}
  String str(byte in){
    return (String) in;
  }
  String str(short in){
    return (String) in;
  }
}
class udecRepr extends repr{
  udecRepr(){}
  String str(byte in){
    return (String) (((int)in)&0xff);
  }
  String str(short in){
    return (String) (((int)in)&0xffff);
  }
}
class decRepr extends repr{
  decRepr(){}
  String str(byte in){
    return (String) in;
  }
  String str(short in){
    return (String) in;
  }
}
