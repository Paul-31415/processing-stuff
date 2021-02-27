
int[] hvol = {1,0,0};

boolean enc = false ;


String pt = "The tale of the lemming revolution is a grave one indeed...\nHundreds of years ago, there was a lemming named Something Orother.\nEvery few days, the lemmings woul^g`?PQ!-=<!LWv<the lemmings woul^g`?PQ!-=<!LWv<lemmings woul^g`?PQ!-=<!LWv<s woul^g`?PQ!-=<!LWv<s woul^g`?PQ!-=<!LWv<g`?PQ!-=<!LWv<!-=<!LWv<!-=<!LWv<!-=<!LWv<LWv<LWv<LWv<Wv<Wv<v<^><v<>6>]\n pHOtM=4w. :h9U)ings woul^g`?ings woul^g`?ings woul^g`?\neXVvd{pM&8B8l{H!{Fk(\nG)n18H!{H!{H!{H!{H!{\ngpJZ&w^cj.9,A41 b1H_mfK<]tea_mfK<]tea\n !7=ImPC_mfK<]tea_mfK<]tea_mfK<]tea_mfK<]tea_mfK<]tea\ni&\nS]},U\n \nm='<d\nay\nt~*iFE,F%732735738741|10111011112Cake is a form of sweet dessert that is typically baked. In its oldest forms, cakes were modifications of breads, but cakes now cover a wide range of preparations ...\nt=+6uCa\ne7xkMDs\n \nbm'&S\ne|eNlLorem ipsum dolor sit amet, consectetur adipiscing elLorem ipsum dolor sit amet, consectetur adipiit ...\ne;j_]H?Hk$QJ#\\KGh_mfK<]teati\nsbi~}=u$NNNNNNNNNNNNNNNNNNNNNNNNNNNN3@!8;eatime is over, childildildildrdredrdrenrenrenrennrenennnnnñ\n";
int setBit(boolean v, int p, int n){
  if(v)
    return n | (1<<p);
  else
    return n & ~(1<<p);
}

void setup(){
  size(1117,1117);
  background(255);
  PImage in;
  String res = "";
  if (!enc){
    in = loadImage("Tnmy3x0.png");
    image(in,0,0);
  }
  loadPixels();
  boolean[] dat = new boolean[width*height*24];
  for(int i = 0; i < dat.length;i++)
    dat[i] = false;
  if (enc){
    for(int i = 0; i < pt.length() ; i ++){
      byte chr = (byte) pt.charAt(i);
      //System.out.println(chr);
      for (int b = 7; b >= 0 ; b --){
        dat[8*i+b] = (chr%2) == 1;
        chr >>= 1;
        //System.out.print(dat[8*i+b]);
      }
    }
  }
  int indx = 0;
  for (int n = 0; n < width*height; n++){
    if (enc){
      int[] rgb = {(int)red((color)pixels[n]),(int)green((color)pixels[n]),(int)blue((color)pixels[n])};
      for (int v = 0; v < 3 ; v ++){
        for(int i = 0 ; i < hvol[v] ; i++){
          rgb[v] = setBit(dat[indx],i,rgb[v]);
          indx ++;
        }
      }
      pixels[n] = color(rgb[0],rgb[1],rgb[2]);
    }else{
      color c = pixels[n];
      int[] rgb = {(int)red(c),(int)green(c),(int)blue(c)};
      for (int v = 0; v < 3 ; v ++){
        for(int i = 0 ; i < hvol[v] ; i++){
          dat[indx] = (1 == ((rgb[v]>>i)%2));
          //System.out.print(dat[indx]);
          indx ++;
        }
      }
      //System.out.println(red(c) + "  " + rgb[0] + "," + rgb[1] + "," + rgb[2]);
    }
  }
  if (!enc){
    for(int i = 0; i < indx/8 ; i ++){
      int chr = 0;
      for (int b = 0; b < 8 ; b ++){
        chr = (chr<<1) + (dat[8*i+b]?1:0);
        //System.out.print(dat[8*i+b]);
      }
      if (chr>0 || true);
      
        res += (char) chr;
        //res += hx(chr>>4);
        //res += hx(chr&15);
        //System.out.print((int)chr+",");
    }
    //System.out.println(res);
    char[] r = res.toCharArray();
    byte[] rb = new byte[r.length];
    for (int i = 0; i < r.length; i++)rb[i] = (byte)r[i];
    saveBytes("egg.m4a",rb);
    println("done.");
  }else{
    updatePixels();
    save("colorbind.png");
  }
}
char hx(int i){
  return i < 10?(char)(((char)i)+'0'):(char)(((char)i-10)+'A');
}
