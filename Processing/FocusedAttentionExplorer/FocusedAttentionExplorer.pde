import oscP5.*;
import netP5.*;

//Global variables
Hud hud;
Graph graph;
SendSerial sendSerial;
WearableManager wearableManager;
FeedbackAudioPlayer feedbackAudioPlayer;//Audioplayer for the neurofeedback exercise (with the line)
ReadingAudioPlayer readingAudioPlayer;//Audioplayer for the reading exercise

Smoother smoother;
BaselineProtocol bp;
PFont userfont; 

boolean withSerial = true;
boolean withMouse = false;

float tbVal = 0;//current smoothed value
public float displayPos;

void setup() {
  fullScreen();
  //size(1080, 640);
  frameRate(30);  
  userfont = createFont("Arial",16,true);
  hud = new Hud();
  graph = new Graph();
  wearableManager = new WearableManager();
  
  //setup audioplayer for feedback session, silent at first
  feedbackAudioPlayer = new FeedbackAudioPlayer(this);
  readingAudioPlayer = new ReadingAudioPlayer(this);
  
  smoother = new Smoother();

  if (withSerial) {
    sendSerial = new SendSerial();
    serialPort = new Serial(this, portName, 9600);
    sendSerial.serialMessage(0, 0, 0, 0, 0);//om de neopixel te resetten en de vibratie motor op stil
  }

  bp = new BaselineProtocol(this);
  
  //to skip to a given state in the protocol, for debugging purposes
  //bp.p.setCurrentState(ApplicationState.State.Feedback_recording);
}

//just a quick method to show something on the screen
void displayUserMessage(String message)
{
    cursor();
    textAlign(CENTER, CENTER);
    textFont(userfont,32);
    fill(255);
    text(message,width/2,height/2);
}

//used to proceed to the next state
void mouseClicked()//TODO: should be space key
{
  print("mouse clicked");
  switch(bp.p.getCurrentState()) {
  case Init:
  case Baseline_start:
  case Baseline_complete:
  case Line_start:
  case Line_complete:
  case Feedback_start:
  case Feedback_complete:
  case Focus_tips:
  case Feedback2_start:
  case Feedback2_complete:
  case Feedback3_start:
  case Feedback3_complete:
  case Reading_task_start:
  //case Reading_task_recording://TODO: should be q key!
  case End:
    bp.ProceedState();//click to continue
    break;
  }
}

void keyPressed()
{
  switch(bp.p.getCurrentState())
  {
    case Reading_task_recording:
      if(key == 'q')
      {  
        bp.ProceedState();
      }
      break;
    case Init:
    case Baseline_start:
    case Baseline_complete:
    case Line_start:
    case Line_complete:
    case Feedback_start:
    case Feedback_complete:
    case Focus_tips:
    case Feedback2_start:
    case Feedback2_complete:
    case Feedback3_start:
    case Feedback3_complete:
    case Reading_task_start:
    case End:
      if(key == ' ')
      {
        bp.ProceedState();
      }
      break;
  }
}

