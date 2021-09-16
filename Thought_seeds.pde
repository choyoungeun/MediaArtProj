import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minimLib;
AudioPlayer audio1;
AudioInput input;

Particle[] particles = new Particle[1000];
boolean saving = false;
PImage img;

void setup() {
  size(1200,900);
   minimLib = new Minim(this);
  audio1 = minimLib.loadFile("Lee Maddeford - Le petit jardin (with Les Gauchers Orchestra).mp3");
  audio1.play(0);
  img = loadImage("KakaoTalk_20210519_170041237_01.jpg");
  smooth();
  
  // create particles
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(new PVector(width/2.2,height/2.3));
  }
}

void draw() {
  image(img, 0, 0, width, height);
  // draw the particles
  for (int i = 0; i < particles.length; i++) {
    particles[i].update();
    particles[i].draw();
  }
}



// ---------------
// Particle.pde
// Based on the Particle class from: http://www.shiffman.net/teaching/nature/particles/
// ---------------
class Particle {
  PVector loc;
  PVector vel;
  PVector acc;

  PVector[] hist;
  int counter = 0;
  
  // create the particle
  Particle(PVector l) {
    float randmin = -HALF_PI;
    float randmax = 0;
    
    float r = random(0, TWO_PI);
    float x = cos(r);
    float y = sin(r);
    acc = new PVector(x / 250, y / 250);

    float q = random(0, 1);
    r = random(randmin, randmax);
    x = cos(r) * q;
    y = sin(r) * q;
    vel = new PVector(x, y);
    loc = l.get();    
    hist = new PVector[1000];
  }

  // update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    // save location every 10 frames
    if (frameCount % 10 == 0 && counter < hist.length) {
      hist[counter] = loc.get();
      counter++;
    }
  }

  // draw particle
  void draw() {
    fill(255,192,203);
    drawArrowHead(vel,loc,10);
    noFill();
    // draw history path
    stroke(255,192,203);
    beginShape();
    for (int i=0; i < counter; i++) {
      vertex(hist[i].x,hist[i].y);
    }
    if (counter > 0) vertex(loc.x, loc.y);
    //println(counter);
    
  }
  
  
   void drawArrowHead(PVector v, PVector loc, float scale) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(loc.x, loc.y);
    
    // rotate to heading
    rotate(v.heading2D());

    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scale;
    arrowsize = map(len, 0, 10, 0, 1) * arrowsize;

    // Draw point
    stroke(255,192,203);
    fill(0, 100);
    line(0,0,len-arrowsize,0);
    noStroke();
    beginShape();
    vertex(len,len);
    vertex(len-arrowsize,+arrowsize/2);
    vertex(len-arrowsize,-arrowsize/2);
    endShape(CLOSE);
    popMatrix();
  }
}
