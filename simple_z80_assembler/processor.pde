class track{
  color col;
  track(){
    col = color(0);}
  track(color c){
    col = c;}
  track copy(){
    return new track(col);}
}
class trackedBit{
  boolean val;
  track trk;
  trackedBit(boolean v, track c){
    val = v;
    trk = c;
  }
  boolean val(){
    return val;}
}
class trackedByte{
  short val;
  trackedByte copy(){
    track[] t = new track[8];
    for(int i = 0; i < 8; i ++){
      t[i] = trks[i].copy();
    }
    return new trackedByte(val,t);
  }
  track[] trks;
  byte val(){
    return (byte)val;}
  int uVal(){
    return val&0xff;}
  color[] getCharCols(){
    color[] c = new color[8];
    for(int i = 0; i < 8; i ++){
      c[7-i] = trks[i].col;
    }
    return c;
  }
  trackedByte(){
    val = 0;
    trks = new track[] {new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track()};
  }
  trackedByte(color base){
    val = 0;
    trks = new track[8];
    for(int i = 0; i < 8 ; i++){
      trks[i] = new track(scaleColor(base,.5+i/16.));
    }
  }
  trackedByte(short v, track[] c){
    val = v;
    trks = c;
    assert trks.length == 8;
  }
  trackedByte( trackedBit... b){
    assert b.length == 8;
    trks = new track[8];
    val = 0;
    for(int i = 0; i < 8 ; i ++){
      if (b[i].val)
        val += 1<<i;
      trks[i] = b[i].trk;
    }
  }
  trackedBit[] split(){
    trackedBit[] b = new trackedBit[8];
    for(int i = 0; i < 8 ; i ++){
      b[i] = new trackedBit( (val&(1<<i))!=0, trks[i]);
    }
    return b;
  }
}
class trackedShort{
  int val;
  short val(){
    return (short)val;}
  int uVal(){
    return val&0xffff;}
  track[] trks;
  trackedShort(){
    val = 0;
    trks = new track[] {new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track(),new track()};
  }
  trackedShort(color base){
    val = 0;
    trks = new track[16];
    for(int i = 0; i < 16 ; i++){
      trks[i] = new track(scaleColor(base,1/3.+i/24.));
    }
  }
  trackedShort(int v, track[] c){
    val = v;
    trks = c;
    assert trks.length == 16;
  }
  trackedShort(trackedByte lo, trackedByte hi){
    val = (lo.val&0xff) | (hi.val<<8);
    for(int i = 0; i < 8 ; i ++){
      trks[i] = lo.trks[i];
      trks[i+8] = hi.trks[i];
    }
  }
  trackedByte[] split(){
    track[] l = new track[8];
    track[] h = new track[8];
    for(int i = 0; i < 8 ; i ++){
      l[i] = trks[i];
      h[i] = trks[i+8];
    }
    trackedByte lo = new trackedByte((short)(val&0xff),l);
    trackedByte hi = new trackedByte((short)(val>>8),h);
    return new trackedByte[] { lo, hi};
  }
}

class z80{
  trackedByte[] mem;
  trackedByte a;
  trackedByte f;
  trackedShort afPRIME;
  
  trackedByte b;
  trackedByte c;
  trackedByte d;
  trackedByte e;
  trackedByte h;
  trackedByte l;
  trackedShort bcPRIME;
  trackedShort dePRIME;
  trackedShort hlPRIME;
  
  trackedShort pc;
  trackedShort sp;
  trackedShort ix;
  trackedShort iy;
  
  trackedByte r;
  trackedByte i;
  
  z80(){
    /*mem = new trackedByte[65536];
    for(int i = 0 ; i < 65536; i++){
      mem[i] = new trackedByte();
    }*/
    
    a = new trackedByte(color(255,0,0));
    b = new trackedByte(color(0,0,255));
    c = new trackedByte(color(0,255,255));
    d = new trackedByte(color(128,64,64));
    e = new trackedByte(color(192,128,0));
    f = new trackedByte(color(192,192,192));
    h = new trackedByte(color(255,192,0));
    l = new trackedByte(color(255,255,0));
    
    i = new trackedByte(color(255,255,255));
    r = new trackedByte(color(64,192,64));
    
    afPRIME = new trackedShort();
    bcPRIME = new trackedShort();
    dePRIME = new trackedShort();
    hlPRIME = new trackedShort();
    
    ix = new trackedShort();
    iy = new trackedShort();
    sp = new trackedShort();
    pc = new trackedShort();
    
  }
  void ex(Object a,Object b){
    Object tmp = a;
    a = b;
    b = tmp;
  }
  
}

/*boolean add(trackedByte other){
    val = val & 0xff;
    for(int i = 0; i < 8; i ++){
      cols[i] += other.cols[i];
    }
    val += other.val & 0xff;
    boolean carry = val > 0xff;
    val = val & 0xff;
    return carry
  }*/
