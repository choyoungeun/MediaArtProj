float yoff = 0;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minimLib;
AudioPlayer audio1;
AudioInput input;
PImage img;

void setup() {
  size(900, 900);
  img = loadImage("KakaoTalk_20210519_170041237_01.jpg");
  minimLib = new Minim(this);
  audio1 = minimLib.loadFile("Charles Atlas - Photosphere.mp3");
  audio1.play(0);
}

void draw() {
  image(img, 0, 0, width, height); 
  translate(width / 2.2, height / 2.35);
  //rotate(PI / 2);

  stroke(255);
  fill(255, 50);
  strokeWeight(1);

  float da = PI / 200;
  float dx = 0.05;

  float xoff = 0;
  beginShape();
  for (float a = 0; a <= TWO_PI; a += da) {
    float n = noise(xoff, yoff);
    float r = sin(2 * a) * map(n, 0, 1, 50, 300);
    float x = r * cos(a);
    float y = r * sin(a);
    if (a < PI){
        xoff += dx; 
    } else{
        xoff -= dx; 
    }
    //point(x, y);
    vertex(x, y);
  }
  endShape();

  yoff += 0.01;
}
