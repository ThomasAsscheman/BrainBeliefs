 import oscP5.*;
import netP5.*;

//Global variables
Hud hud;
Graph graph;
SendSerial sendSerial;
WearableManager wearableManager;
FeedbackAudioPlayer feedbackAudioPlayer;//Audioplayer for the neurofeedback exercise (with the line)
Smoother smoother;
BaselineProtocol bp;
PFont userfont; 

boolean withSerial = false;
boolean withMouse = false;

float tbVal = 0;//current smoothed value
public float displayPos;

void setup() {
  //fullScreen();
  size(1080, 640);
  frameRate(30);  
  userfont = createFont("Arial",16,true);
  hud = new Hud();
  graph = new Graph();
  wearableManager = new WearableManager();
  
  //setup audioplayer for feedback session, silent at first
  feedbackAudioPlayer = new FeedbackAudioPlayer(this);
  
  smoother = new Smoother();

  if (withSerial) {
    sendSerial = new SendSerial();
    serialPort = new Serial(this, portName, 9600);
    sendSerial.serialMessage(0, 0, 0, 0, 0);//om de neopixel te resetten en de vibratie motor op stil
  }

  bp = new BaselineProtocol(this);
}

//just a quick method to show something on the screen
void displayUserMessage(String message)
{
    textAlign(CENTER, CENTER);
    textFont(userfont,32);
    fill(255);
    text(message,width/2,height/2);
}

//used to proceed to the next state
void mouseClicked()
{
  switch(bp.p.getCurrentState()) {
  case Init:
    bp.ProceedState();//click to continue
    break;
  case Baseline_recording:
    break;
  case Baseline_complete:
    bp.ProceedState();//click to continue
    break;
  case Feedback_recording://this is the actual game
    break;
  case Feedback_complete:
    bp.ProceedState();//click to continue to reading task
    break;
  case Reading_task:
    break;
  case Reading_task_complete:
    bp.ProceedState();//click to restart
  }
}

void draw() {
  background(0);

  switch(bp.p.getCurrentState()) {
  case Init:
    cursor();
    displayUserMessage("Klik op het scherm om te starten met de baseline meting.");
    break;
  case Baseline_recording:
    noCursor();
    hud.blocks();
    //displayUserMessage("+");
    break;
  case Baseline_complete:
    cursor();
    displayUserMessage("Baseline meting voltooid! Klik op het scherm om door te gaan.");
    bp.ProceedState();
    break;
  case Feedback_recording://this is the actual game
    noCursor();
    hud.activate();
    graph.activate();
    wearableManager.activate();
    feedbackAudioPlayer.activate();
    if (withMouse) { 
      displayPos = mouseY;
    } else {
      displayPos = map_val_to_screen(tbVal, (float)bp.getMean(), (float)bp.getSd(), height); 
      if (displayPos < 0) displayPos = 0;
    }
    break;
  case Feedback_complete:
    cursor();
    displayUserMessage("Klaar! Klik op het scherm om verder te gaan met de leesopdracht.");
    break;
  case Reading_task:
    hud.blocks();
    displayUserMessage("-----");
    //TODO balkje dat 3 minuten optelt, onderin scherm.
    break;
  case Reading_task_complete:
    displayUserMessage("Klaar! Klik op het scherm om helemaal opnieuw te beginnen");
    break;
  }
}

//map the incoming theta_beta_index value to a y screen coordinate, 
//taking into account the mean and sd measured during baseline
float map_val_to_screen(float theta_beta_index, float mean, float sd, float screen_height)
{
   int factor = 2;//constante voor het aantal sd's tussen het midden van het scherm en de bovenkant
   float difference = (theta_beta_index - mean);//absoluut verschil tussen tb index en mean
   float sds = difference / sd;//verschil in termen van sd
   float y = (screen_height / 2) + ((sds/factor) * (screen_height/2));//mapping naar scherm
   //since the processing coordinate system has 0 at the top of the screen we don't have to flip y
   //TODO: enforce max/min values
   return y;
}

//fires every time there is a new value
void OnFeedbackValue(float value)
{
  this.tbVal = smoother.smooth(value);
  this.smoother.setDirty();
}

//fires every time there is a state change, 
//just for information, since the state gets read on every frame.
void OnStateChange(ApplicationState.State s)
{
  println("glob state changed to: " + s );
  switch(s)
  {
    case Feedback_complete:
      this.feedbackAudioPlayer.muteBuzz();
      break;
  }
}