


Fractal state;

rule bat = new NHRule( new pattern[] {
    new pattern(new int[]{0,2}, new int[]{0,0}, new int[]{1,3}),
    new pattern(new int[]{0,0}, new int[]{0,2}, new int[]{1,3}),
    new pattern(new int[]{0,-2}, new int[]{0,0}, new int[]{1,3}),
    new pattern(new int[]{0,0}, new int[]{0,-2}, new int[]{1,3}),
    
    new pattern(new int[]{0}, new int[]{0}, new int[]{3}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{6}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{7}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{8}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{9}),
},
  new int[] {
    4,4,4,4,6,7,8,9,0
});

rule longTail = new NHRule( new pattern[] {
    new pattern(new int[]{0}, new int[]{0}, new int[]{10}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{5}),
},
  new int[] {
    5,10
});
rule killTail = new NHRule( new pattern[] {
    new pattern(new int[]{0}, new int[]{0}, new int[]{10}),
},
  new int[] {
    1
});
rule batAcid = new NHRule( new pattern[] {
    new pattern(new int[]{0,1}, new int[]{0,0}, new int[]{0,9}),
    new pattern(new int[]{0,0}, new int[]{0,1}, new int[]{0,9}),
    new pattern(new int[]{0,-1}, new int[]{0,0}, new int[]{0,9}),
    new pattern(new int[]{0,0}, new int[]{0,-1}, new int[]{0,9}),
},
  new int[] {
    11,11,11,11
});
rule acid = new acid(1,11,0);

rule vert = new NHRule( new pattern[] {
      
    new pattern(new int[]{0,0,0}, new int[]{0,1,-1}, new int[]{2,1,1}),
    
    
    new pattern(new int[]{0,0,0}, new int[]{0,1,2}, new int[]{2,0,2}),
    new pattern(new int[]{0,0,0}, new int[]{0,-1,-2}, new int[]{2,0,2}),
    new pattern(new int[]{0,0,0}, new int[]{-1,0,1}, new int[]{2,0,2}),
    
    
    new pattern(new int[]{0,0}, new int[]{0,-1}, new int[]{0,2}),
    new pattern(new int[]{0,0}, new int[]{0,1}, new int[]{0,2}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{2})
    
  },
  new int[] {
    0,0,0,3,2,2,1
});
rule gvert = new NHRule( new pattern[] {
      
    new pattern(new int[]{0,0,0}, new int[]{0,1,-1}, new int[]{4,1,1}),
    
    new pattern(new int[]{0,0,0}, new int[]{0,1,2}, new int[]{4,0,4}),
    new pattern(new int[]{0,0,0}, new int[]{0,-1,-2}, new int[]{4,0,4}),
    new pattern(new int[]{0,0,0}, new int[]{-1,0,1}, new int[]{4,0,4}),
    
    new pattern(new int[]{0,0}, new int[]{0,-1}, new int[]{0,4}),
    new pattern(new int[]{0,0}, new int[]{0,1}, new int[]{0,4}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{4})
    
  },
  new int[] {
    0,0,0,5,4,4,1
});
rule bvert = new NHRule( new pattern[] {
      
    new pattern(new int[]{0,0,0}, new int[]{0,1,-1}, new int[]{5,1,1}),
    
    new pattern(new int[]{0,0,0}, new int[]{0,1,2}, new int[]{5,0,5}),
    new pattern(new int[]{0,0,0}, new int[]{0,-1,-2}, new int[]{5,0,5}),
    new pattern(new int[]{0,0,0}, new int[]{-1,0,1}, new int[]{5,0,5}),
    
    new pattern(new int[]{0,0}, new int[]{0,-1}, new int[]{0,5}),
    new pattern(new int[]{0,0}, new int[]{0,1}, new int[]{0,5}),
    new pattern(new int[]{0}, new int[]{0}, new int[]{5})
    
  },
  new int[] {
    0,0,0,3,5,5,1
});
rule horiz = (rule) (transform((NHRule)(vert),0,1,1,0));
rule diagP = (rule) (transform((NHRule)(vert),1,1,0,1));
rule diagN = (rule) (transform((NHRule)(vert),1,-1,0,1));

rule ghoriz = (rule) (transform((NHRule)(gvert),0,1,1,0));
rule gdiagP = (rule) (transform((NHRule)(gvert),1,1,0,1));
rule gdiagN = (rule) (transform((NHRule)(gvert),1,-1,0,1));

rule bhoriz = (rule) (transform((NHRule)(bvert),0,1,1,0));
rule bdiagP = (rule) (transform((NHRule)(bvert),1,1,0,1));
rule bdiagN = (rule) (transform((NHRule)(bvert),1,-1,0,1));


