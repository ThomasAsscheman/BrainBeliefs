class Smoother {
  
  float oscAttValue;
  float oscMedValue;
  float oldAttValue = 0;
  float newAttValue = 0;
  float thisAttValue = 0;
  float deltaAttValue = 0;


  int thisTime = millis();
  int oldAttTime = millis();
  int newAttTime = millis();
  int deltaAttTime = 1;


  boolean gotAttValue = false;

  Smoother() {
    oldAttValue = oscAttValue;
    oldAttTime = millis();


    newAttValue = oscAttValue;
    newAttTime = millis();

    deltaAttValue = newAttValue-oldAttValue;
    deltaAttTime=newAttTime-oldAttTime;
  }

  void activate() {

    oscAttValue = oscIn;

    if (gotOSC) {
      gotOSC = false;
      oldAttValue = newAttValue;
      newAttValue = oscAttValue;
      deltaAttValue = newAttValue-oldAttValue;
      oldAttTime = newAttTime;
      newAttTime = millis();
      deltaAttTime=newAttTime-oldAttTime;
    }  

    float attRatio = 0;
    thisTime = millis();
    float passedAttTime = thisTime-newAttTime;
    if (deltaAttTime > 0) {
      attRatio = passedAttTime/deltaAttTime;
    }
    thisAttValue = oldAttValue+ (attRatio* deltaAttValue);
    
    tbVal = thisAttValue;
  }
}