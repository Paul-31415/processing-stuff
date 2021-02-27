Image bg; 
float gain = 1;
spectrum foregroundColor = new spectrum(new double[] {532}, new double[] {1});
float brushSize = 10;
renderer activeRenderer = new frenderRenderer(new roughCIE()); //new blurRenderer(new roughCIE(),new double[] {532,10000}, new int[] {3,1});// new frenderRenderer(new roughCIE());
renderer filter = new frenderRenderer(new cfilt(700,750,new roughCIE()));
void setup(){
  size(812,819);
  matlabLoader m = new matlabLoader();
  bg = m.getImage();
  
  kernal k = new kernal(new double[][][] { new double[][] { new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, }, new double[][] { new double[] {
    
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, }, new double[][] { new double[] {
    
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .2,.2,.2,.2,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1, 1,  1, 1, 1,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, }, new double[][] { new double[] {
    
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04, .1,.1,.1,.1,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, }, new double[][] { new double[] {
    
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, new double[] {
    .04,.04,.04,.04,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0,}, }},-1,-1);
  print("\nfiltering\n");
                                 //          b         c         g         y         r         r         y    
    int[] divisors = new int[]    {64,64,64,32,  16, 8, 4, 4,   4, 2, 1, 1,   1, 2, 4, 4,   8, 8, 8, 8,   8, 8, 8, 8,  16,16,16,16,  16,16,16};//64,64,32,32,  16,16,16,8,  8,8,4,4,  4,2,2,1,  1,1,1,2,  2,2,4,4,  4,8,8,8,  16,16,16};
    double[] gains = new double[] { 1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1, 1, 1, 1,   1,.8,.6,.4,  .3,.2,.1};//0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0,0,  0,0,0};
    double[] quants= new double[] { 2, 1,.8,.6,  .4,.3,.2,.2,  .1,.03,.01,.01,  .01,.03,.1,.1,  .2,.2,.2,.2,  .2,.3,.4,.5,  .6,.7,.9,1,  2,3,4};
    double[] dither = quants;
    spectrum from = new spectrum(5778,bg.pixels[0][0].wavelengths);
    spectrum to = new spectrum(6554,bg.pixels[0][0].wavelengths);
    for(int i = 0; i < gains.length; i++){
      gains[i] *= to.values[i]/from.values[i];
    }
    
    int h = bg.pixels[0].length;
    int w = bg.pixels.length;
    Image r = new Image(w,h,bg.pixels[0][0].wavelengths);
    for(int y = 0; y < h; y+= 1){ 
      for(int x = 0; x < w; x+= 1){
        for(int i = 0; i < divisors.length; i ++){
          r.pixels[y][x].values[i] = bg.tryGet(x,y,bg.pixels[0][0]).values[i];
        }
      }
    }
    for(int i = 0; i < divisors.length; i ++){
      for(int y = 0; y < h; y+= divisors[i]){ 
        for(int x = 0/*w/2*/; x < w; x+= divisors[i]){
          double v = 0;
          for(int iy = 0; iy < divisors[i]; iy++){ 
            for(int ix = 0; ix < divisors[i]; ix++){
              v += bg.tryGet(x+ix,y+iy,bg.pixels[0][0]).values[i];
            }
          }
          v /= divisors[i]*divisors[i];
          v *= gains[i];
          v += Math.random()*dither[i]/2;
          v = v-(v % quants[i]);
          for(int iy = 0; iy < divisors[i]; iy++){ 
            if (y+iy < h){
              for(int ix = 0; ix < divisors[i]; ix++){
                if (x+ix < w){
                  r.pixels[y+iy][x+ix].values[i] = v;
                }
              }
            }
          }
        }
      }
    }

  bg = r;
  //bg = new Image(bg, new pixelateGen( new int[] {8,8,8,8,  8,8,8,8,  8,8,8,8,  4,4,4,4,  2,2,2,2,  1,1,1,1,  1,1,1,1,  1,1,1}));
  
  //bg = new Image(width,height);
  image(activeRenderer.render(bg,gain),0,0);
  //print(bg.pixels[0][0].values[0]);
}


void draw(){
 if(mousePressed){
   for(int y = (int)(mouseY-brushSize); y <= (int)(mouseY+brushSize); y++){ 
    for(int x = (int)(mouseX-brushSize); x <= (int)(mouseX+brushSize); x++){
      if(square(x-mouseX)+square(y-mouseY) <= brushSize*brushSize){
        bg.trySet(x,y,foregroundColor);
      }
    }
  }
  image(activeRenderer.render(bg,gain,(int)(mouseX-brushSize)-1,(int)(mouseY-brushSize)-1,(int)(brushSize*2)+2,(int)(brushSize*2)+2),(int)(mouseX-brushSize)-1,(int)(mouseY-brushSize)-1);
 }
 
}

void keyPressed(){
  if(key == '+'){
    gain *= 1.125;
  }
  if(key == '-'){
    gain /= 1.125;
  }
  if(key == '_'){
    gain /= 4;
  }
  if(key == 'p'){
    
    
  }
  if(key == '0'){
    bg.cached = false;
    activeRenderer = new frenderRenderer(new roughCIE());
  }if(key == 'f'){
    bg.cached = false;
    activeRenderer = filter;
  }if(key == '1'){
    bg.cached = false;
    ((cfilt)((frenderRenderer) filter).r).low -= 10;
    print(((cfilt)((frenderRenderer) filter).r).low);
  }if(key == '2'){
    bg.cached = false;
    ((cfilt)((frenderRenderer) filter).r).high -= 10;
    print(((cfilt)((frenderRenderer) filter).r).high);
  }if(key == '3'){
    bg.cached = false;
    ((cfilt)((frenderRenderer) filter).r).low += 10;
    print(((cfilt)((frenderRenderer) filter).r).low);
  }if(key == '4'){
    bg.cached = false;
    ((cfilt)((frenderRenderer) filter).r).high += 10;
    print(((cfilt)((frenderRenderer) filter).r).high);
  }if(key == '6'){
    bg.cached = false;
    activeRenderer = new frenderRenderer(new cfilt(450,500,new roughCIE()));
  }if(key == '7'){
    bg.cached = false;
    activeRenderer = new frenderRenderer(new cfilt(400,450,new roughCIE()));
  }if(key == '8'){
    bg.cached = false;
    activeRenderer = new frenderRenderer(new cfilt(350,300,new roughCIE()));
  }if(key == '9'){
    bg.cached = false;
    activeRenderer = new frenderRenderer(new cfilt(700,750,new roughCIE()));
  }
  
  image(activeRenderer.render(bg,gain),0,0);
}
