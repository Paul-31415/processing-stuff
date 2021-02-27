PImage img;
PImage hide;

int sizex = 5;
int sizey = 5;

boolean enc = false;
void setup(){
  size(664,664);
  background(255);
  img  = loadImage("Tnmy3x0.png");
  image(img,0,0);
  if (enc)
    image(hide,0,720);
  loadPixels();
  for (int x = 0; x < width;x+= sizex){
    for (int y = 0; y < height; y += sizey){
      boolean res = false;
      for (int lx = 0; lx < sizex; lx++){
        for (int ly = 0; ly < sizey; ly++){
          if (x+lx+ width*(y+ly) < pixels.length){
          //int r = (int)red((color)pixels[x+lx+ width*(y+ly)]);
          res ^= red((color)pixels[x+lx+ width*(y+ly)]) > 128;
          //if (!(r == 0 | r == 255)){print("!");}
          }
        }
      }
      float r = res?255:0;
      for (int lx = 0; lx < sizex; lx++){
        for (int ly = 0; ly < sizey; ly++){
          if (x+lx+ width*(y+ly) < pixels.length)
          pixels[x+lx+ width*(y+ly)] = color(r,r,r);
        }
      }
    }
  }
  updatePixels();
  PImage res = get(0,0,width,height/2);
  save("result.png");
}
