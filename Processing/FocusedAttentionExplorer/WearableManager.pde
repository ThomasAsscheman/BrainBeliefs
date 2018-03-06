class WearableManager {

  public int neoR;
  public int neoG;
  public int neoB;
  public int neoTime = 1;
  public int vibrationVal = 0;

  int counter = 0;
  int off = 1;

  Hud hud;

  WearableManager() {
  }

  void activate() {
    if (withSerial) {
      counter++;
      if (counter >= 4) {

        if (lastActiveBlock < activeBlock) {
          vibrationVal = 2;
        } else if (colorFade >= fadeMax - 5) {
          if (activeBlock == amount/2) vibrationVal = 8;
          else vibrationVal = 9;
        } else vibrationVal = 0;

        if (activeBlock == amount/2) {
          neoR = 255;
          //neoRint(map(colorFade, fadeMin - 10, fadeMax + 10, 200, 250));
          neoG = 80;
          neoB = 20;
          sendSerial.serialMessage(neoR, neoG, neoB, neoTime, vibrationVal);
          lastActiveBlock = activeBlock;
        } else if (activeBlock > 0) {      
          //neoR = int(map(activeBlock, 1, amount/2, 80, 255));
          //neoR = int(map(colorFade, fadeMin, fadeMax, 50, activeBlock * (255/((amount/2)+1))));
          neoR = int(map(activeBlock, 1, (amount/2)-1, 100, 255));
          neoG = 0;
          neoB = 0;
          sendSerial.serialMessage(neoR, neoG, neoB, neoTime, vibrationVal);
          lastActiveBlock = activeBlock;
        } else if (activeBlock <= 0) {
          vibrationVal = 0;
          sendSerial.serialMessage(off, off, off, neoTime, vibrationVal);
          lastActiveBlock = activeBlock;
        }

        counter = 0;
      }
    }
  }
}