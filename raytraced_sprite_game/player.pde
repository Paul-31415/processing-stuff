

class sprite extends traceable{
  traceable graphic;
  camera cam;
  pcolor[][] screen;
  int[][] screenN;
  vec pos,vel,accel;
  int w,h;
  int depth=8;
  sprite(traceable t,camera c,int W, int H){graphic = t;cam = c;w=W;h=H;
    pos = new vec();
    vel = pos.copy();
    accel = vel.copy();
  }
  void step(double dt){
    pos.addEq(vel.scale(dt));
    vel.addEq(accel.scale(dt));
  }
  PImage draw(int samples,traceable scene){
    PImage res = new PImage(w,h,RGB,1);
    res.loadPixels();
    for(int y = 0; y < h; y ++){
      for(int x = 0; x < w; x ++){
        ray r = cam.get((x-w/2.)/w,(y-h/2.)/h);
        pcolor result = new pcolor(0,0,0);
        for (int i = 0; i < samples; i++){
          result.addEq(graphic.traceScene(new pcolor(0,0,0),r,scene,depth));
        }
        result.divEq(samples);
        res.pixels[y*w+x] = result.toColor();
      }
    }
    return res;
  }
  hit trace(ray r){
    return graphic.trace(r);
  }
}



/*class player extends sprite{
  player(traceable t){super(t);}
  
}*/
