
byte rlca(byte a){
  return (byte)((a<<1)|((a>>7)&1));
}
byte rrca(byte a){
  return (byte)((a>>1)|((a<<7)&128));
}
int rlca(int a){
  return ((a<<1)|((a>>7)&1));
}
int rrca(int a){
  return (((a&0xff)>>1)|((a&1)*0x180));
}
int rla(int a){
  return ((a<<1)|((a>>8)&1));
}
int rra(int a){
  return (((a&0x1ff)>>1)|((a&1)*0x100));
}
int adc(int a,int b){
  return (a&0xff)+(b&0xff)+((a>>8)&1);
}
int sbc(int a,int b){
  return (a&0xff)+((-b-((a>>8)&1))&0xff);
}
int add(int a,int b){
  return (a&0xff)+(b&0xff);
}
int sub(int a,int b){
  return (a&0xff)+((-b)&0xff);
}
int cp(int a, int o){
  return (a&0xff)|(sub(a,o)&0x100);
}

byte subdaa(byte a, byte b){
  int r = a-b;
  
  
  return (byte)r;
}
byte rra(byte a,boolean c){
  return (byte)((a>>1)|(c?128:0));
}
byte rla(byte a,boolean c){
  return (byte)((a>>1)|(c?1:0));
}

int x = 1;
byte[] next(byte[] s){
   /*
  //crc-like
  int v = ((s[1]<<8)&0xff00)|(s[0]&0xff);
  //println(v);
  v = (v<<1) ^ ((v&0x8000)!=0?x:0);
  v++; //tryin to get a period of 65536
  
  //these do 4051 13659 22063 24065 36623 45069 50177
  //00001111 11010011', '0011010101011011', '0101011000101111', '0101111000000001', '1000111100001111', '1011000000001101', '1100010000000001
  
  s[0] = (byte)v;
  s[1] = (byte)(v>>8);
  */
  
  //attempt n at 16 bit FAST prng good enough for audio
  int r0 = s[0]&0xff;
  int r1 = s[1]&0xff;
  
  //this one works for x = 8591
  r1 = sub(rrca((r0^0xff)-1),r1);
  r0 = (adc(cp(r1,x&0xff),r0)^(x/256));
  
  
  s[0] = (byte)r0;
  s[1] = (byte)r1;
  
  //gets to 65535 with x=4070
  //r1 = add(rrca((r0^0xff)-1),r1); 
  //r0 = (sbc(cp(r1,x&0xff),r0)^(x/256));
  
  
  //s[2] = (byte) (s[2]+s[0]);
  //s[1] = (byte) (((byte)(rrca((byte)((s[0]^0xff)-1))+(s[1]))^s[2]));
  //s[0] = (byte) (((s[1]-s[0])^x));
  
  //s[0] = (byte)((rrca((byte)((s[0]^0xff)))^s[0]+s[0]+1)^x);
  
  
  
  
  //for x = 124, period = 16727629/16777216
  
  
  //old
  //r1 = add(rrca((r0^0xff)-1),r1);
  //r0 = (sub(r1,r0)^(x&0xff));
  // for x = 162, period = 65511
  //misses 24:
/* 
34 3 - cycle 13
93 16 - cycle 11
138 21
17 26
131 70
103 79
37 90
254 90
134 126
180 135
237 141
90 172
62 173
17 183
238 185
4 186
150 186
113 193
20 197
211 197
15 206
33 224
250 238
84 240
109 241
*/
  
  
  //s[1] = (byte) (((byte)(rrca((byte)((s[0]^0xff)-1))-(s[1]))));
  //s[0] = (byte) (((rrca((byte)((s[1]-s[0])))+s[1])+1)^x);//29
  

  return s;
}
boolean[] gotten = new boolean[256*256];
int period(){
  for (int i = 0; i < gotten.length; i++){
    gotten[i] = false;}
  byte[] state = new byte[] {0,0};
  byte[] s = next(new byte[] {0,0});
  int i = 1;
  while (neq(s,state)){
    gotten[(s[0]&0xff)+256*(s[1]&0xff)]=true;//+256*(s[1]&0xff)+65536*(s[2]&0xff)] = true;
    s = next(s);
    s = next(s);
    state = next(state);
    i ++;
  }
  return i;
}
boolean neq(byte[] a, byte b[]){
  for (int i = 0; i < a.length; i ++){
    if (a[i] != b[i]){
      return true;
    }
  }return false;}
    
int[] mxs = new int[65536];
void setup(){
  int ind = 0;
  int m=0;
  int mx = 0;
  for (int i = 0; i < 256*256; i++){
    x = i;//162;//i;
    int p = period();
    println(p);
    //for (int i = 0; i < 65536; i++){
    //if(gotten[i] == false)
      //println(i%256,i/256);
    //}
    if (p>m){mx = x;
      m = p;}
    if (p == 65536){
      mxs[ind] = x;
      ind++;
      background(0);
    }
  }
  println("");
  println(mx);
  println(m);
  print(":");
  for(int i = 0; i < ind; i++){
    print(mxs[i]);
    print(",");
  }
  //println(1<<16); */
}
