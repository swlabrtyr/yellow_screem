import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
Minim       minim;
AudioInput mic;
float px, py;
double ticks;
boolean goingLeft;
float smooth = 0;
PShader blur;

void setup() {
  size(1024, 768, P3D);
  minim = new Minim(this);
  mic=minim.getLineIn();
  px = 0;
  py = random(50, height-50);
  ticks = 0;
  goingLeft = true;
  background(255);
  //  colorMode(HSB,100);
  blur = loadShader("blur.glsl");
}

void draw() {
  ticks++;
  //  background(255);
  float sum = 0;
  for (int i = 0; i < mic.bufferSize () - 1; i++)
  {
    //    line(i, 50 + mic.left.get(i)*50, i+1, 50 + mic.left.get(i+1)*50);
    sum += abs(mic.left.get(i));
  }

  //  println(sum / mic.bufferSize());
  float volume = sum / mic.bufferSize();
  volume=pow(volume, 2)*5;  
  smooth += (volume - smooth) * 0.1;
  float percentage=1 - sqrt(smooth/2);
  fill(236*percentage, 252*percentage, 10*percentage, 200);
  noStroke();
  if (smooth > 0.02) {
    float next;
    if (goingLeft) {
      next = smooth*10;
    } else {
      next = smooth*10;
    }

    //    line(px, py, next, py);
    rect(px, py+(noise(frameCount*0.1)-0.5)*10, next, 50);
    px += next;
    if (px > 1024) {
      px = 0;
      py += 50;
    }
  } else {

    py = random(0, 768);

    goingLeft = ! goingLeft;

    px = goingLeft ? 0 : 1024;
  }
  //  filter(blur);
}
