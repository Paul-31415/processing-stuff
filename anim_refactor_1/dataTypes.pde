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
class connectionMap<A,B>{
  HashMap<A,B> forward;
  HashMap<B,A> backward;
  connectionMap(){
     forward = new HashMap<A,B>();
    backward = new HashMap<B,A>();
  }
  B put(A k, B v){
    forward.put(k,v);
    backward.put(v,k);
    return v;
  }
  B get(A k){
    return forward.get(k);
  }
  A getKey(B v){
    return backward.get(v);
  }
  int size(){
    return forward.size();
  }
  B remove(A k){
    backward.remove(forward.get(k));
    return forward.remove(k);
  }
  
  A removeValue(B k){
    forward.remove(backward.get(k));
    return backward.remove(k);
  }
  boolean containsKey(A k){
    return forward.containsKey(k);
  }
  boolean containsValue(B v){
    return forward.containsValue(v);
  }
  
  
}
