class table{
  ArrayList<Ball> balls;
  table(){
    balls = new ArrayList<Ball>();
  }
  
  void draw(){
    for (Ball b: balls){
      b.draw();
    }
  }
  
  double step(){
    int collideA = 0;
    int collideB = 0;
    double collideT = inf;
    for (int i = 0; i < balls.size(); i++){
      for (int j = i+1; i < balls.size(); i++){
        double t = balls.get(i).relativeTo(balls.get(j)).intersect(balls.get(j).size);
        if (t < collideT){
          collideT = t;
          collideA = i;
          collideB = j;
        }
      }
    }
    //do colision
    
    
    
    
    return collideT;
  }
  
  
}
