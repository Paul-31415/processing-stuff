
/*void swap(Object a, Object b){
  Object c = a;
  a = b;
  b = c;
}*/
void swap(byte[] ar, int a, int b){
  byte c = ar[a];
  ar[a]=ar[b];
  ar[b]=c;
}
  

byte rot(byte a,int r){
  return (byte)((a >> r) | (a << (8-r)));
}

void r(byte[] a){
  a[0] ++;
  a[1] ^= a[0] & a[2] + 1;
  a[2] ^= rot((byte)(a[0] + a[1]),1);
  a[0] ^= a[1] + a[2] - 1;
/*
  ld a,(hl)
  inc hl
  ld c,(hl)
  inc hl
  ld d,(hl)
  
  inc a
  ld b,a
  and d
  inc a
  xor c
  ld c,a
  
  add b
  rra
  xor d
  ld d,a
  
  add c
  dec a
  xor b
  ;ld b,a
  
  ld (hl),a
  dec hl
  ld (hl),c
  dec hl
  ld (hl),b
  */
}
boolean comp(byte[] a, byte[] b){
  return (a[0] == b[0]) && (a[1] == b[1]) && (a[2] == b[2]);
  
}

void setup(){
  byte[] a = {0,0,0};
  
  byte[] ai = {a[0],a[1],a[2]};
  long n = 1;
  r(ai);
//  println(a);
  while( !comp(a,ai)){
    n ++;
    r(a);
    r(ai);
    r(ai);
  } 
  println(n);
  a = new byte[] {0,0,0};
  for( int i = 0; i < 10; i ++){
    r(a);
    println(a[0],a[1],a[2]);
  }
  
}