rule matts = (rule) (transform((NHRule)(vert),1,5,0,1));
rule gro = new NHRule( new pattern[] {
    
    new pattern(new int[]{0,1}, new int[]{0,0}, new int[]{3,3}),
    new pattern(new int[]{0,0}, new int[]{0,1}, new int[]{3,3}),
    new pattern(new int[]{0,-1}, new int[]{0,0}, new int[]{3,3}),
    new pattern(new int[]{0,0}, new int[]{0,-1}, new int[]{3,3}),
  
    new pattern(new int[]{0,1}, new int[]{0,1}, new int[]{1,3}),
    new pattern(new int[]{0,-1}, new int[]{0,1}, new int[]{1,3}),
    new pattern(new int[]{0,1}, new int[]{0,-1}, new int[]{1,3}),
    new pattern(new int[]{0,-1}, new int[]{0,-1}, new int[]{1,3}),
    
    new pattern(new int[]{0}, new int[]{0}, new int[]{3})
  },
  new int[] {
    1,1,1,1,3,3,3,3,4
});
rule wwd = new wireworld(1,4,5);
void setup(){
  size(512,512);
  background(255);
  cellMatrix c = new cellMatrix(width,height);
  c.set(width/2,height/2,2);
  c.next();
  state = (Fractal) new cyclingCA(new rule[] {
    vert,vert,vert,vert,wwd,wwd,wwd,wwd,wwd,wwd,wwd,wwd,longTail,acid,
    
    horiz,horiz,horiz,horiz,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,longTail,acid,
    diagN,diagN,diagN,diagN,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,longTail,acid,
    diagP,diagP,diagP,diagP,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,acid,wwd,longTail,acid,killTail,
    bat,batAcid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,acid,
    
    
    
     //vert, bvert, gvert, vert, bvert, gvert, 
     //vert, bhoriz, gvert, vert, bhoriz, gvert, vert, 
    //bvert, ghoriz, vert, bvert, ghoriz, /*vert,  bdiagP, ghoriz, vert, bdiagP, ghoriz, vert,   bhoriz, gdiagN, vert, bhoriz, gdiagN, vert,  bdiagN, gdiagN, vert, bdiagN, gdiagN, vert,*/
     //vert, bhoriz, ghoriz, vert, bhoriz, ghoriz,
    //bvert, gvert, diagP, bvert, gvert, diagP,  bdiagP, gvert, diagP, bdiagP, gvert, diagP,   bhoriz, gdiagP, diagP, bhoriz, gdiagP, diagP,  bdiagN, gdiagP, diagP, bdiagN, gdiagP, diagP,
     //horiz, bvert, gvert, horiz, bvert, gvert, 
     //horiz, bhoriz, gvert, horiz, bhoriz, gvert, horiz,
    //bvert, ghoriz, horiz, bvert, ghoriz, /*horiz,  bdiagP, ghoriz, horiz, bdiagP, ghoriz, horiz,   bhoriz, gdiagN, horiz, bhoriz, gdiagN, horiz,  bdiagN, gdiagN, horiz, bdiagN, gdiagN, horiz,*/
     //horiz, bhoriz, ghoriz, horiz, bhoriz, ghoriz,
    //bvert, gvert, diagN, bvert, gvert, diagN,  bdiagP, gvert, diagN, bdiagP, gvert, diagN,   bhoriz, gdiagP, diagN, bhoriz, gdiagP, diagN,  bdiagN, gdiagP, diagN, bdiagN, gdiagP, diagN,
    //gro,///matts,matts,matts
    /*
    bvert, ghoriz, vert,vert,ghoriz,  bvert, vert,vert,ghoriz, vert,vert,ghoriz,vert,vert,
    bdiagP, gdiagN, diagP,diagP,gdiagN,  bdiagP, diagP,diagP,gdiagN, diagP,diagP,gdiagN,diagP,diagP,
    bhoriz, gvert, horiz,horiz,gvert,  bhoriz, horiz,horiz,gvert, horiz,horiz,gvert,horiz,horiz,
    bdiagN, gdiagP, diagN,diagN,gdiagP,  bdiagN, diagN,diagN,gdiagP, diagN,diagN,gdiagP,diagN,diagN,
    */
    },
    new color[] {
     color(0),//0
     color(64),
     color(255,0,0),
     color(255),
     
     color(64,255,64),
     
     color(64,64,255),//5
     
     color(128),color(160),color(192),color(224),
     
     color(64,64,192),//10
     color(255,64,255),
   },c);
  //print((4)%-3);
  //thread("stepForever");
}
  
boolean paused = false;

void stepForever(){
  while (true)
    state.stepDraw(); 
}
void draw(){
  if (!paused){
    state.stepDraw();
  }else{
    if (keyPressed){
      state.stepDraw();
    }
  }
  
    
}