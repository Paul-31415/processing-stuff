interface curve{
  abstract vector get(double t);
  abstract vector get(double[] t);
  abstract double start();
  abstract double end();
  abstract int dimension();
 
}

class brushedCurve implements drawable,selectable{
  brush b;
  curve c;
  brushedCurve(brush B, curve C) { b = B; c = C; }
  void draw(transform t,PGraphics g){
    b.draw(c,g,0.001);
  }
  
  Iterable<selectable> selectableChildren(){
    return ((selectable)c).selectableChildren();
  }
  double selectDistance(Point p){
    //euclidiean distance

     return ((selectable)c).selectDistance(p);
    
  }
  double selectDistance(transform t,double x, double y){
    return ((selectable)c).selectDistance(t,x,y);
  }
  void drawSelect(transform t,PGraphics g){
    ((selectable)c).drawSelect(t,g);
  }
  
}

class Bezier implements vector,curve,selectable{//weights are now included for ease of use
  long uid = ++UNIQUE_ID;
  
  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      //ref
      return "@"+namespace.getKey(this);
    }else{
      //new
      String k = "Bezier_"+ uid;
      String v = "";
      for (int i = 0; i < controlPoints.size() ; i++){
       v += "\n\"controlPoint"+i+"\":"+ controlPoints.get(i).save(namespace);
      }
      namespace.put(k,this);
      return "\""+k+"\"=\"Bezier\"("+v+")";
      
    }
    
  }
  
  Bezier New(){
    return new Bezier();
  }
  
  void setParameter(String param,Object o){
      if (o instanceof vector){
        vector v = (vector) o;
        final String p = "controlPoint";
        if (param.length() <= p.length()){
          println("error: tried to set param "+param+" of Bezier"); 
          assert(1==0);
        }
        switch (param.substring(0,p.length())){
          case p:
            int i = Integer.parseInt(param.substring(p.length()));
            if (i == controlPoints.size()){
              controlPoints.add(v);
            }else{
              controlPoints.set(i,v);
            }
            break;
          default:
            println("error: tried to set param "+param+" of Bezier"); 
            assert(1==0);
        }
      }
    
  }
  
  
  int dimension(){
    if (controlPoints.size()>0){
      if (controlPoints.get(0) instanceof curve){
        return 1 + ((curve)controlPoints.get(0)).dimension();
      }else{
        return 1;
      }
    }
    return 1;
  }
  
  
  
  Iterable<selectable> selectableChildren(){
    ArrayList<selectable> res = new ArrayList<selectable>();
    for (vector v : controlPoints){
      if (v instanceof selectable){
        res.add((selectable)v);
      }
    }
    return (Iterable<selectable>) res;
  }
  double selectDistance(Point p){
    //euclidiean distance

     return 100000;
    
  }
  double selectDistance(transform t,double x, double y){
    return 100000;
  }
  void drawSelect(transform t,PGraphics g){
    drawableVector p = null;
    for(vector v: controlPoints){
      if (v instanceof weightedVector){
        v = ((weightedVector)v).get();
      }
      if (v instanceof drawableVector){
        
        drawableVector d = (drawableVector)t.apply((Point)v);
        g.stroke(color(128,128,0));
        
        if (p != null){
          g.line(p.x(),p.y(),d.x(),d.y());
        }
        p = d;
      }
    }
  }
  
  
  ArrayList<vector> controlPoints;
  double start(){return 0;}
  double end(){return 1;}
  
  Bezier add(vector v){
    controlPoints.add(v);return this;
  }
  
  
  
  Bezier(vector... p){
    controlPoints = new ArrayList<vector>();
    for(vector v:p){
      controlPoints.add(v);
    }
  }
  Bezier(ArrayList<vector> p){
    controlPoints = p;
  }
  int order(){
    return controlPoints.size()-1;
  }
  vector get(double[] t){
    vector v = this;
    for(double d:t){
      v = ((curve)v).get(d);
    }
    return v;
  }
  vector get(double t){
    if(controlPoints.size() == 1){
      return controlPoints.get(0).copy();
      
    }
    // b(t,K (control point index) ,v)=bin(N,K)*(1-t)^(N-K) * t^K * v
    vector res = controlPoints.get(0).zero();
    double bin = 1;
    for(int i = 0; i < controlPoints.size(); i++){
      res.plusEq(controlPoints.get(i).times(
      bin*
      Math.pow((1-t),order()-i)*
      Math.pow(t,i)
      ));
      bin *= ((double)order()-i)/(i+1);
    }
    return res;
  }
  Bezier incrementedOrder(){
    //https://stackoverflow.com/questions/44084802/converting-between-bezier-curves-of-different-degreeorder
    int n = order();
    int k = n+1;
    
    vector[] v = new vector[k+1];
    v[0] = controlPoints.get(0).copy();
    v[k] = controlPoints.get(n).copy();
    for( int i = 1; i <= n ; i++){
      v[i] = controlPoints.get(i).times(n-i+1).plusEq(controlPoints.get(i-1).times(i)).timesEq(1./k);
    }
    
    return new Bezier(v);
  }
  
  Bezier incrementOrder(){
    //https://stackoverflow.com/questions/44084802/converting-between-bezier-curves-of-different-degreeorder
    int n = order();
    if(n == 0){
      controlPoints.add(controlPoints.get(0).copy());
      return this;
    }
    int k = n+1;
    controlPoints.add(controlPoints.get(n).copy());
    for( int i = n; i >= 1 ; i--){
      controlPoints.get(i).timesEq(n-i+1).plusEq(controlPoints.get(i-1).times(i)).timesEq(1./k);
    }
    return this;
  }
  Bezier getNHigher(int n){
    Bezier res = (Bezier)this.copy();
    while (n > 0){
      res.incrementOrder();
      n -= 1;
    }
    return res;
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  vector plus(vector O){
    Bezier o = (Bezier) O;
    if (o.order() > order()){
      return o.plus(this);
    }
    Bezier co = o.getNHigher(order()-o.order());
    for(int i = 0; i < controlPoints.size(); i++){
      co.controlPoints.get(i).plusEq(controlPoints.get(i));
    }
    return co;
  }
  
  vector plusEq(vector O){
    Bezier o = (Bezier) O;
    if (o.order() > order()){
      while (o.order() > order()){
        incrementOrder();
      }
    }else{
       o = o.getNHigher(order()-o.order());
    }
    for(int i = 0; i < controlPoints.size(); i++){
      controlPoints.get(i).plusEq(o.controlPoints.get(i));
    }
    return this;
  }
  
  vector times(vector O){
    
    Bezier o = (Bezier) O;
    if (o.order() > order()){
      return o.plus(this);
    }
    Bezier co = o.getNHigher(order()-o.order());
    for(int i = 0; i < controlPoints.size(); i++){
      co.controlPoints.get(i).timesEq(controlPoints.get(i));
    }
    return co;
  }
  
  vector timesEq(vector O){
    Bezier o = (Bezier) O;
    if (o.order() > order()){
      while (o.order() > order()){
        incrementOrder();
      }
    }else{
       o = o.getNHigher(order()-o.order());
    }
    for(int i = 0; i < controlPoints.size(); i++){
      controlPoints.get(i).timesEq(o.controlPoints.get(i));
    }
    return this;
  }
  
  vector times(double o){
    Bezier r = new Bezier();
    for(int i = 0; i < controlPoints.size(); i++){
      r.controlPoints.add(controlPoints.get(i).times(o));
    }
    return r;
  }
  vector timesEq(double o){
    for(int i = 0; i < controlPoints.size(); i++){
      controlPoints.get(i).timesEq(o);
    }
    return this;
  }
  
  vector copy(){
    Bezier r = new Bezier();
    for(int i = 0; i < controlPoints.size(); i++){
      r.controlPoints.add(controlPoints.get(i).copy());
    }
    return r;
  }
  
  vector zero(){
    return new Bezier(controlPoints.get(0).zero());
  }
  
}


