import processing.sound.*;

//Audio player for the reading task, adapted from SliderBoneConductor
class ReadingAudioPlayer
{
  SoundFile meisje;
  FocusedAttentionExplorer app;
  
  ReadingAudioPlayer(FocusedAttentionExplorer app) {
    this.app = app;
    meisje = new SoundFile(this.app, "meisjeLooped.wav");
  }

  //play all three samples at the same time
  public void play()
  {
    meisje.play();
  }
  
  //stop all samples (call when we are done with the exercise)
  public void stop()
  {
    meisje.stop();
  }

  //adjust the mix between the three samples, for the given concentration (effort) level
  //which is a value between 0 and 100
  public void mix(float concentration)
  {
    float level = concentration/100;//concentration is highest when 0, lowest when 100, because it is the theta_beta index
    meisje.amp(level);//level should be a value between 0 and 1
  }
}