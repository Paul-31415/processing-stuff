PImage img;
void setup() {
  img = loadImage("tom-thumb-new.png");
  size(128,24);
  image(img,0,0,128,24);
  String ar = "{";
  int c = 0;
  loadPixels();
 for (int Y = 0 ; Y < 4 ; Y++){
  for(int X = 0 ; X < 32; X ++){
    for (int x = 0; x < 4 ; x++){
      //ar += "0b";
      ar += "{";
      for (int y = 0; y < 6 ; y++){
        color col = pixels[4*X+x + (6*Y+y) * width];
        if(col != -1){
          //ar += "1";
          ar += "{"+str(x)+","+str(y)+",elements.DEFAULT_PT_BRAY},";
        }else{
          //ar += "0";
        }
      }
      ar = ar.substring(0,ar.length()-1) + "},";
      //ar += "00, ";
    }   
    ar += "\n";
    c ++;
  }
 }
 ar += "}";
 System.out.println( ar);
}

void draw() {
  
}