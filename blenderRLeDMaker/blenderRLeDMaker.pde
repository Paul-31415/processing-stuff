int start = 1;
int step = 16;

int fw = 40;
int fh = fw;

int w = 6;
int h = 18;

PImage mask;
PImage sprite;
void setup(){
  
  PImage frame = loadImage("/tmp/"+String.format("%04d", start)+".png");
  
  //size(168,168); //28
  //size(192,192); //32
  //size(384,384); //64
  //size(432,432); //72
  //size(864,864); //144
  size(240,720); //lv
  
  
  background(0);
  for(int y = 0; y < h; y++){
    for(int x = 0; x < w; x++){
      image(frame,x*fw,y*fh,fw,fh);
      start += step;
      frame = loadImage("/tmp/"+String.format("%04d", start)+".png");
    }
  }
  
  sprite = get();
  sprite.save("sprite.png");
  
  start -= step*h*w;
  frame = loadImage("/tmp/"+String.format("%04d", start)+".png");
  for(int y = 0; y < h; y++){
    for(int x = 0; x < w; x++){
      int i = 0;
      for(int iy = 0; iy < fh; iy++){
      for(int ix = 0; ix < fw; ix++){
        
          if (alpha(frame.pixels[i])>0){
            set(x*fw+ix,y*fh+iy,color(255));
          }
          i++;
        }
      }
      //image(frame,x*fw,y*fh,fw,fh);
      start += step;
      frame = loadImage("/tmp/"+String.format("%04d", start)+".png");
    }
  }
  
  mask = get();
  mask.save("mask.png");
  
  image(sprite,0,0);
}
