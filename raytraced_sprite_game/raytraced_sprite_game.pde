pcolor[][] screen;
int[][] screenN;
double harmonius(int n){
  double p = 1;
  for(int i = 0; i < 8192; i++){
    p = Math.pow(1+p,1./n);
  }
  return p;
}
int qrx = 0;
int qry = 0;
double qrg = harmonius(2+1);
int qrdx = (int)(Double.doubleToRawLongBits(1./qrg)>>20);
int qrdy = (int)(Double.doubleToRawLongBits(1./qrg/qrg)>>20);
void setup(){
  size(1500,1000,P3D);
  background(0);
  
  screen = new pcolor[width][height];
  screenN = new int[width][height];
  for (int x = 0; x < width; x++){
    for (int y = 0; y < height; y++){
      screen[x][y] = new pcolor();
      screenN[x][y] = 0;
    }
  }
  
  a.mat = new m_lit(new pcolor(.9,.9,.99),0.002);
  b.mat = new m_lit(new pcolor(.99,.97,.9),0.002);
  c.mat = new m_lit(new pcolor(.9,.9,.9),0.8);
  d.mat = new m_flat(new pcolor(1,1,1));
  e.mat = new m_checkerboard(new m_lit(new pcolor(.2,.7,.2),1),new m_lit(new pcolor(.15,.6,.15),1));
  c.far = 400;
  sph.mat = new m_transp(new pcolor(.8,.9,1.1),.0,1.1);
  sun.mat = new m_directional(new m_flat(new pcolor(30,20,10)),new m_lit(new pcolor(.5,.5,.5),.3),new vec(0,1,-1));
  print(""+new vec(1,2,3).toBasis(new vec(1,0,0),new vec(0,0,1),new vec(0,1,0)));
}

vec tsPos = new vec(3,0,22);
traceable test = new marcher(new df_smooth_union(2,new df_sphere(new vec(0,0,20),2),new df_sphere(tsPos,2))); 
//new nplane(new vec(0,0,700),new vec(-1,-1,-1));
//
//
void testdraw(){
  //((marcher)test).maxS = 32;
  //((marcher)test).near = .001;
  for (int x = 0; x < width; x++){
    for (int y = 0; y < height; y++){
     ray r = new ray(new vec(0,0,0),new vec(x-width/2,y-height/2,width));
     hit h = test.trace(r);
     if (h.i ){//&& h.uvw.mag2()<128*128){
       //h.uvw.scaleEq(10);
       set(x,y,color((int)(h.uvw.x)+h.side*32,(int)(h.uvw.y),(int)(h.uvw.z)));
     }else{
       set(x,y,color(128));
     }
      
    }
  }
  ray r = new ray(new vec(0,0,0),new vec(mouseX-width/2,mouseY-height/2,width));
  hit h = test.trace(r);
  text(""+h,0,10,width,height);
  tsPos.addEq(new vec(0,0.1,0));
}


nplane a = new nplane(new vec(0,0,100),new vec(6,0,-1));
nplane b = new nplane(new vec(0,0,100),new vec(-6,0,-1));
marcher c = new marcher(new df_union(new df_intersection(new df_onion(new df_smooth_union(1,new df_sphere(new vec(0,6,60),2),
                                              new df_sphere(new vec(0,11,60),3)),.1),
                                              new df_complement(new df_sphere(new vec(1,5,59),1)))
                                              
                                              
                                              
                                              ));
traceable d = new nplane(new vec(0,-100,100),new vec(0,1,.1));//new marcher(new df_sphere(new vec(0,-40,60),6));
traceable e = new uvplane(new vec(0,8,100),new vec(3,0,0),new vec(0,0,3));
traceable sun = new uvtriangle(new vec(1,0,60),new vec(5,-1,0),new vec(0,-1,5));
traceable sph = new uvsphere(new vec(4,4,58),4);
traceable sceneTest = new naive_scene(a,b,c,d,e,sun,sph);


camera cam = new cam_persp(new vec(),new angle(),1);


int n = 0;
int s = 64;
int step = 32*2*0;
int offs = 0;
int m = 5000;
int bsize = 20;
int bsize2 = 400;