class weightedSelectableVector<t extends vector> extends weightedVector<t> implements selectable{
  
  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      //ref
      return "@"+namespace.getKey(this);
    }else{
      //new
      String k = "weightedSelectableVector_"+ uid;
      String val = "\"weight\":\""+w+"\",\"vector\":"+ v.save(namespace);
      namespace.put(k,this);
      return "\""+k+"\"=\"weightedSelectableVector\"("+val+")";
      
    }
    
  }
  weightedSelectableVector New(){
    return new weightedSelectableVector();}
    
  weightedSelectableVector(){super();}
  weightedSelectableVector(t v, double w){
    super(v,w);
    assert ( v instanceof selectable);
    
  }
  
  Iterable<selectable> selectableChildren(){
    ArrayList<selectable> res = new ArrayList<selectable>();
    //res.add((selectable)super.v);
    return (Iterable<selectable>) res;
  }
  double selectDistance(Point p){
    //euclidiean distance

     return ((selectable)super.get()).selectDistance(p);
    
  }
  double selectDistance(transform t,double x, double y){
    return ((selectable)super.get()).selectDistance(t,x,y);
  }
  void drawSelect(transform t,PGraphics g){
    ((selectable)super.get()).drawSelect(t,g);
  }
  weightedSelectableVector setWeight(double newW){
    super.v.timesEq(newW/super.w);
    super.w = newW;
    return this;
  }
}


