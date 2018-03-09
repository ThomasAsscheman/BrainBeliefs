import oscP5.*;
import netP5.*;

//Global variables
Hud hud;
StartScreen startScreen;
Graph graph;
SendSerial sendSerial;
WearableManager wearableManager;
AudioManager audioManager;
Smoother smoother;
Target target;
BaselineProtocol bp;

boolean withSerial = false;
boolean withMouse = false;

float tbVal = 0;//current smoothed value

float tbMin = -0.5;
float tbMax = 1.5;
public float displayPos;

void setup() {
  //fullScreen();
  size(1080, 640);
  noCursor();
  frameRate(30);
  //displayPos = height/2;

  startScreen = new StartScreen();
  hud = new Hud();
  graph = new Graph();
  wearableManager = new WearableManager();
  audioManager = new AudioManager(this);
  smoother = new Smoother();
  target = new Target();

  if (withSerial) {
    sendSerial = new SendSerial();
    serialPort = new Serial(this, portName, 9600);
    sendSerial.serialMessage(0, 0, 0, 0, 0);//om de neopixel te resetten en de vibratie motor op stil
  }

  bp = new BaselineProtocol(this);
}


void draw() {
  background(255);

  switch(bp.p.getCurrentState()) {
  case Init:
    println("TODO Implement button to start");
    //move to Baseline_started
    bp.ProceedState();
    break;
  case Baseline_recording:
    //don't show anything, TODO: show a plus sign in the middle of the screen
    //this state will automatically transition to complete
    break;
  case Baseline_complete:
    print("TODO Implement button to continue");
    bp.ProceedState();
    break;
  case Feedback_recording://this is the actual game
    hud.activate();
    graph.activate();
    wearableManager.activate();
    audioManager.activate();
    if (withMouse) { 
      displayPos = mouseY;
    } else {
      tbVal = smoother.smooth(tbVal);
      displayPos = map(tbVal, tbMin, tbMax, 0, height);//tbVal is the smoothed value
      if (displayPos < 0) displayPos = 0;
    }
    break;
  case Feedback_complete:
    print("FINISHED; TODO Implement button to reset");
    exit();
    //bp.ProceedState();
    break;
  }
}

//fires every time there is a new value
void OnFeedbackValue(float value)
{
  this.tbVal = value;
  this.smoother.setDirty();
}

//fires every time there is a state change, 
//just for information, since the state gets read on every frame.
void OnStateChange(ApplicationState.State s)
{
  print("glob state changed to: " + s );
}