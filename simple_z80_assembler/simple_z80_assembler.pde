

z80 z;
void setup(){
  size(256,256);
  before();
  background(0);
  //print(chars['n'][0]);
  z = new z80();
}


void draw(){
  //fill(color(200,200,255));
  //textSize(16);
  //text("ld",40,40);
  putC('a',10,0,16,z.a.getCharCols());
  putC('b',10,16,16,z.b.getCharCols());
  putC('c',10,32,16,z.c.getCharCols());
  putC('d',10,48,16,z.d.getCharCols());
  putC('e',10,64,16,z.e.getCharCols());
  putC('f',10,80,16,z.f.getCharCols());
  putC('h',10,96,16,z.h.getCharCols());
  putC('l',10,112,16,z.l.getCharCols());
  
  putC('i',10,128,16,z.i.getCharCols());
  putC('r',10,144,16,z.r.getCharCols());
  
  put("ixl",10,160,16,z.i.getCharCols());
}
