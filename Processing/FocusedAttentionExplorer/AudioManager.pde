class AudioManager {

  AudioManager() {
  }

  void activate() {
    if (lastActiveBlock < activeBlock) triggerBell();
    playBuzz();
  }

  void triggerBell() {
    bell[activeBlock-1].trigger();
  }

  void playBuzz() {
    buzz.setGain(map(displayPos, height/2, height, 10, 30));
    if(displayPos <= height/2) buzz.mute();
    else buzz.unmute();
  }
}