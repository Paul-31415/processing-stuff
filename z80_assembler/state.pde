


class state{
  
  byte[] af; //af
  byte[] _af;//af`
  byte[] regs;//b-e, hl
  byte[] _regs;//b`-e`, hl`
  byte[] eregs;// ix, iy, i, r
  short pc;
  short sp;
  boolean[] ff;//iff1, iff2
  byte[] memory;
  state(){
    af = new byte[] {0,0};
    _af = new byte[] {0,0};
    regs = new byte[] {0,0,0,0,0,0};
    _regs = new byte[] {0,0,0,0,0,0};
    eregs = new byte[] {0,0,0,0,0,0};
    pc = 0;
    sp = 0;
    ff = new boolean[] {false,false};
    
    memory = new byte[65536];
  }
 
  
}
