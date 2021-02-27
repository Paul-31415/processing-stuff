int[][] world;
int[][] newWorld;

void setup(){
  size(512,512);
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
      //world[x][y] = (int)(4*pow(random(1),3));
    }
  }
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

boolean in(int v, int[] arr){
  for( int o : arr){
    if(o == v){
      return true;
    }
  }
  return false;
}

float[] probs = {0.2,0.2,0.2,0.2};

void step(){
  for (int x = 1; x <= width; x ++){
    for (int y = 1; y <= height; y ++){
      int[] n = getNeighbors(x,y);
      int a = world[x][y];
      for(int e = 3; e >= 0 ; e--){
        if( a == e && in((e+1)%4,n) && random(1)<probs[e]){
          newWorld[x][y] = (e+1)%4;
          e = -1;
        }
      }
    }
  }
  for (int x = 0; x <= width+1; x ++){
    for (int y = 0; y <= height+1; y ++){
      world[x][y] = newWorld[x][y];
    }
  }
}

void generateForever(){
  while (true){
    step();
  }
}
  

color[] COLORS = {color(32,32,32),color(240,220,100),color(150,0,150),color(250,80,20),color(64,16,16)};
void draw(){
  for (int x = 1; x <= width; x ++){
    for (int y = 1; y <= height; y ++){
      set(x-1,y-1,COLORS[world[x][y]]);
    }
  }
  
  if (keyPressed){
    if (key == '1')
      world[mouseX+1][mouseY+1] = 1;
    if (key == '2')
      world[mouseX+1][mouseY+1] = 2;
    if (key == '3')
      world[mouseX+1][mouseY+1] = 3;
    if (key == '0')
      world[mouseX+1][mouseY+1] = 0;
    if (key == '4')
      world[mouseX+1][mouseY+1] = 4;
      
    if (key == 'q')
      probs[0] = ((float)mouseX)/width;
    if (key == 'w')
      probs[1] = ((float)mouseX)/width;
    if (key == 'e')
      probs[2] = ((float)mouseX)/width;
    if (key == 'r')
      probs[3] = ((float)mouseX)/width;
    
    
    
  }
  //for (int i = 0; i < 10; i ++)
    step();  
}