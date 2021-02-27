
class Ring<type>{
  ArrayList<type> contents;
  int index;
  Ring(){
    contents = new ArrayList<type>();
    index = 0;
  }
  private int cindex(int i){
    return contents.size()==0?0:(((index+i)%contents.size()+contents.size())%contents.size());
  }
  type get(){
    return get(0);
  }
  type get(int i){
    return contents.get(cindex(i));
  }
  int size(){
    return contents.size();
  }
  void push(int i,type e){
    int ind = cindex(i);
    contents.add(ind,e);
    if (ind < index){
      shift(1);
    }
  }
  void add(type e){
    contents.add(e);
  }
  type pop(int i){
    int ind = cindex(i);
    if (ind < index){
      shift(-1);
    }
    return contents.remove(ind);
  }
  void shift(int i){
    index = cindex(i);
  }
  
  
  
}


uiElement toolBar;
void uncheckAll(checkbox... cs){
    for (checkbox c:cs){
      c.uncheck();
    }
}
checkbox[] toolCheckboxes;
tool[] tools; 
Ring<brush> brushes;
double time;
slider timeSlider;
void uiSetup(){
  time = 0;
  timeSlider = new slider(new simpleSliderGraphics(  new simpleSliderRectangle(1,1,new style(color(64,255,64),255)),
  new simpleSliderRectangle(1,1,new style(color(64,128,64),255)),
  new simpleSliderRectangle(1,1,new style(color(128,255,64),255))
  ),new sliderCallback(new voidFunction(){
   public void call(){
     time = timeSlider.value;
     world.changed = true;
   }},
   new voidFunction(){
   public void call(){
     time = timeSlider.value;
     world.changed = true;
   }}
  ));
  timeSlider.setOrientation(new transform(new Point(10,00,00,00),
                                                   new Point(00,1,00,00),
                                                   new Point(00,00,1,00),
                                                   new Point(00,10,00,01)));
  
  
  brushes = new Ring<brush>();
  brushes.add(new polyBrush(new style( color(255),255,0,255,1)));
  
  squareCheckboxGraphics styleSelect = new squareCheckboxGraphics();
  ((canvas)styleSelect.label).contents.add( new BrushedBezierPath(brushes.get(0), 16.01 ,
  new Bezier(new vnd(0.2,0.6),new vnd(0.2,0.8)),
  new Bezier(new vnd(0.2,0.8),new vnd(0.8,0.8)),
  new Bezier(new vnd(0.8,0.8),new vnd(0.2,0.2),new vnd(0.8,0.5))
  ));
  checkboxCallback selectStyleSelect = new checkboxCallback(
  new booleanFunction(){
    public boolean call(){
      ((polyBrush) brushes.get(0)).s = new style(color(random(255),random(255),random(255)),random(255),color(random(255),random(255),random(255)),random(255),random(10));
      return false;
    }
  },
  new booleanFunction(){
    public boolean call(){
      return true;
    }
  },new voidFunction(){public void call(){}},
  new voidFunction(){    public void call(){}}
  );
  checkbox selectBrush = new checkbox(styleSelect,selectStyleSelect);
  selectBrush.setOrientation(new transform(new Point(2,0,0,0),
                                                   new Point(0,-2,0,0),
                                                   new Point(0,0,1,0),
                                                   new Point(0,8,0,1)));
  
  
  squareCheckboxGraphics cursor = new squareCheckboxGraphics();
  ((canvas)cursor.label).contents.add( new BrushedBezierPath(new polyBrush(new style( color(255),255,0,255,1)), 1.01 ,
  new Bezier(new vnd(0.2,0.2),new vnd(0.4,0.35)),
  new Bezier(new vnd(0.4,0.35),new vnd(0.5,0.25)),
  new Bezier(new vnd(0.5,0.25),new vnd(0.8,0.8)),
  new Bezier(new vnd(0.8,0.8),new vnd(0.25,0.5)),
  new Bezier(new vnd(0.25,0.5),new vnd(0.35,0.4)),
  new Bezier(new vnd(0.35,0.4),new vnd(0.2,0.2))
  ));
  checkboxCallback selectCursor = new checkboxCallback(
  new booleanFunction(){
    public boolean call(){
      uncheckAll(toolCheckboxes);
      println("Cursor selected.");
      registerUIElement(tools[0]);
      return true;
    }
  },
  new booleanFunction(){
    public boolean call(){
      return false;//must select 1 tool
    }
  },new voidFunction(){public void call(){}},
  new voidFunction(){
    public void call(){
      unregisterUIElement(tools[0]);
    }
  }
  );
  
  
  squareCheckboxGraphics lin = new squareCheckboxGraphics();
  ((canvas)lin.label).contents.add( new Line(new Point(0.2,0.2),new Point(0.8,0.8), new style( color(0),0,color(0),255,1)));
  checkboxCallback selectLin = new checkboxCallback(
  new booleanFunction(){
    public boolean call(){
      uncheckAll(toolCheckboxes);
      println("line selected.");
      registerUIElement(tools[1]);
      return true;
    }
  },
  new booleanFunction(){
    public boolean call(){
      return false;//must select 1 tool
    }
  },new voidFunction(){public void call(){}},
  new voidFunction(){
    public void call(){
      unregisterUIElement(tools[1]);
    }
  }
  );
  
  squareCheckboxGraphics bez = new squareCheckboxGraphics();
  ((canvas)bez.label).contents.add( new BrushedBezierPath(new polyBrush(new style( color(0),0,color(0),255,1)), 8.01 ,
    new Bezier(new vnd(0.2,0.2),new vnd(0.8,0.2),new vnd(0.2,0.8),new vnd(0.8,0.8))));
  checkboxCallback selectBez = new checkboxCallback(
  new booleanFunction(){
    public boolean call(){
      uncheckAll(toolCheckboxes);
      println("bezier selected.");
      registerUIElement(tools[2]);
      return true;
    }
  },
  new booleanFunction(){
    public boolean call(){
      return false;//must select 1 tool
    }
  },new voidFunction(){public void call(){}},
  new voidFunction(){
    public void call(){
      unregisterUIElement(tools[2]);
    }
  }
  );
  
  toolCheckboxes = new checkbox[] {new checkbox(cursor,selectCursor),
  new checkbox(lin,selectLin),
  new checkbox(bez,selectBez),
  
  };
  
  for(int i = 0; i < toolCheckboxes.length; i++){
    toolCheckboxes[i].setOrientation(new transform(new Point(1,0,0,0),
                                                   new Point(0,-1,0,0),
                                                   new Point(0,0,1,0),
                                                   new Point(0,i*1.125+1,0,1)));
  }



  toolBar = new uiElementList(  new uiElementList(  toolCheckboxes  ),selectBrush,timeSlider);
  tools = new tool[]{new nullTool(),
    new lineTool(world),
    new bezierTool(1./4,world)
  };
  
}
