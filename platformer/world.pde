import java.util.Collections;


class world implements java.io.Serializable{
  dvector offset;
  dvector scale;
  dvector drawOffset;
  int debug = 1;
  
  ArrayList<collidable> collidables;
  ArrayList<drawable> drawables;
  ArrayList<stepable> stepables;
  double timeScale;
  int oldTime;
  
  world(dvector ofs,dvector scl, dvector dofs){
    drawables = new ArrayList<drawable>();
    stepables = new ArrayList<stepable>();
    timeScale = 1;
    offset = ofs;
    scale = scl;
    drawOffset = dofs;
    
  }
  void startTime(){
    oldTime = millis();
  }
  
  void addDrawable(drawable... d){
    for( drawable dr : d){
    drawables.add(dr);
    addStepable((stepable) dr);}
  }
  void addStepable(stepable... s){
    for( stepable st : s){
    stepables.add(st);}
  }
  
    
  void step(){
    int newTime = millis();
    double dt = (newTime-oldTime)*timeScale/1000;
    oldTime = newTime;
    for(int i = 0; i < stepables.size(); i++){
      stepables.get(i).step(dt,this); 
    }
  }
  void cullStepables(){
    for(int i = stepables.size()-1; i >= 0 ; i--){ //iterate downwards to do it in one pass.
      if (stepables.get(i).removeMeFromStepables){
        stepables.remove(i);
      }
    }
  }
  
  
  
  
  void render(){
    Collections.sort(drawables);
    for(int i = 0; i < drawables.size(); i++){
      if(drawables.get(i).visible(offset,scale,drawOffset))
        drawables.get(i).draw(offset,scale,drawOffset); 
    }
    strokeWeight(1);
    if((debug & 1) == 1){
      //draw axes
      dvector o = new dvector().simple3d(offset,scale,drawOffset);
      dvector x = new dvector(1).simple3d(offset,scale,drawOffset);
      dvector y = new dvector(0,1).simple3d(offset,scale,drawOffset);
      dvector z = new dvector(0,0,1).simple3d(offset,scale,drawOffset);
      stroke(255,0,0);
      line((float)o.get(0),(float)o.get(1),(float)x.get(0),(float)x.get(1));
      stroke(0,255,0);
      line((float)o.get(0),(float)o.get(1),(float)y.get(0),(float)y.get(1));
      stroke(0,0,255);
      line((float)o.get(0),(float)o.get(1),(float)z.get(0),(float)z.get(1));
      
    }
  }
  void cullDrawables(){
    for(int i = drawables.size()-1; i >= 0 ; i--){ //iterate downwards to do it in one pass.
      if (drawables.get(i).removeMeFromDrawables){
        drawables.remove(i);
      }
    }
  }
  
  void cull(){
    cullDrawables();
    cullStepables();
  }
  
}