void draw() {
  background(0);

  switch(bp.p.getCurrentState()) {
  case Init:
    displayUserMessage("Tijdens deze eerste oefening ga je kennis maken met je eigen hersenen. \nMet de elektrode op je hoofd meten we jouw hersenactiviteit. \nDe hersenactiviteit zegt iets over jouw focus op dat moment.\n\nKlik steeds op spatie om verder te gaan.");
    break;
  case Baseline_start:
    displayUserMessage("Voordat we kunnen beginnen,\n moeten we eerst een rustmeting doen van 1 minuut.\n Probeer je te ontspannen en stil te zitten, \nkijk naar het witte kruisje");
    break;
  case Baseline_recording://graph only, no hud!
    displayUserMessage("+");
    noCursor();
    break;
  case Baseline_complete:
    displayUserMessage("Bedankt voor het stilzitten, nu kunnen we beginnen!\n Je ziet zo een balletje op en neer bewegen.\n Als het balletje omhoog gaat, heb je meer focus.\n Als het balletje omlaag gaat, heb je minder focus.");
    break;
  case Line_start:
    displayUserMessage("Je zult merken dat jouw hoeveelheid focus steeds verandert,\n dat is normaal.");
    break;
  case Line_recording:
    noCursor();
    UpdateDisplayMapping();
    graph.activate();
    break; 
  case Line_complete:
    displayUserMessage("Je hebt net je eigen hersenactiviteit gezien!\n In de volgende oefening\nga je proberen invloed uit te oefenen\n op je eigen hersenactiviteit.\n Het doel is om je zo veel mogelijk te focussen,\n en zo lang mogelijk achter elkaar.");
    break;
  case Feedback_start:
    displayUserMessage("Probeer de lijn zo hoog mogelijk te krijgen en ervaar wat er gebeurt.");
    break;
  case Feedback_recording://this is the actual game
  case Feedback2_recording:
  case Feedback3_recording:
    noCursor();
    UpdateDisplayMapping();
    hud.activate();
    hud.effortBar();
    graph.activate();
    wearableManager.activate();
    feedbackAudioPlayer.activate();
    break;
  case Feedback_complete:
    hud.activate();
    displayUserMessage("En, kreeg je een beetje controle over je eigen hersenactiviteit?\n Als het nog niet lukte, dan is dat heel normaal,\n je hebt dit immers nog nooit gedaan.\n Als het al wel lukte, weet je ook hoe je dit voor elkaar kreeg?");
    break;
  case Focus_tips:
    hud.activate();
    displayUserMessage("We gaan het nog een keer proberen.\n Iedereen moet een eigen manier vinden om \ncontrole te krijgen over de eigen hersenactiviteit");
    break;
  case Feedback2_start:
    hud.activate();
    displayUserMessage("We kunnen een paar tips geven:\n (1) Wil het heel graag dus doe heel veel moeite!\n (2) Stel je voor dat je met superkracht het balletje kan bewegen\n (the  Force…) ");
    break;
  case Feedback2_complete:
    hud.activate();
    displayUserMessage("Voordat we naar de volgende oefening gaan,\n proberen we een minuut te ontspannen,\n alles even los te laten.");
    break;
  case Feedback3_start:
    hud.activate();
    displayUserMessage("Straks zie je weer het balletje op en neer gaan.\n Probeer nu eens door je diep te relaxen,\n het balletje omlaag,\n in de blauwe balken te krijgen");
    break;
  case Feedback3_complete:
    //weer zwarte achtergrond
    displayUserMessage("Dank je wel!");
    break;
  case Reading_task_start:
    displayUserMessage("Je krijgt nu een pagina tekst.\n Probeer je te concentreren en de tekst te lezen.");
    break;
  case Reading_task_recording:
    //zwart scherm
    float concentration = map_val_to_screen(tbVal, (float)bp.getMean(), (float)bp.getSd(), 100);
    readingAudioPlayer.mix(concentration);
    noCursor(); 
    break;
  case End:
    displayUserMessage("Klik op spatie om opnieuw te beginnen.");
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
   
   if(y > screen_height) y = screen_height;
   if(y < 0) y = 0;
   
   return y;
}

//fires every time there is a new value
void OnFeedbackValue(float value)
{  
  this.tbVal = value;
  this.smoother.setDirty();
}

//calculate intermediate graph values
void UpdateDisplayMapping()
{
  this.tbVal = smoother.smooth(this.tbVal);
  if (withMouse) { 
      displayPos = mouseY;
   } else {
      displayPos = map_val_to_screen(this.tbVal, (float)bp.getMean(), (float)bp.getSd(), height); 
   }
}

//fires every time there is a state change, 
//just for information, since the state gets read on every frame.
void OnStateChange(ApplicationState.State s)
{
  println("glob state changed to: " + s );
  switch(s)
  {
    case Feedback_complete:
    case Feedback2_complete:
    case Feedback3_complete:
    case Reading_task_start:
      this.feedbackAudioPlayer.muteBuzz();
      break;
    case Reading_task_recording:
      this.readingAudioPlayer.play();
      break;
    case End:
      this.readingAudioPlayer.stop();
      break;
  }
}