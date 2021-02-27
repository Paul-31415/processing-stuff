int[][] chars = new int[128][];
boolean done = false;

int cWidth;
int cHeight;
char c = 0;
void before(){
  if(done){
    return;
  }
  
  done = true;//c == 127;
  
  fill(255);
  textSize(height);
  cWidth = width;
  cHeight = height;
  for (char c = 0; c < 128; c++){
    background(0);
    text(c,0,height*4/5);
    chars[c] = new int[width*height+2];
    loadPixels();
    chars[c][0] = height*width;
    chars[c][1] = 0;
    for( int i = 0; i < width*height; i++){
        chars[c][i+2] = pixels[i]&255;
        if (chars[c][i+2]>0){
          if (i < chars[c][0])
            chars[c][0] = i;
          if (i > chars[c][1])
            chars[c][1] = i;
        }
    }
  //c++;
  }
  //for( int i = 0; i < ; i ++)
    //print(chars['H'][i+2]);
}
color scaleColor(color c, float s){
  return color(red(c)*s,green(c)*s,blue(c)*s,alpha(c));
}
color setAlpha(color c, int a){
  return (c&0xffffff) | (a<<24);
}
color fadeColor(color c, float f){
  return color(red(c),green(c),blue(c),alpha(c)*f);
}

PImage getC(char ch, color[] colors){
  
    
  PImage img = createImage(cWidth,cHeight,ARGB);
  img.loadPixels();
  //print(chars[72].length);
  for( int i = 0; i < img.pixels.length; i++){
    img.pixels[i] = fadeColor(colors[min(colors.length-1,max(0,((i-chars[ch][0])*colors.length)/(chars[ch][1]-chars[ch][0])))],chars[ch][i+2]/255.);
  }
  img.updatePixels();
  return img;
}
void put(String s,float x, float y, int size, color[] colors){
  textSize(size);
  
  for(int i = 0; i < s.length(); i ++){
    putC(s.charAt(i),x,y,size,colors);
    x += textWidth(s.charAt(i));
  }
  
}

void putC(char ch, float x, float y, int size, color[] colors){
  if(!done){
    return;
  }
  // puts register C with colors 
  image(getC(ch,colors),x,y,size,size);
}
