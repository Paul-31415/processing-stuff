

class stringy implements chary{
  public chary[] chars;
  stringy(chary... c){
    chars = c;
  }
  
  float[] put(float... xy){
    float depth = 0;
    if (xy.length>2){
      depth = xy[2];
    }else{
      xy = new float[] {xy[0],xy[1],0};
    }
    for(chary c : chars){
      xy[2] = depth;
      xy = c.put(xy);
    }
    return xy;
  }
  stringy concat(stringy... others){
    int l = chars.length;
    for(stringy s: others){
      l += s.length();
    }
    chary[] c = new chary[l];
    for(int i = 0;i < chars.length; i++)
      c[i] = chars[i];
    int i = chars.length;
    for(stringy s: others){
      for(chary ch: s.chars){
        c[i] = ch;
        i++;
      }
    }
    return new stringy(c);
  }
  
  int length(){
    return chars.length;
  }
  
}

class img implements chary{
  PImage pimage;
  float ox;
  float oy;
  float sx;
  float sy;
  float w;
  
  img(PImage i){
    pimage = i;
    ox = 0;
    oy = 0;
    sx = i.width;
    sy = i.height;
    w = sx;
  }
  img(PImage i, float wi, float h){
    pimage = i;
    ox = 0;
    oy = 0;
    sx = wi;
    sy = h;
    w = sx;
  }
  img(PImage i, float wi, float h, float x, float y){
    pimage = i;
    ox = x;
    oy = y;
    sx = wi;
    sy = h;
    w = sx;
  }
  img(PImage i, float wi, float h, float x, float y, float widt){
    pimage = i;
    ox = x;
    oy = y;
    sx = wi;
    sy = h;
    w = widt;
  }
  
  float width(){
    return w;
  }
  
  float[] put(float... xy){
    image(pimage,xy[0]+ox,xy[1]+oy,sx,sy);
    xy[0]+= w;
    return xy;
  }
  
}


class formattedString implements chary{
  String content;
  float ox;
  float oy;
  color c;
  float size;
  PFont font; 
  formattedString(String ct,float x, float y, color cl, float siz,PFont f){
    content = ct;
    ox = x;
    oy = y;
    c = cl;
    size = siz;
    font = f;
  }
  formattedString(String ct, color cl, float siz){
    content = ct;
    ox = 0;
    oy = 0;
    c = cl;
    size = siz;
    font = new PFont();
  }
  formattedString(String ct){
    content = ct;
    ox = 0;
    oy = 0;
    c = color(0);
    size = 11;
    font = new PFont();
  }
  void setup(){
    textSize(size);
    fill(c);
    //textFont(font);
  }
  float[] put(float... xy){
    setup();
    xy[0]+=ox; xy[1]+=oy;
    text(content,xy[0],xy[1]);
    xy[0]+=textWidth(content);
    return xy;
  }
  float width(){
    setup();
    return textWidth(content);
  }
  
}

class cOffset implements chary{
  float ox;
  float oy;
  cOffset(float x, float y){
    ox = x;
    oy = y;
  }
  float width(){
    return ox;
  }
  float[] put(float... xy){
    xy[0] += ox;
    xy[1] += oy;
    return xy;
  }
}
