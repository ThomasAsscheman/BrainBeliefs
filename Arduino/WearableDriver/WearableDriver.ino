// SERIAL PARSING VARIABLES --------------------------------------------------

const byte numChars = 32;
char receivedChars[numChars];
char tempChars[numChars];

const char HEADER   = 'H';
const char A_TAG    = 'M';
const char B_TAG    = 'X';
const int  TOTAL_BYTES  = 10  ; // the total bytes in a message


// NEOPIXEL VARIABLES --------------------------------------------------------

#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN            6
#define NUMPIXELS      1
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);

int pixelVoltage = 8;
boolean pixelTriggered = false;

#include <elapsedMillis.h>
elapsedMillis timerVal;


// VIBRATION MOTOR DRV2605 VARIABLES -----------------------------------------------

#include <Wire.h>
#include "Adafruit_DRV2605.h"

Adafruit_DRV2605 drv;

uint8_t effect = 1;


// MAIN PROGRAM -----------------------------------------------------------------

void setup() {
  Serial.begin(9600);
  Serial.println("<Arduino is ready>");
  Serial.println();

  pinMode(pixelVoltage, OUTPUT);
  pixels.begin();

  Serial.println("Test");

  pixels.setPixelColor(0, pixels.Color(0,0,0));
  pixels.show();

  drv.begin();
  drv.selectLibrary(1);
  drv.setMode(DRV2605_MODE_INTTRIG);
}

void loop() {
  digitalWrite(pixelVoltage, HIGH);
  readSerial();
  delay(50);
}
// READ SERIAL --------------------------------------------------------------

void readSerial() {
  if ( Serial.available() >= TOTAL_BYTES)
  {
    if ( Serial.read() == HEADER)
    {
      char tag = Serial.read();
      if (tag == A_TAG)
      {
        //Collect integers
        int a = Serial.read() * 256;
        a = a + Serial.read();
        int b = Serial.read() * 256;
        b = b + Serial.read();
        int c = Serial.read() * 256;
        c = c + Serial.read();
        int d = Serial.read() * 256;
        d = d + Serial.read();
        int e = Serial.read() * 256;
        e = e + Serial.read();

        int neoR = a;
        int neoG = b;
        int neoB = c;
        int neoTime = d;
        int vibrationVal = e;


        if (vibrationVal > 0 && vibrationVal < 117) triggerVibration(vibrationVal);
        if (neoR > 0 || neoG > 0 || neoB > 0) triggerNeoPixel(neoR, neoG, neoB, neoTime);
        //        Serial.print("R: ");
        //        Serial.print(neoR);
        //        Serial.print(", G: ");
        //        Serial.print(neoR);
        //        Serial.print(", B: ");
        //        Serial.print(neoR);
        //        Serial.print(", T: ");
        //        Serial.println(neoTime);
      }
    }
  }
}
// NEOPIXEL ---------------------------------------------------------------

void triggerNeoPixel(int rVal, int gVal, int bVal, int timeOn) {

  if (rVal > 1 || gVal > 1 || bVal > 1 ) {
    pixels.setPixelColor(0, pixels.Color(rVal, gVal, bVal));
    pixels.show();
  } else {
    pixels.setPixelColor(0, pixels.Color(0, 0, 0));
    pixels.show();
  }
}

// VIBRATION MOTOR DRV206 --------------------------------------------------

void triggerVibration(int effectVal) {

  effect = effectVal;
  Serial.print("effectVal");
  Serial.println(effectVal);

  drv.setWaveform(0, effect);  // play effect
  drv.setWaveform(1, 0);       // end waveform
  drv.go();
}



