

double[][] world;


void setup(){
  size(128,128);
  world = new double[width][height];
  for( int x = 0; x < world.length ; x++){
    
    for( int y = 0; y < world[0].length ; y++){
      world[x][y] = 0;
      //world[width-1][y] = 0;
    }
    if(x < width) 
      world[x][0] = sin(3.14159*((float)x*2)/width);
    //world[x][height-1] = 1;
  }
 
}

void draw(){
  //double[][] newWorld = new double[width][height];
  for( int i = 1; i < 100 ; i++){
  for( int x = 1; x < world.length-1 ; x++){
    for( int y = 1; y < world[0].length-1 ; y++){
      world[x][y] = (world[x][y-1]+world[x-1][y]+world[x+1][y]+world[x][y+1])/4.0;
      set(x,y,color((int)((world[x][y]+1)*127)));
      
    }
  }
  
  }
  //world = newWorld;
  
}