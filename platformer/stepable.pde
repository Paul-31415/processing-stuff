abstract class stepable{
  boolean removeMeFromStepables = false;
  abstract void step(double dt,world w);
}