class weightedVector<t extends vector> implements vector{
//for rational bezier curves

  long uid = ++UNIQUE_ID;
  
  String save(connectionMap<String,Object> namespace){
    if (namespace.containsValue(this)){
      //ref
      return "@"+namespace.getKey(this);
    }else{
      //new
      String k = "weightedVector_"+ uid;
      String val = "\"weight\":\""+w+"\",\"vector\":"+ v.save(namespace);
      namespace.put(k,this);
      return "\""+k+"\"=\"weightedVector\"("+val+")";
      
    }
    
  }
  weightedVector New(){
    return new weightedVector();}
  
  void setParameter(String param,Object o){
      //println(o);
      if (o instanceof dString){
        switch (param){
          case "weight":
            w = Double.parseDouble(((SaveableString)(((dString)o).obj)).contents);
            break;
          case "vector":
            println("error: vector is a string");
            assert (1==0);
          
          default:
            println("error: tried to set param "+param+" of weightedVector"); 
            assert(1==0);
        }
      }else
      if (o instanceof vector){
        if (param.equals("vector")){
          v = (t)o;
        }
      }
    
  }
  
  
  t v;
  double w;
  
  String toString(){
    return "("+v+",weight="+w+")";
  }


  weightedVector(){}
  weightedVector( t V, double W,boolean b){ v = V; w = W;}
  weightedVector( t V, double W){ v = (t) V.times(W); w = W;}
  vector copy(){
    return new weightedVector(v.copy(),w,true);
  }
  
  vector plus(vector O){
    weightedVector o = (weightedVector) O;
    //when adding, add them weighted appropriately and with a new weight: w+o.w
    weightedVector res = new weightedVector(v.plus(o.v),
    w+o.w,true);
    return res;//new weightedVector(v.plus(o.v),
    //w+o.w,true);
  }
  vector plusEq(vector O){weightedVector o = (weightedVector) O;
    v.plusEq(o.v);
    w += o.w; 
    return this;
  }
  vector times(vector O){weightedVector o = (weightedVector) O;
    return new weightedVector(v.times(o.v),w*o.w,true);
  }
  vector timesEq(vector O){weightedVector o = (weightedVector) O;
    v.timesEq(o.v);
    w *= o.w; return this;
  }
  vector times(double o){
    return new weightedVector(v.times(o),w*o,true);
  }
  vector timesEq(double o){
    w *= o;
    v.timesEq(o);
    return this;
  }
  
  vector zero(){
    return new weightedVector(v.zero(),0);
  }
  
  vector get(){
    return v.times(1/w);
  }
  
}
