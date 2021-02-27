

car c;
void setup(){
  size(512,512);
  background(0);
  c = new car();
}


void draw(){
  background(0);
  c.step(1/60.);
  fill(255);
  stroke(128);
  c.draw(8);
}
