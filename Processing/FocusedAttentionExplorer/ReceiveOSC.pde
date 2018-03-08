import oscP5.*;
import netP5.*;

class ReceiveOSC {


  OscP5 oscP5;
  NetAddress netAddress;
  String ipAdress = "127.0.0.1";
  int portNumber = 9002;
  String messageTag = "/index";


  public boolean recieving = false;


  ReceiveOSC() {
    oscP5 = new OscP5(this, portNumber);
    netAddress = new NetAddress(ipAdress, portNumber);
  }

  void oscEvent(OscMessage theOscMessage) {
    if (theOscMessage.checkAddrPattern(messageTag)==true) {
      oscIn = theOscMessage.get(0).floatValue();
      gotOSC = true;
    }
  }

  void oscSwitch() {
    if (oscIn == 0) recieving = false;
    else recieving = true;
  }
}