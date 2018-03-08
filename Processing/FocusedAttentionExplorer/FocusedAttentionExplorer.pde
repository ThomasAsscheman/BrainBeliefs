//Global variables
Hud hud;
StartScreen startScreen;
Graph graph;
ReceiveOSC receiveOSC;
SendSerial sendSerial;
WearableManager wearableManager;
AudioManager audioManager;
Smoother smoother;
Target target;
BaselineProtocol bp;

boolean withSerial = false;

int state = 2;

public boolean gotOSC = false;
public float oscIn = 0;

public float tbVal = 0;
float tbMin = -0.5;
float tbMax = 1.5;
public float displayPos;

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
  audioManager = new AudioManager(this);
  smoother = new Smoother();
  target = new Target();

  if (withSerial) {
    sendSerial = new SendSerial();
    serialPort = new Serial(this, portName, 9600);
    sendSerial.serialMessage(0, 0, 0, 0, 0);//om de neopixel te resetten en de vibratie motor op stil
  }
  
  bp = new BaselineProtocol(this);
  
  //move to Baseline_started
  bp.ProceedState();
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

void OnFeedbackValue(float value)
{
  print(value);
}

void OnStateChange(ApplicationState.State s)
{
    print("glob state changed to: " + s );

    if (s == ApplicationState.State.Baseline_complete)
    {
      print("baseline complete!");
      //bp.ProceedState();
    }

    if (s == ApplicationState.State.Feedback_complete)
    {
      print("feedback complete!");
      //bp.ProceedState();
    }
}