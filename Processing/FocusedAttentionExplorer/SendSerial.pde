import processing.serial.*;
public Serial serialPort;


public String portName = "COM9";

public static final char HEADER    = 'H';
public static final char A_TAG = 'M';
public static final char B_TAG = 'X';


class SendSerial {

  SendSerial() {
  }  

  void serialMessage(int a, int b, int c, int d, int e) {
    serialPort.write(HEADER);
    serialPort.write(A_TAG);
    serialPort.write((char)(a / 256));
    serialPort.write(a & 0xff);
    serialPort.write((char)(b / 256));
    serialPort.write(b & 0xff);
    serialPort.write((char)(c / 256));
    serialPort.write(c & 0xff);  
    serialPort.write((char)(d / 256));
    serialPort.write(d & 0xff);  
    serialPort.write((char)(e / 256));
    serialPort.write(e & 0xff);
  }
}