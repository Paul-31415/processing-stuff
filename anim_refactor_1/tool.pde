interface tool{
  void attach();
  void detach();
}

class selectTool implements tool,listener{
  
  selectTool(){
    
    
    
  }
  
  boolean doSelect(selectable d,double dist){
      if (d.selectDistance(new coordTransform(),mouseX, mouseY)<dist){
        selected.add((selectable)d);
        return true;
      }
      for(selectable s: d.selectableChildren()){
         if(doSelect(s,dist)){
           selected.add((selectable)d);
           return true;
         }
      }
      return false;
      
  }
  void doSelectAll(selectable d,double dist){
      if (d.selectDistance(new coordTransform(),mouseX, mouseY)<dist){
        selected.add((selectable)d);
      }
      for(selectable s: d.selectableChildren()){
         doSelectAll(s,dist);
         
      }
      
  }
  
  void attach(){
    mouseClickedListeners.add(this);
    
  }
  void detach(){
    mouseClickedListeners.remove(this);
    
  }
  double priority(EventType t){
    return 0;
  }
  boolean handle(Event e){
    if (!keys[16]){
      selectCacheGood=false;
      selected.clear();
    }
    for( drawable d: canvas){
    if (d instanceof selectable){
      if (doSelect((selectable) d,20)){
        selectCacheGood=false;
        break;
      }
    }
    }
    
    
    
    return false;
    
  }
}
