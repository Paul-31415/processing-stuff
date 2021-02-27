




interface brush{
  abstract void draw(curve c,PGraphics g,double res);
}

class simpleBrush implements brush{
  
  
  void drawraw(curve c,PGraphics g,double res){
    float oox = 0; float ooy = 0;
    float ox = 0; float oy = 0;
    boolean startDrawing = false;
    for(double t = c.start(); t < c.end(); t += res){
      vector v = c.get(t);
      if (v instanceof curve){
        this.drawraw((curve)v,g,res);
      }else{
        if (v instanceof weightedVector){
          v = ((weightedVector)v).get();
        }
        assert (v instanceof drawableVector);
        drawableVector p = (drawableVector) v;
        if (startDrawing){
          float d = sqrt(sq(p.x()-ox)+sq(p.y()-oy));
          //sharpness
          float crs = (ox-oox)*(p.y()-oy)-(p.x()-ox)*(oy-ooy);
        g.stroke(color((int)((t-c.start())/(c.end()-c.start())*255),(int)(d*256),(int)(100*crs/d/d)));
        g.point(p.x(),p.y());
          
        }else{
          startDrawing = true;
          ox = p.x();
          oy = p.y();
        }
        oox = ox;
        ooy = oy;
        ox = p.x();
        oy = p.y();
        
      }
    }
    
  }
  void draw(curve c,PGraphics g,double res){
    //vector prev = c.get(c.start());
    
    this.drawraw(c,g,Math.pow(res,1./c.dimension()));
    /* /
    for(double a = 0; a < 1; a += res){
    for(int dim = 0; dim < c.dimension(); dim++){
      double[] pos = new double[c.dimension()];
      for(int i = 0; i < pos.length; i++){
        double[] d = new double[i];
        for(int j = 0; j < d.length; j++)
          d[j] = 0;
        pos[i] = ((curve)c.get(d)).start()*(1-a)+((curve)c.get(d)).end()*a;
      }
      double[] d = new double[dim];
      for(int j = 0; j < d.length; j++) d[j] = 0;
      
      vector prev = c.get(pos);
      for(; pos[dim] < ((curve)c.get(d)).end(); pos[dim] += res){
      
        assert (prev instanceof drawableVector);
        
        vector n = c.get(pos);
        
        drawableVector p = (drawableVector) prev;
        drawableVector N = (drawableVector) n;
        line(p.x(),p.y(),N.x(),N.y());
        prev = n;
      
      }
      
      
    }
    }
    */
    
    
  }
  
}
