public int amount = 8;
public int blockNum;
public int blockSize;
public int activeBlock;
public int lastActiveBlock;
public int colorFade = 150;
public int fadeMax = 200;
public int fadeMin = 100;

class Hud {

  
  int gradient = 255;

  float fadeSpeed = 8;
  float minSpeed = 6;
  float maxSpeed = 12;

  int barBg = 10;


  Hud() {
    blockSize = height/amount;
  }

  void activate() {
    blocks();
    highlight();
    effortBar();
  }

  void blocks() {
    noStroke();
    for (int i = 0; i < height; i+= blockSize) {
      if (i < height/2) fill(map(i, 0, height/2, 255, 0), 10, 10); //map de kleur van rood naar volledig donker voor de bovenste helft
      else /*if (i >= height/2)*/ fill(0, map(i, height/2, height, 0, 20), map(i, height/2, height, 0, 25));//map van zwart naar een klein beetje blauw
      rect(0, i, width, blockSize);
    }
  }

  void highlight() {
    float yPos;
    
    if (displayPos < height/2) {      
      for (int i = 0; i < amount/2; i++) {
        if (displayPos > i * blockSize && displayPos < (i + 1) * blockSize ) {
          yPos = i * blockSize;

          if (yPos == 0) fill(255, colorFade + 10, 0, colorFade);
          else fill(255, map(displayPos, 0, height/2, 200, 40), map(displayPos, 0, height/2, 100, 20), colorFade);

          rect(0, yPos, width, blockSize);
          strokeWeight(1);
          stroke(map(yPos, 0, height/2, 255, 150), 80, 80);
          line(0, yPos, width, yPos);
          stroke(map(yPos, 0, height/2, 255, 100), 40, 0);
          line(0, yPos + blockSize, width, yPos + blockSize);
          
          activeBlock = (amount / 2) - (i);
        }
      }

      colorFade += fadeSpeed;
      if (colorFade < fadeMin || colorFade > fadeMax) {
        fadeSpeed *= -1;
      }
    } else activeBlock = -1;
  }

  void effortBar() {
    noStroke();
    fill(barBg);
    rect(100, height - (blockSize/2) - 6, 200, 12);

    fill(map(displayPos, 0, height, 0, 50), map(displayPos, 0, height, 255, 50), map(displayPos, 0, height, 150, 50), map(displayPos, 0, height, 255, 200));
    textSize(14);
    textAlign(CENTER, CENTER);
    text("effort", 200, height - (blockSize/2) - 18);

    rect(100, height - (blockSize/2) - 6, map(displayPos, 0, height, 200, 0), 12);
  }
}