int res = 16;


scene stuff = new scene();
scene otherStuff = new scene();
camera cam1;
camera cam2;

double ar;
void setup(){
size(768, 768);
ar = width*1./height;
background(100);
noCursor();
stuff.add(new bitbg(1000000000000.));

stuff.add(new Triangle(new vec(10,10,10),
new vec(20,10,10),
new vec(10,20,10),
new reflectiveColor(color(random(255),random(255),random(255),16),stuff)));

stuff.add(new Parallelogram(new vec(9,9,9.9),
new vec(21,9,9.9),
new vec(9,21,9.9),
new /*reflectiveColor(new C_SetAlpha(new */Texture(loadImage("txt.png"))/*,128),stuff)*/));

stuff.add(new Triangle(new vec(10,10,15),
new vec(20,10,15),
new vec(10,20,15),
new reflectiveColor(color(random(255),random(255),random(255),16),stuff)));

stuff.add(new Triangle(new vec(9,9,15.1),
new vec(21,9,15.1),
new vec(9,21,15.1),
new Color(color(random(255),random(255),random(255)))));

stuff.add(new Sphere(new vec(3,3,3),1,new Color(color(random(255),random(255),random(255)))));//new reflectiveColor(color(random(255),random(255),random(255),64),stuff)));
//generate hex grid
vec i1 = new vec(1);
vec i2 = new vec(1).rotate(PI/3,0,1);
vec i3 = new vec(1).rotate(2*PI/3,0,1);


for(int x = 0; x < 3; x++){
  for(int y = 0; y < 3; y++){
    vec v = i1.scale(x).add(i3.scale(y)).add(new vec(0,0,random(1)));
    
    Triangle t1 = new Triangle(v,v.add(i1).add(new vec(0,0,random(1))),v.add(i2),new reflectiveColor(color(random(255),random(255),random(255),random(255)),stuff));
    Triangle t2 = new Triangle(v,v.add(i2),v.add(i3),new transparentColor(color(random(255),random(255),random(255),128),stuff));
    stuff.add(t1).add(t2);
  }
}
stuff.add(new Parallelogram(new vec(random(3),random(3),random(3)),
    new vec(random(3),random(3),random(3)),
    new vec(random(3),random(3),random(3)),
    new RefractColor(color(255,255,255,14),stuff,0.9)));
    
stuff.add(new Sphere(new vec(random(3),random(3),random(3)),
    0.5,
    new reflectiveColor(new C_SetAlpha(new RefractColor(color(255,255,255,14),stuff,3),255),stuff)));
    
stuff.add(new Parallelogram(new vec(-4,-4,-4),
    new vec(-4,-5,-4),
    new vec(-5,-4,-4),
    new randColor(color(0,0,0,255),color(0,255,0,255))));
    
stuff.add(new Parallelogram(new vec(1,1,-4),
    new vec(1,2,-4),
    new vec(2,1,-4),
    new fog(color(random(255),random(255),random(255),16),1,stuff)));
    
for(int n = 0; n < 6; n++){
    vec v = new vec(n*4,-10,10); 
    otherStuff.add(new Parallelogram(v.add(new vec(random(3),random(3),random(3))),
    v.add(new vec(random(3),random(3),random(3))),
    v.add(new vec(random(3),random(3),random(3))),
    new Color(color(random(255),random(255),random(255)))));
}

stuff.add(new Parallelogram(new vec(10,0,0),
    new vec(10,0,20),
    new vec(10,-20,0),
    new holoColor(color(5,40,52,12),otherStuff)));


for(int n = 0; n < 4; n++){
  vec v = new vec(5,-5,5); 
    stuff.add(new Parallelogram(v.add(new vec(random(3),random(3),random(3))),
    v.add(new vec(random(3),random(3),random(3))),
    v.add(new vec(random(3),random(3),random(3))),
    new transparentColor(new C_NormAlpha( new reflectiveColor(new C_NormAlpha(new Texture(loadImage("txt.png")),240,15),stuff),240,15),stuff)));
  
}


}

vec pos = new vec(3,3,6);

