abstract class t{
  abstract color get(color p, float w);
}
abstract class txt{
  abstract PImage apply(PImage i);
}

class TImage{
  txt[] texture;
  PImage image;
  TImage(PImage i, txt[] t){
    texture = t;
    image = i;
  }
  
  PImage get(){
    PImage r = image.copy();
    for(txt t: texture){
      r = t.apply(r);
    }
    return r;
  }
  
}

class txt_pos extends txt{
  int x,y;
  t v;
  txt_pos(t V, int X, int Y){v=V;x=X;y=Y;}
 
  PImage apply(PImage i){
    i.set(x,y,v.get(i.get(x,y),1)); 
    return i;
  }
}

class t_overlay extends t{
  color c;
  t_overlay(color C){c = C;}
  t_overlay(int r, int g, int b){c = color(r,g,b);}
  t_overlay(int r, int g, int b, int a){c = color(r,g,b,a);}
  color get(color p, float w){
    float a = alpha(c)*w;
    return color((int)(red(c)*a+red(p)*(1-a)),
    (int)(green(c)*a+green(p)*(1-a)),
    (int)(blue(c)*a+blue(p)*(1-a)),
    alpha(p));
  }
  
  
}
