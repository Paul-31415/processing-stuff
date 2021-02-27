double G = -6.67408e-11;

void drawSphere(double x, double y, double z,double r){
  translate((float)x,(float)y,(float)z);
  sphere((float)r);
  translate((float)-x,(float)-y,(float)-z);
  //ellipse((float)((x+r/2)/z),(float)((y+r/2)/z),(float)((x-r/2)/z),(float)((y-r/2)/z));
}
void drawSphere(vec p,double r){
  drawSphere(p.x,p.y,p.z,r);
}


class rock{
  vec pos,vel,force;
  double mass,size;
  color clr;
  rock(vec p,vec v,double m, double s,color c){
    pos = p;vel = v;mass = m;size = s;
    force = new vec();
    clr = c;
  }
  void interact(rock o){
    //colision
    final double dist = pos.sub(o.pos).mag();
    if (dist<=o.size+size){
      //delete radial velocity components and shift rocks appropriately
      //conserving center of mass
      //shift rock by (otherm)/(msum)
      //center of mass = ((pos+dp)*mass+(o.pos-dp2)*o.mass)/(mass+o.mass)
      final double ddist = o.size+size-dist;
      final double totmass = mass + o.mass;
      final vec delta = o.pos.sub(pos);
      final double factor = o.mass/totmass;
      pos.subEq(delta.scale(ddist*factor/dist));
      o.pos.addEq(delta.scale(ddist*(1-factor)/dist));
      
      //set reference frame to center of mass
      final vec refvel = vel.scale(mass).addEq(o.vel.scale(o.mass)).divEq(totmass);
      
      vel.subEq(refvel);
      o.vel.subEq(refvel);
      //set radial velocity components to 0
      vel.perpEq(delta);
      o.vel.perpEq(delta);
      
      //preserve angular momentum
      //L = r x p = r x v * m
      //as r gets += ddist, r gets /= dist/(o.size+size)
      //so p must get *= dist/(o.size+size)
      vel.scaleEq(dist/(o.size+size));
      o.vel.scaleEq(dist/(o.size+size));
      
      
      //vel.scaleEq(0);
      //o.vel.scaleEq(0);
      //back to global frame
      vel.addEq(refvel);
      o.vel.addEq(refvel);
      
      
    }else{
      //gravity
      final vec f = pos.sub(o.pos).scaleEq(G*mass*o.mass/dist/dist/dist);
      force.addEq(f);
      o.force.subEq(f);
      
    }
    
  }
  void update(double dt){
    vel.addEq(force.divEq(mass).scaleEq(dt));
    pos.addEq(vel.scale(dt));
    
    force.scaleEq(0);
  }
  void draw(vec p, angle rot,double zoom){
    //p.neg().translate_();
    //rot.unrotate_();
    
    final vec lp = rot.inverse().apply(pos.sub(p)).scale(zoom);
    fill(clr);
    drawSphere(lp,size*zoom);
    if (heldKeys[9]){
      noFill();
      stroke(red(clr),green(clr),blue(clr),64);
      sphereDetail(5);
      drawSphere(lp,size*zoom*5e3);
      sphereDetail(30);
      noStroke();
      fill(1);
       //fill(red(clr),green(clr),blue(clr),16);
      //drawSphere(lp,size*zoom*5e6);
    }
    
    //rot.rotate_();
    //p.translate_();
  }
}

class world{
  ArrayList<rock> rocks;
   world(){
     rocks = new ArrayList<rock>();
   }
  void update(double dt){
    for (int i = 0; i < rocks.size();i++){
      for (int j = i+1; j < rocks.size();j++){
        rocks.get(i).interact(rocks.get(j));
      }
    }
    for (rock r : rocks){
      r.update(dt);
    }
  }
  void draw(vec pos, angle rot,double zoom){
    for (rock r : rocks){
      r.draw(pos,rot,zoom);
    }
    /*
    pos.neg().translate_();
    rot.unrotate_();
    
    stroke(color(255,0,0));
    line(0,0,width/32,0);
    stroke(color(0,255,0));
    line(0,0,0,height/32);
    rotateX(PI/2);
    stroke(color(0,0,255));
    line(0,0,0,height/32);
    rotateX(-PI/2);
    
  
    
    rot.rotate_();
    */
    
    vec x = rot.inverse().apply(new vec(-1,0,0).scale(height/32));
    vec y = rot.inverse().apply(new vec(0,-1,0).scale(height/32));
    vec z = rot.inverse().apply(new vec(0,0,-1).scale(height/32));
    stroke(color(0,255,255));
    line(0,0,(float)x.x,(float)x.y);
    stroke(color(255,0,255));
    line(0,0,(float)y.x,(float)y.y);
    stroke(color(255,255,0));
    line(0,0,(float)z.x,(float)z.y);
    //pos.translate_();
    
    
  }
}
