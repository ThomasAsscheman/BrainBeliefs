import processing.serial.*;
Serial port;

import ddf.minim.*;

Minim minim;
AudioPlayer electricity;
AudioPlayer bell;

float electricityVolume;

boolean firstContact = false;
byte data;

int interval;
int concentration;
String number;

void setup()
{
  size(300, 600);
  noCursor();
  printArray(Serial.list());
  String portName = Serial.list()[0];
  port = new Serial(this, portName, 9600);

  minim = new Minim(this);
  electricity = minim.loadFile("sparks.wav");
  bell = minim.loadFile("bell.mp3");

}

void draw() {
  background(20);


  if (firstContact == true) {
    concentration = int(map(mouseY, 0, height, 100, 0));
    println("slider: " + concentration);
    port.write(concentration);
  }

  electricityVolume = map(concentration, 0, 100, 0, 1);

  if (!electricity.isPlaying()) {
    electricity.rewind();
    electricity.play();
    //electricity.shiftVolume(electricityVolume, electricityVolume, 10);
  }

  if (concentration >= 95) {
    bell.play();
  }

  if (!bell.isPlaying()) {
    bell.rewind();
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

void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();
      firstContact = true;
      println("port connected");
    }
  } else {
    println(inByte);
    myPort.clear();
  }
}