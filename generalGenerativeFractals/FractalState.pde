abstract class Fractal {
  
  abstract void stepDraw();
}


class IntPoint2D {
  int x;
  int y;
  
  IntPoint2D(int X, int Y){
    
    x=X;
    y=Y;
    
  }
  IntPoint2D add(IntPoint2D o){
    return new IntPoint2D(x+o.x,y+o.y);
  }
}

class cellMatrix{
  int[][] world;
  int[][] newWorld;
  int Width;
  int Height;
  cellMatrix(int w, int h){
    Width = w;
    Height = h;
    world = new int[w][h];
    newWorld = new int[w][h];
    for (int x = 0; x < w; x ++){
      for (int y = 0; y < h; y ++){
        world[x][y] = 0;
        newWorld[x][y] = 0;
      }
    }
  }
  int positiveMod(int a, int m){
    return (a>=0)?a%m:(a%m)+m; //if is faster than mod
  }
  int set(int x,int y, int v){
    //sets point x,y to v and returns v 
     newWorld[positiveMod(x,Width)][positiveMod(y,Height)] = v;
     return v;
  }
  int get(int x,int y){
    //gets point x,y 
     return world[positiveMod(x,Width)][positiveMod(y,Height)];
  }
  
  void next(){
    //applies changes (i.e. swaps world and newWorld)
    int[][] tmp = world;
    world = newWorld;
    newWorld = tmp;
  }
}

abstract class rule{
  abstract int next(int x, int y, cellMatrix c);
}
abstract class predicate{
  abstract boolean fits(int x, int y, cellMatrix c);
}
class pattern extends predicate{
  int[] offX;
  int[] offY;
  int[] val;
  pattern(int[] ox, int[] oy, int[] v){
    offX = ox;
    offY = oy;
    val = v;
  }
  
  boolean fits(int x, int y, cellMatrix c){
    for(int i = 0; i < val.length; i++){
      if (c.get(x+offX[i],y+offY[i]) != val[i]){
        return false;
      }
    }
    return true;
  }
}   
pattern transform(pattern p, float a, float b, float c, float d){
  int[] ox = new int[p.offX.length];
  int[] oy = new int[p.offY.length];
  for (int i = 0; i < ox.length; i ++){
    ox[i] = (int)(p.offX[i]*a+p.offY[i]*b);
    oy[i] = (int)(p.offX[i]*c+p.offY[i]*d);
  }
  return new pattern(ox,oy,p.val);
}
NHRule transform(NHRule r, float a, float b, float c, float d){
  pattern[] m = new pattern[r.masks.length];
  for (int i = 0; i < m.length; i ++){
    m[i] = transform((pattern)r.masks[i],a,b,c,d);
  }
  return new NHRule(m,r.results);
}

class NHRule extends rule{
  predicate[] masks;
  int[] results;
  NHRule(predicate[] p, int[] o){
    masks = p;
    results = o;
  }
  int next(int x, int y, cellMatrix c){
    for (int i = 0; i < masks.length; i++){
      if (masks[i].fits(x,y,c)){
        return results[i];
      }
    }
    return c.get(x,y);
  }
}
class acid extends rule{
  int subs;
  int a;
  int res;
  acid(int c, int e, int t){
    subs = c;
    a = e;
    res = t;
  }
  int next(int x, int y, cellMatrix c){
    int n = c.get(x,y);
    if (n == subs){
      int e = 0;
      for( int dx = -1; dx < 2; dx ++)
        for( int dy = -1; dy < 2; dy ++)
          e += (c.get(x+dx,y+dy) == a)?1:0;
      return (e >= 1)?a:subs; 
      
      
    }else{ if (n == a){
      return res;
    }}
    return c.get(x,y);
  }
  
}

class wireworld extends rule{
  int cond;
  int elec;
  int tail;
  wireworld(int c, int e, int t){
    cond = c;
    elec = e;
    tail = t;
  }
  int next(int x, int y, cellMatrix c){
    int n = c.get(x,y);
    if (n == cond){
      int e = 1;
      for( int dx = -1; dx < 2; dx ++)
        for( int dy = -1; dy < 2; dy ++)
          e += (c.get(x+dx,y+dy) == elec)?1:0;
      return ((e>>1) == 1)?elec:cond; 
      
      
    }else{ if (n == elec){
      return tail;
    }else{ if (n == tail){
      return cond;
    }}}
    return c.get(x,y);
  }
  
}


class cyclingCA extends Fractal{
  rule[] rules;
  color[] colors;
  int r;
  cellMatrix m;
  cyclingCA(rule[] rs,color[] cs, cellMatrix c){
    rules = rs;
    r = 0;
    colors = cs;
    m = c;
  }
  void stepDraw(){
    for( int x = 0; x < m.Width; x ++){
      for( int y = 0; y < m.Height; y ++){
        set(x,y,colors[m.get(x,y)]);
        m.set(x,y,rules[r].next(x,y,m));
      }
    }
    m.next();
    r ++;
    if (r >= rules.length)
      r = 0;
  }
}

class Icollision extends Fractal {
  ArrayList<IntPoint2D> heads;
  Boolean o;
    
  Icollision(){
    heads = new ArrayList<IntPoint2D>();
    o = false;
    heads.add(new IntPoint2D(0,0));
  }
  void stepDraw(){
    
    
  }
  
}