PImage img;
PImage hide;

int noise = 0;
int hvol = 1 ;
int bits = 2;
boolean enc = false;
void setup(){
  size(1434,2852);
  background(255);
  img  = loadImage("test.png");
  hide = loadImage("stego1m.png");
  image(img,0,0);
  if (enc){
    image(hide,0,height/2);
  }
  loadPixels();
  int mask = (0xff>>bits)<<bits;
  int cmask = mask ^ 0xff;
  for (int n = 0; n < width*height/2; n++){
    if (enc){
      color c = (color) pixels[n];
      color h = (color) pixels[ width*height/2+n];
      //int bg = ((((int)red(c))>>noise) << noise) + (int)(Math.random()*(1<<noise)) ;
      //int s = ((int)(red(h))>>(8-hvol));
      //int r = ((bg>>hvol) <<hvol) + s ;
      pixels[n] = color(((int)red(c)&mask) | (((int)red(h)>>(8-bits))&cmask),
                  ((int)green(c)&mask) | (((int)green(h)>>(8-bits))&cmask),
                  ((int)blue(c)&mask) | (((int)blue(h)>>(8-bits))&cmask));
    }else{
      color c = (color) pixels[n];
      pixels[n] = color(((int)red(c)&cmask)<<(8-bits),
                        ((int)green(c)&cmask)<<(8-bits),
                        ((int)blue(c)&cmask)<<(8-bits));
    }
  }
  updatePixels();
  PImage res = get(0,0,width,height/2);
  save("result.png");
}
