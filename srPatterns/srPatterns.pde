long mask = 0b0000000000000000001000000000000000000000000000000000000001010101L;
long state = 1L;
int len =  Long.numberOfLeadingZeros(1L)-Long.numberOfLeadingZeros(mask)+1;

float scale = 3;


void setup(){
  smooth(0);
  size(1002,1002);
  background(255);
  doThing();
}
void draw(){
}
long parity(long i){
  if(i == 0L)
    return 0;
  return 1L+parity(i&(i-1));
}

void doThing(){
  for(int i = 0; i < (height*len+width)/scale; i++){
    state = (state << 1)+(parity(state&mask)&1);
    put(i,(state&1)==1);
  }
}

void put(int x, boolean v){
  for(float i = 0; i < height; i += scale){
    line((v?x:x+1)*scale,i,(v?x+1:x)*scale,i+scale);
    x -= len;
  }
}
boolean smearFillDir(color c, color n, int dx, int dy,int sposeX, int sposeY, int smoveX, int smoveY){
  boolean did = false;
  for( ; sposeX < width && sposeX >= 0 && sposeY < width && sposeY >= 0; sposeX += smoveX, sposeY += smoveY){
    boolean on = false;
    for(int x = sposeX, y = sposeY ; x < width && x >= 0 && y < width && y >= 0; x += dx, y += dy){
      int p = get(x,y);
      if(p == n){
        on = true;
      }else {if(p != c){
        on = false;
      }else{
      did |= on;
      }}
      if (on){
        set(x,y,n);
      }
    }
  }
  return did;
}
void smearFill(color c, color n){
  //int i = 0;
  while((smearFillDir(c,n,1,0,0,0,0,1)||
  smearFillDir(c,n,-1,0,width-1,0,0,1)||
  smearFillDir(c,n,0,1,0,0,1,0)||
  smearFillDir(c,n,0,-1,0,height-1,1,0))){
    }
}
void fill(color c,color n, int x,int y){
  if (x < 0 || y < 0 || x >= width || y >= height)
    return;
  if(get(x,y) != c)
    return;
  ArrayList<int[]> pxls = new ArrayList<int[]>();
  ArrayList<int[]> newpxls = new ArrayList<int[]>();
  pxls.add(new int[] {x,y});
  set(x,y,n);
  while(pxls.size()>0){
    while(pxls.size()>0){
      int s = pxls.size();
      int[] p = pxls.get(s-1);
      if(p[0]+1 >= 0 && p[0]+1 < width && p[1] >= 0 && p[1] < height){
        if(get(p[0]+1,p[1]) == c){
          set(p[0]+1,p[1],n);
          newpxls.add(new int[]{p[0]+1,p[1]});
        }}
      
      if(p[0]-1 >= 0 && p[0]-1 < width && p[1] >= 0 && p[1] < height){
        if(get(p[0]-1,p[1]) == c){
          set(p[0]-1,p[1],n);
          newpxls.add(new int[]{p[0]-1,p[1]});
        }}
        
      if(p[0] >= 0 && p[0] < width && p[1]+1 >= 0 && p[1]+1 < height){
        if(get(p[0],p[1]+1) == c){
          set(p[0],p[1]+1,n);
          newpxls.add(new int[]{p[0],p[1]+1});
        }}
        
      if(p[0] >= 0 && p[0] < width && p[1]-1 >= 0 && p[1]-1 < height){
        if(get(p[0],p[1]-1) == c){
          set(p[0],p[1]-1,n);
          newpxls.add(new int[]{p[0],p[1]-1});
        }}
      
      
      pxls.remove(s-1);
    }
    ArrayList<int[]> t = pxls;
    pxls = newpxls;
    newpxls = t;
  }
  
  
  
  
  
  
  
  /*
  
  if(get(x,y) == c){
    do{
      x--;
    }while(get(x,y) == c && !(x < 0 || y < 0 || x >= width || y >= height));
    x++;
    int i = 0;
    do {
    set(x,y,n);
    i++;
    x++;
    }while(get(x,y) == c && !(x < 0 || y < 0 || x >= width || y >= height));
    while(i > 0){
      x--;
      fill(c,n,x,y-1);
      fill(c,n,x,y+1);
      i--;
    }
    
    
  } else{
    return;
  }*/
}
void keyPressed(){
  if(key == 'f'){
    for(int x = 0 ; x < width; x ++)
      for(int y = 0; y < height; y++)
        fill(color(255),color(random(1,255),random(1,255),random(1,255)),x,y);
  }
  if(key == '+'){
    state = 1L;
    len ++;
    background(255);
    doThing();
  }
  if(key == '-'){
    state = 1L;
    len --;
    background(255);
    doThing();
  }
}


void mousePressed(){
  fill(get(mouseX,mouseY),color(random(1,255),random(1,255),random(1,255)),mouseX,mouseY);


}
