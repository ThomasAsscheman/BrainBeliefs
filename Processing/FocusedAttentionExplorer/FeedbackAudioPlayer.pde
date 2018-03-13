import ddf.minim.*;
import ddf.minim.effects.*;
//import processing.sound.*;

//audio player for the main exercise with the line
class FeedbackAudioPlayer {

  Minim minim;
  AudioSample[] bell = new AudioSample[5];
  AudioPlayer buzz;

  FocusedAttentionExplorer app;
  
  FeedbackAudioPlayer(FocusedAttentionExplorer app) {
    this.app = app;
    minim = new Minim(this.app);
    for (int i = 0; i < 5; i++) {
      bell[i] = minim.loadSample("bell" + i + ".mp3");
    }
    buzz = minim.loadFile("water1.mp3");
    buzz.loop();
    buzz.mute();
  }

  void activate() {
    if (lastActiveBlock < activeBlock) triggerBell();
    playBuzz();
  }

  void triggerBell() {
    bell[activeBlock-1].trigger();
  }
  
  void muteBuzz()
  {
    buzz.mute();
  }

  void playBuzz() {
    buzz.setGain(map(displayPos, height/2, height, 10, 30));
    if (displayPos <= height/2) buzz.mute();
    else buzz.unmute();
  }
}