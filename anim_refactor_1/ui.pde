listenerList mousePressedListeners;
listenerList mouseReleasedListeners;
listenerList mouseClickedListeners;
listenerList mouseDraggedListeners;
listenerList mouseMovedListeners;
listenerList mouseWheelListeners;
  
listenerList keyPressedListeners;
listenerList keyReleasedListeners;
listenerList keyTypedListeners;


void uiSetup(){
  keys = new boolean[256];
  for (int i = 0; i < keys.length; i++){
    keys[i] = false;    
  }
  //MOUSE_PRESSED,MOUSE_RELEASED,MOUSE_CLICKED,MOUSE_DRAGGED,MOUSE_MOVED,MOUSE_WHEEL,
  mousePressedListeners = new listenerList(EventType.MOUSE_PRESSED);
  mouseReleasedListeners = new listenerList(EventType.MOUSE_RELEASED);
  mouseClickedListeners = new listenerList(EventType.MOUSE_CLICKED);
  mouseDraggedListeners = new listenerList(EventType.MOUSE_DRAGGED);
  mouseMovedListeners = new listenerList(EventType.MOUSE_MOVED);
  mouseWheelListeners = new listenerList(EventType.MOUSE_WHEEL);
  
  //KEY_PRESSED,KEY_RELEASED,KEY_TYPED,
  keyPressedListeners = new listenerList(EventType.KEY_PRESSED);
  keyReleasedListeners = new listenerList(EventType.KEY_RELEASED);
  keyTypedListeners = new listenerList(EventType.KEY_TYPED);
  
  
  class keysListener implements listener{
    boolean b;
    keysListener(boolean B){b = B;}
    public double priority(EventType e){return 32768;}
    public boolean handle(Event e){
      keys[keyCode] = b;
      return true;
    }
  }
  
  keyPressedListeners.add(new keysListener(true));
  keyReleasedListeners.add(new keysListener(false));
  
}






interface listener{
  double priority(EventType e);
  boolean handle(Event e);// return true if event uncaught
}

class listenerList implements listener{
  ArrayList<listener> listeners;
  double priority;
  EventType type;
  listenerList(EventType e){
    priority = 0;
    type = e;
    listeners = new ArrayList<listener>();
  }
  double priority(EventType e){
    return priority;
  }
  void add(listener lis){
    //highest priority first.
    double  p = lis.priority(type); 
    int i = 0;
    int h = listeners.size();
    int l = 0;
    for(; h < l;){ // binary search for insertion place
      i = (h+l)>>1;
      if (p < listeners.get(i).priority(type)){
        l = i+1;
      }else{
        h = i;
      }
    }
    listeners.add(i,lis);
  }
  listener remove(int i){
    return listeners.remove(i);
  }
  boolean remove(listener i){
    return listeners.remove(i);
  }
  boolean handle(Event e){
    int t = listeners.size()-1;
    for (int i = 0; listeners.get(i).handle(e); i++){
      if (i >= t){
        return true;
      }
    }
    return false;
  }
}

boolean[] keys;











interface selectable{
  double selectDistance(Point p);
  double selectDistance(transform t,double x, double y);
  void drawSelect(transform t,PGraphics g);
  Iterable<selectable> selectableChildren();
}
