


import java.util.Collections;

int xgen = 0;
int d = 40;
[] col = new int[height/d+1];
void setup()
{
  fullScreen();
  background(255);
  for(int xa = 0;xa<col.length;xa++)
   col[xa] = xa+1;
}
double ra = 0.5;

int x = 1;
int y = 1;
int dir = 1;
int s = 1009;
int left = 1;
int right = 3;

void draw()
{
  if (keyPressed && (key == 'r')){
    background(255);
    stroke(0);
    fill(255);
    col = new int[height/d+1];
    for(int xa = 0;xa<height/d+1;xa++)
      col[xa] = xa+1;
    rect(0,0,width-1,height-1);
    xgen = 0;
    x = 1;
    y = 1;
    dir = 1;
  }if ((keyPressed && (key == 'a'))||(Math.random()<ra)){
   left = 1; right = 3; 
  }if ((keyPressed && (key == 'd'))||(Math.random()<ra)){
  left = 3; right = 1; 
  }if (keyPressed && (key == 'w')){
     x = 1;
    y = 1;
    dir = 1;}
  stroke(0);
        double p = 0.5;
       if(xgen == height/d-1)
         p = 2;
       for (int y = 0;y<col.length-2;y++){
         if ((Math.random()<p)&& (col[y] != col[y+1])){
           int n = col[y];
           int r = col[y+1];
           for( int i = 0; i < col.length ;i++)
             if (col[i]==r)
               col[i]=n;
         }else{
           line(d*xgen,d*(y+1),d*(xgen+1),d*(y+1));
         }
       }
       int[] refact = new int[col.length];
       int[] dict = new int[col.length];
       int v = 1;
       for(int h; h < col.length-1;h++)
       {
         
         
         
       }
       col = refact;
       boolean[] w = new boolean[s];
       if (xgen != height/d-1){
         
         for (int y = 0;y<col.length-1;y++){
           if ((Math.random()<p) ||( (col[y] != col[y+1]) && w)){
             w = false;
           }else{
             line(d*(xgen+1),d*y,d*(xgen+1),d*(y+1));
             col[y] = max(col) + 1;
             
           }
           if ( col[y] != col[y+1])
              w = true;
         }
       }
     if (xgen<width/2)xgen++;
    for (int q = 0; q < s ; q ++){
    if (((x!=width-2) || (y!=1) || true) && (x < d * xgen))
    {
      int dx = 0;
      int dy = 0;
      if (dir%2==0)
        dx = dir-1;
      if (dir%2==1)
        dy = dir-2;
      color c = get(x+dx,y+dy);
      if ((red(c) == 255)||(green(c)==255)||(blue(c)==255)){
        color v =  color(255,0,0);
        if(!(((green(c)==255)&&(left==3))||((blue(c)==255)&&(left==1))))
          if(left==1)
          v =  color(0,255,0);
          else
          v =  color(0,0,255);
        set(x,y,v);
        x += dx;
        y += dy;
        dir = (dir + left)%4;
      }else{
        dir = (dir + right)%4;
      }
      
      
    }
      
    }
  
}
void mousePressed()
{
  x = mouseX;
  y = mouseY;
  
  
}