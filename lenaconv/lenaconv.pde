


PImage img;
byte[] dat;
void setup(){
  img = loadImage("lena-64x64.jpg");
  dat = new byte[6+64*64];
  dat[0] = 45;
  dat[1] = 64;
  dat[2] = (byte)128;
  dat[3] = (byte)192;
  dat[4] = 64;
  dat[5] = 64;
  //print(dat[3]);
  size(64,64);
  image(img,0,0);
  loadPixels();
  for (int i = 0; i < (width*height); i++) {
    dat[6+i] = (byte)red(pixels[i]);
  }
  //print(dat[6]);
  print("\n[");
  for (byte b: dat){
    int v = b;
    if (b<0)
      v = b + 256;
    print(v+",");
  }
  print("]");
}