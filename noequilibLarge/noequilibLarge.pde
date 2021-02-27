int[][] world;
int[][] newWorld;
float[] probs;
int types = 32;//6;//8;
void setup(){
  //fullScreen();
  size(384,256);
  probs = new float[types];
  for(int i = 0; i < types; i ++){
    probs[i] = .2;//0.1+0.5/(types+4)*i;
  }
    
  world = new int[width+2][height+2];
  newWorld = new int[width+2][height+2];
  for (int x = 0; x <= width+1; x ++){
    for (int y = 0; y <= height+1; y ++){
      world[x][y] = y==256?0:0;
      newWorld[x][y] = y==256?0:0;
    }
  }
  for (int x = 1; x <= width; x ++){
    for (int y = 1; y <= height; y ++){
      //world[x][y] = (int)(random(types));
    }
  }
  //thread("generateForever");
  //thread("generateForever");
  //thread("generateForever");
  //thread("generateForever");
}

int[] offs = {0,1,0,-1,0};
int[] getNeighbors(int x, int y){
  int[] res = {0,0,0,0};
  for (int i = 0; i < 4 ; i ++){
    res[i] = world[x+offs[i]][y+offs[i+1]];
  }
  return res;
}
boolean checkNeighbors(int v,int x, int y){
  
  for (int i = 0; i < 4 ; i ++){
    if (v == world[x+offs[i]][y+offs[i+1]])
      return true;
  }
  return false;
}

boolean in(int v, int[] arr){
  for( int o : arr){
    if(o == v){
      return true;
    }
  }
  return false;
}

int numThreads = 3;
int index = 0;

void stepThread(){
  int i = index++;
  while (i < width*height){
  int x = i/height + 1;
  int y = i%height + 1;
  //for (int x = 1; x <= width; x += numThreads){
    //for (int y = 1; y <= height; y ++){
      //int[] n = getNeighbors(x,y);
      int a = world[x][y];
      if((checkNeighbors((a+1)%types,x,y) && random(1)<probs[a]) || random(1)<0.000001*0){
        newWorld[x][y] = (a+1)%types;
        
      }else{
        newWorld[x][y] = a;
      }
      
    //}
  //}
  i = index++;
  }
}
int[][] tmp;
void step(){
  index = 0;
  for (int t = 1; t <= numThreads; t ++){
    thread("stepThread");
  }
  stepThread();
  
  tmp = world;
  world = newWorld;
  newWorld = tmp;
  
}

void generateForever(){
  while (true){
    step();
  }
}
color colorFunc(int v){
  float f = (float) v;
  return color((int)(255*wav(f/sqrt(29.))),(int)(255*wav(f/sqrt(17.))),(int)(255*wav(f/sqrt(7.))));
  
}
float wav(float v){
  float a = tri(v/2.)*2-1;
  a = (a - (a*a*a)/3.) *1.5;
  return a/2 + .5;
}
float tri(float v){
  return ((int) v)%2==0?v%1:1-(v%1);
}

void draw(){
  //if(random(1)<0.1)
    //world[width/2][height/2] = (world[width/2][height/2]+1)%types;
  for (int x = 1; x <= width; x ++){
    for (int y = 1; y <= height; y ++){
      set(x-1,y-1,colorFunc(world[x][y]));
    }
  }
  if (mousePressed)
    world[mouseX+1][mouseY+1] = (world[mouseX+1][mouseY+1]+1)%types;
  if (keyPressed){
      
    if (key == 'p')
      probs[(int)(mouseY*types/height)] = ((float)mouseX)/width;
    
    
    
    
  }
  //for (int i = 0; i < 10; i ++)
  
    step();  
  
}