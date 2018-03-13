import processing.sound.*;

//Audio player for the reading task, adapted from SliderBoneConductor
class ReadingAudioPlayer
{
  SoundFile meisje;
  SoundFile heartBeat;
  SoundFile buzz;

  FocusedAttentionExplorer app;
  
  ReadingAudioPlayer(FocusedAttentionExplorer app) {
    this.app = app;
    meisje = new SoundFile(this.app, "meisjeLooped.wav");
    heartBeat = new SoundFile(this.app, "heartBeatLooped3.wav");
    buzz = new SoundFile(this.app, "buzzLooped.wav");
  }

  //play all three samples at the same time
  public void play()
  {
    meisje.play();
    heartBeat.play();
    buzz.play();
  }
  
  //stop all samples (call when we are done with the exercise)
  public void stop()
  {
    meisje.stop();
    heartBeat.stop();
    buzz.stop();
  }

  //adjust the mix between the three samples, for the given concentration (effort) level
  //which is a value between 0 and 100
  public void mix(float concentration)
  { 
    if (concentration < 20 ) {
      meisje.amp(1);
    } else if (concentration <= 60) {
      meisje.amp(map(concentration, 20, 60, 1, 0));
    } else {
      meisje.amp(0);
    }

    if (concentration < 20) {
      heartBeat.amp(0);
      buzz.amp(0);
    } else if (concentration >= 20 && concentration < 50) {
      heartBeat.amp(map(concentration, 20, 40, 0, 1));
    } else if (concentration >= 50 && concentration < 80) {
      heartBeat.amp(map(concentration, 60, 80, 1, 0));
    } else {
      heartBeat.amp(0);
    }
  }
}