PImage p;
void setup(){
  size(700,700);
  
  
  p = loadImage("2ymshzm1cgc41.jpg");
  p.loadPixels();
  /*images[0] = new PImage(p.width,p.height);
  images[0].loadPixels();
  for (int i = 0 ; i < images[0].pixels.length;i++){
    images[0].pixels[i] = p.pixels[i];
  }
  images[0].updatePixels();
  */
 
  
  setImage1();
  
  //frameRate(60);
}
double gamma = 2.4;
double a = 0.948;
double b = 0.052;
double c = 0.077;
double d = 0.039;


void setImage1(){
  images = new PImage[2];
  for (int i = 0; i < images.length;i++) {
    images[i] = new PImage(p.width,p.height);
  }
  
  images[0].loadPixels();
  for (int i = 0 ; i < images[1].pixels.length;i++){
    images[0].pixels[i] = p.pixels[i];
  }
  images[0].updatePixels();
  
  images[1].loadPixels();
  for (int i = 0 ; i < images[1].pixels.length;i++){
    images[1].pixels[i] = invert(p.pixels[i]);
  }
  images[1].updatePixels();
}
void setImages(){
  images = new PImage[4];
  for (int i = 0; i < images.length;i++) {
    images[i] = new PImage(p.width,p.height);
  }
  images[0].loadPixels();
  for (int i = 0 ; i < images[0].pixels.length;i++){
    images[0].pixels[i] = boundedRandom(p.pixels[i]);
  }
  
  images[1].loadPixels();
  for (int i = 0 ; i < images[0].pixels.length;i++){
    images[1].pixels[i] = invert(images[0].pixels[i]);
  }
  
  
  images[2].loadPixels();
  for (int i = 0 ; i < images[0].pixels.length;i++){
    images[2].pixels[i] = subtract(p.pixels[i],images[0].pixels[i]);
  }
  
  
  images[3].loadPixels();
  for (int i = 0 ; i < images[0].pixels.length;i++){
    images[3].pixels[i] = invert(images[2].pixels[i]);
  }
  
  images[0].updatePixels();
  images[1].updatePixels();
  images[2].updatePixels();
  images[3].updatePixels();
}

color subtract(color a, color b){
    return color((int)(255*iresp(resp(red(a)/255)-resp(red(b)/255))),
  (int)(255*iresp(resp(green(a)/255)-resp(green(b)/255))),
  (int)(255*iresp(resp(blue(a)/255)-resp(blue(b)/255))));
}

color boundedRandom(color c){
  return color((int)random(red(c)),(int)random(green(c)),(int)random(blue(c)));
}
color invert(color c){
  return color((int)(255*iresp(1-resp(red(c)/255))),
  (int)(255*iresp(1-resp(green(c)/255))),
  (int)(255*iresp(1-resp(blue(c)/255))));
}



double resp(double x){
  if ( x<d){
    return c*x;
  }
  return Math.pow((a*x+b),gamma);
}

double iresp(double x){
  if ( x/c<d){
    return x/c;
  }
  return (Math.pow(x,1/gamma)-b)/a;
}

void keyPressed(){
  if (key == 'w'){
    gamma += .1;
  }
  if (key == 's'){
    gamma -= .1;
  }
  //setImages();
}
PImage[] images;

int i = 0;

void draw(){
  set(0,0,images[i]);
  i = (i+1)%images.length;
 
}