int logColor(color n){
  return n;
}
void testLight(){//path tracing
  n += 1;
  double dx = random(0,1)-.5;
  double dy = random(0,1)-.5;
  if (step != 0){
  for (int y = offs%step; y < height; y+= step){
    for (int x = (offs/step)%step; x < width; x+= step){
     ray r = cam.get((x+dx-width/2)/width,(y+dy-height/2)/width);
     screenN[x][y]++;
     set(x,y,screen[x][y].addEq(sceneTest.traceScene(new pcolor(0,0,0),r,sceneTest,s)).div(screenN[x][y]).toColor(1));
    }
  }
  }
  offs ++;
  if (key == 's'){
    background(0);
  fill(color(255,255,255));
  stroke(color(255,255,0));
  pushMatrix();
  
  applyMatrix(cam.getMtrx());
  sceneTest.quickDraw(1);
  
  popMatrix();
  }
  for (int i = 0; i < m; i++){
    int x,y;
    if (key == 'o'){
      x = (int)(random(20)-10)+mouseX;
      y = (int)(random(20)-10)+mouseY;
    }else{
    if (key == 'q'){
      x = (int)((width*(((long)qrx)&((1L<<32)-1)))>>32);
      y = (int)((height*(((long)qry)&((1L<<32)-1)))>>32);
      qrx += qrdx;
      qry += qrdy;
    }else{
    boolean d = random(1)>.5;
     x = (((int)(mouseX + (d?randomGaussian()*bsize:randomGaussian()*bsize2))));
     y = (((int)(mouseY + (d?randomGaussian()*bsize:randomGaussian()*bsize2))));
    }}
    x= max(0,min(width-1,x));
    y= max(0,min(height-1,y));
    ray r = cam.get((x+dx-width/2)/width,(y+dy-height/2)/width);
     screenN[x][y]++;
     set(x,y,screen[x][y].addEq(sceneTest.traceScene(new pcolor(0,0,0),r,sceneTest,s)).div(screenN[x][y]).toColor(1));
  }
  ray r = new ray(new vec(0,0,0),new vec(mouseX-width/2,mouseY-height/2,width));
  hit h = sceneTest.trace(r);
  //text(""+h,0,10,width,height);
  tsPos.addEq(new vec(0,0.1,0));
  if (key == 'l'){
     for (int x = 0 ; x < width; x++){
       for (int y = 0 ; y < height; y++){
         set(x,y,logColor(screenN[x][y]));
       }
     }
  }
}

// http://rgl.epfl.ch/publications/Zeltner2020Specular
// http://rgl.s3.eu-central-1.amazonaws.com/media/papers/Zeltner2020Specular.pdf
void testLight_spec_man_samp(){
   // parameterize the reflections with two uniform random number inputs
   // use newton-raphson root finding
   // intensity is proportional to area of convergence basin
   // 1/p estimator is this:
   // <1/p> = 1 + sum(i=1,∞ of prod(j=1,i of <a>_j)) where
   // <a>_j is 0 if manifold walk j (newton raphson iters on the rng inputs)
   //               converged to the root
   //          1 if it converged to a different root or diverged
   // so, try random starting points until the root is found, then the number of tries
   // is <1/p> and that's the intensity estimate for that root's path
   // (you can't just try until 'a' root is found because that'd lead to a much larger
   //  estimate of p (and thus much lower intensity))
   // ((you CAN, however, try n times and mark roots and divergences, then at the end
   //   find the ratios (for this i'll try r2 quasirand with random initial for <a>j)))
   //  (((( oops that's just the biased mode ))))
  
  //as for actually using this
  // probably gonna need to add some methods to the materials
  //   - prefered reflection direction (for specular components)
  //   or maybe just:
  //   - angle pdf (inverse of the uniform uv transform)
  //   - constraint function and it's gradient
  //            sharper for pure specular?
  // maybe will need to have a pure specular/refractive submaterial and then blend it.
  //  submaterial could take perturbations to the normal to acheive wonky reflections?
  // 
  // I might end up with a probability gradient ascender
  
  
  
}



vec p = new vec(0,-1,0);
camera scam = new cam_persp(p,new angle(),1);

traceable sp = new translation(new marcher(new df_sphere(p,1)).setMaterial(new m_lit(new pcolor(.8,.8,.8),0.06))
                                               ,new vec(0,0,-2.5));
sprite testSprite = new sprite(sp,scam,32, 32);
traceable bg = new naive_scene(new marcher(new df_sphere(new vec(0,-130,0),100)).setMaterial(new m_flat(new pcolor(1,1,1))),
                               new uvplane(new vec(0,.9,0),new vec(2,0,0),new vec(0,0,2)).setMaterial(new m_checkerboard(new m_lit(new pcolor(.2,.7,.2),0),new m_lit(new pcolor(.15,.6,.15),1)))
                               ,new nplane(new vec(0,-130,0),new vec(0,1,1)).setMaterial(new m_flat(new pcolor(.3,.5,.7)))
                               );

traceable scene = new naive_scene(testSprite,bg);

void draw(){
  
  //testdraw();
  testLight();
  /*testSprite.vel.z = 1;
  testSprite.pos = p;
  image(testSprite.draw(8,scene),(int)(testSprite.pos.x*testSprite.w+width/2),(int)(testSprite.pos.y*testSprite.h+height/2+.5));
  testSprite.step(1/60.);
  testSprite.accel.set(0,9,0);
  if (testSprite.pos.y>0){
    testSprite.pos.y = 0;
    testSprite.vel.y = -testSprite.vel.y*.6;
  }*/
  
  
}
