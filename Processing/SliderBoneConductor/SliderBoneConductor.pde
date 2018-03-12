import processing.sound.*;

SoundFile meisje;
SoundFile heartBeat;
SoundFile buzz;

int concentration;
String number;

void setup()
{
  size(300, 600);
  noCursor();  

  meisje = new SoundFile(this, "meisjeLooped.wav");
  heartBeat = new SoundFile(this, "heartBeatLooped3.wav");
  buzz = new SoundFile(this, "buzzLooped.wav");
  
  meisje.play();
  heartBeat.play();
  buzz.play();
}

void draw() {
  background(20);
  
  buzz.amp(0);
  concentration = int(map(mouseY, 0, height, 100, 0));
  
  if (concentration < 20 ) {
    meisje.amp(1);
  } else if (concentration <= 60) {
    meisje.amp(map(concentration, 20, 60, 1, 0));
  } else {
    meisje.amp(0);
  }
  
  if (concentration < 20){
    heartBeat.amp(0);
    buzz.amp(0);
  } else if (concentration >= 20 && concentration < 50){
    heartBeat.amp(map(concentration, 20, 40, 0, 1));
    //buzz.amp(map(concentration, 20, 50, 0, 1));
  } else if (concentration >= 50 && concentration < 80){
    heartBeat.amp(map(concentration, 60, 80, 1, 0));
  } else {
    heartBeat.amp(0);
  }

  stroke(255);
  strokeWeight(2);
  for (int i = 1; i < 10; i++) {
    line (width/2 - 30, i * height/10, width/2 + 30, i * height/10);
  }

  strokeWeight(4);
  noFill();
  stroke(0, 200, 0);
  ellipse(width/2, mouseY, 20, 20);

  noStroke();
  fill(50);
  ellipse(mouseX, mouseY, 5, 5);  

  number = str(concentration);
  fill(255);
  textSize(30);
  textAlign(CENTER, CENTER);
  text(number, width/4, height/2);
}