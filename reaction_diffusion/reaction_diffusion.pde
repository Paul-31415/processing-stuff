float[][][] world;
float[][][] world2;
float[][][] tmp;
int speed = 6;
void setup(){
  size(32,512);
  background(0);
  world = new float[3][][];
  world2 = new float[world.length][][];
  tmp = new float[3][][];
  for (int d = 0; d < world.length ; d++){
    world[d] = new float[width][];
    world2[d] = new float[world[d].length][];
    tmp[d] = new float[world[d].length][];
    for (int x = 0; x < world[d].length; x++){
      world[d][x] = new float[height];
      world2[d][x] = new float[world[d][x].length];
      tmp[d][x] = new float[world[d][x].length];
      for (int y = 0; y < world[d][x].length;y++){
        world[d][x][y] = (d==0)?255:0;
        world2[d][x][y] = 0;
      }
    }
  }
  for (int x = 5; x < 16; x++){
    for (int y = 5; y < 16; y++){
      world[0][x][y] = 0;
      world[2][x][y] = 8;
    }
  }
  for (int x = 8; x < 13; x++){
    for (int y = 8; y < 13; y++){
      world[0][x][y] = 0;
      world[2][x][y] = 0;
    }
  }
  world[1][10][10] = 17600;
  //world[1][60][70] = 256;
  //world[2][60][70] = 4;
  
}

float[][] lkern = {{1./16,3./16,1./16},
                   {3./16, -1  ,3./16},
                   {1./16,3./16,1./16}};
float[][] tkern = {{1,2,3,2,1},
                   {2,3,4,3,2},
                   {3,4,5,4,3},
                   {2,3,4,3,2},
                   {1,2,3,2,1}};

float[][] convolve(float[][] in, float[][] kern,float[][] dest,int ox, int oy){
  for (int x = 0; x < in.length; x++){
    for (int y = 0; y < in[x].length;y++){
      float tot = 0;
      for (int i = 0; i < kern.length; i++){
        for (int j = 0; j < kern[i].length; j++){
          tot += kern[i][j]*in[(x+i+ox+in.length)%in.length][(y+j+oy+in[x].length)%in[x].length];
        }
      }
      dest[x][y] = tot;
    }
  }
  return dest;
}

float[][] fma(float[][] a, float[][] b,float[][] dest, float[][] m,float s){
  for (int x = 0; x < a.length; x++){
    for (int y = 0; y < a[x].length;y++){
      dest[x][y] = a[x][y]+b[x][y]*m[x][y]*s;
    }
  }
  return dest;
}
float[][] fma(float[][] a, float[][] b,float[][] dest,float s){
  for (int x = 0; x < a.length; x++){
    for (int y = 0; y < a[x].length;y++){
      dest[x][y] = a[x][y]+b[x][y]*s;
    }
  }
  return dest;
}

float[][] mul(float[][] a,float[][] b, float[][] dest, float m){
  for (int x = 0; x < a.length; x++){
    for (int y = 0; y < a[x].length;y++){
      dest[x][y] = a[x][y]*b[x][y]*m;
    }
  }
  return dest;
}

float[][] fma(float[][] a, float[][] b,float[][] dest, float[][] m,float s,float o){
  for (int x = 0; x < a.length; x++){
    for (int y = 0; y < a[x].length;y++){
      dest[x][y] = a[x][y]+b[x][y]*(m[x][y]*s+o);
    }
  }
  return dest;
}

float tanhey(float t){
  float s = t>0?1:-1;
  return s-1/(t+s);
}

void draw(){
  loadPixels();
  int i = 0;
  for (int y = 0; y < world[0][0].length;y++){
    for (int x = 0; x < world[0].length; x++){
    
     pixels[i] = color(min(255,(int)(world[2][x][y]*256)),min(255,(int)world[1][x][y]),min(255,(int)world[0][x][y]));
     i++;
    }
  }
  updatePixels();
  for (int sf = 0; sf < speed; sf++){
  fma(world[2],convolve(world[2],lkern,tmp[0],-1,-1),world[2],.8); //temperature
  //fma(world[0],convolve(world[0],lkern,tmp[0],-1,-1),world[0],.1);
  convolve(world[2],tkern,tmp[2],-2,-2);
  fma(world[1],convolve(mul(world[1],tmp[2],tmp[1],1./256),lkern,tmp[0],-1,-1),world[1],.8);
  fma(world[0],convolve(mul(world[0],tmp[2],tmp[1],1./256),lkern,tmp[0],-1,-1),world[0],.4);
   for (int x = 0; x < world[0].length; x++){
    for (int y = 0; y < world[0][x].length;y++){
      float tmpf = world[0][x][y]*tanhey(9.8*world[2][x][y]*world[1][x][y]*world[1][x][y]/256/256);
      world[0][x][y] -= tmpf + .02*world[0][x][y]*world[2][x][y];
      world[1][x][y] += tmpf*2;
      float t2 = .1;//(tanhey(tmp-2)/2+1);
      world[2][x][y] = (world[2][x][y]-t2)*.9+t2+2*tmpf/256;
      world[0][x][y] += .02*(256 - world[0][x][y]);//*abs((1 - world[0][x][y]/256));
      world[1][x][y] -= .15*(world[1][x][y]);//*world[2][x][y];//*(256 - world[0][x][y])/256;
    }
   }
   if (mousePressed){
     world[1][mouseX][mouseY] = 256;
   }
  }
}

void mousePressed(){
  world[1][mouseX][mouseY] = 256;
}