double eyeSep = 0;
double fov = 0.7;
int superRes = 0;
int superResI = 0;
void mouseMoved(){
  superRes = 0;
  superResI = 0;
}
void draw(){
 
 double rx = -((double)(mouseX-width/2)/width)*PI*2*2;
 double ry = ((double)(mouseY-height/2)/height)*PI*2+PI/2;
 if (ry > PI)
   ry= PI;
 if (ry < 0)
   ry= 0;
 
 vec ix = new vec(0,1,0).rotate(ry,0,2).rotate(rx,0,1);
 vec iy = new vec(1,0,0).rotate(ry,0,2).rotate(rx,0,1);
 vec iz = new vec(0,0,1).rotate(ry,0,2).rotate(rx,0,1);
 cam1 = new c_persp(
   ix.scale(-eyeSep).add(pos),
   iz,
   ix,
   iy);
 cam2 = new c_persp(
   ix.scale(eyeSep).add(pos),
   iz,
   ix,
   iy);
 if (eyeSep != 0){
   //image(render(stuff,(res<<superRes)*width/512,(res<<superRes)*height/256,cam1,-fov/2,-fov,fov/2,fov),0,0,width/2,height);
   //image(render(stuff,(res<<superRes)*width/512,(res<<superRes)*height/256,cam2,-fov/2,-fov,fov/2,fov),width/2,0,width/2,height);
   double f = 2*fov / (1<<superRes);
   double x = (-fov/2 + (superResI%(1<<superRes))*f/2)*ar;
   double y = -fov + (superResI/(1<<superRes))*f;
   image(render(stuff,res*width/512,res*height/256,cam1,x,y,x+(f/2)*ar,y+f),width * ((superResI%(1<<superRes))/((float)(2<<superRes))),height * ((superResI/(1<<superRes))/((float)(1<<superRes))),width/((float)(2<<superRes)),height/((float)(1<<superRes)));
   image(render(stuff,res*width/512,res*height/256,cam2,x,y,x+(f/2)*ar,y+f),width * ((superResI%(1<<superRes))/((float)(2<<superRes)))+width/2,height * ((superResI/(1<<superRes))/((float)(1<<superRes))),width/((float)(2<<superRes)),height/((float)(1<<superRes)));
 }else{
   double f = 2*fov / (1<<superRes);
   double x = (-fov + (superResI%(1<<superRes))*f)*ar;
   double y = -fov + (superResI/(1<<superRes))*f;
   image(render(stuff,res*width/256,res*height/256,cam1,x,y,x+f*ar,y+f),width * ((superResI%(1<<superRes))/((float)(1<<superRes))),height * ((superResI/(1<<superRes))/((float)(1<<superRes))),width/((float)(1<<superRes)),height/((float)(1<<superRes)));
 }
    
 if (superResI == 1<<(superRes*2)){
   superRes++;  superResI = -1;}
   
 superResI++;
 
 if (key == 'd'){superRes = 0; superResI = 0;
   pos = pos.add(ix.scale(0.1));}
 if (key == 's'){superRes = 0; superResI = 0;
   pos = pos.add(iz.scale(-0.1));}
 if (key == 'a'){superRes = 0; superResI = 0;
   pos = pos.add(ix.scale(-0.1));}
 if (key == 'w'){superRes = 0; superResI = 0;
   pos = pos.add(iz.scale(0.1));}
 if (key == ' '){superRes = 0; superResI = 0;
   pos = pos.add(new vec(0,0,0.1));}
 if (key == 'c'){superRes = 0; superResI = 0;
   pos = pos.add(new vec(0,0,-0.1));}
 if (key == 'o'){superRes = 0; superResI = 0;
   fov *= 1.0625;}
 if (key == 'l'){superRes = 0; superResI = 0;
   fov /= 1.0625;}
   
 if (key == '-'){superRes = 0; superResI = 0;
   eyeSep -= 0.025;}
 if (key == '='){superRes = 0; superResI = 0;
   eyeSep += 0.025;}
 if (key == '0'){superRes = 0; superResI = 0;
   eyeSep = 0;}
 
 
}

PImage render(scene s,int w, int h,camera cam,double aws, double ahs,double awe, double ahe){
  PImage result = new PImage(w,h);
  result.loadPixels();
  
  
  cam.startIteration(w,h,aws,ahs,awe,ahe);
  int i = 0;  
  for(int iy = 0; iy < result.height; iy ++){
    for(int ix = 0 ; ix < result.width; ix ++){    
      ray r = cam.nextRay();//new ray(pos, new vec(x,y,1).normalize());
      intersection inter = s.trace(r);
      if (inter.intersects){
        result.pixels[i] = inter.c;
      }else{
       result.pixels[i] = color(0,0,0,0);
      }
      i ++;
    }
  }
  result.updatePixels();
  return result;
}
