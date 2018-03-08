import ddf.minim.*;
import ddf.minim.effects.*;
import processing.sound.*;
Minim minim;
AudioSample[] bell = new AudioSample[5];
AudioPlayer buzz;

Hud hud;
StartScreen startScreen;
Graph graph;
ReceiveOSC receiveOSC;
SendSerial sendSerial;
WearableManager wearableManager;
AudioManager audioManager;
Smoother smoother;
Target target;

boolean withSerial = false;

int state = 2;

public boolean gotOSC = false;
public float oscIn = 0;


public float tbVal = 0;
float tbMin = -0.5;
float tbMax = 1.5;
public float displayPos;


public int amount = 8;
public int blockNum;
public int blockSize;
public int activeBlock;
public int lastActiveBlock;
public int colorFade = 150;
public int fadeMax = 200;
public int fadeMin = 100;




void setup() {
  fullScreen();
  //size(1080, 640);
  noCursor();
  frameRate(30);
  //displayPos = height/2;

  startScreen = new StartScreen();
  hud = new Hud();
  graph = new Graph();
  receiveOSC = new ReceiveOSC();
  wearableManager = new WearableManager();
  audioManager = new AudioManager();
  smoother = new Smoother();
  target = new Target();

  minim = new Minim(this);
  for (int i = 0; i < 5; i++) {
    bell[i] = minim.loadSample("bell" + i + ".mp3");
  }
  buzz = minim.loadFile("water1.mp3");
  buzz.loop();

  if (withSerial) {
    sendSerial = new SendSerial();
    serialPort = new Serial(this, portName, 9600);
    sendSerial.serialMessage(0, 0, 0, 0, 0);//om de neopixel te resetten en de vibratie motor op stil
  }
}


void draw() {
  background(255);
  stateManager();
  if (receiveOSC.recieving == false) displayPos = mouseY;
  else {
    displayPos = map(tbVal, tbMin, tbMax, 0, height);//tbVal is the smoothed value
    if (displayPos < 0) displayPos = 0;
  }
}

void stateManager() {
  switch(state) {
  case 1:
    startScreen.activate();
    break;
  case 2:
    hud.activate();
    graph.activate();
    receiveOSC.oscSwitch();
    wearableManager.activate();
    audioManager.activate();
    smoother.activate();
    break;
  }
}


void mousePressed() {
  oscIn = 0;
}