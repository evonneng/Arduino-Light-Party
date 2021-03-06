/**
  * Using Arduino Library, this code uses three LED's 
  * and an LED display screen which lights up according 
  * to beats in music 
  */
import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;

int ledPin =  12;    // LED connected to digital pin 12
int ledPin2 =  8;    // LED connected to digital pin 8
int ledPin3 =  2;    // LED connected to digital pin 2

float snareHeight, kickHeight, hatHeight;
float kickSize, snareSize, hatSize;

void setup() {
  size(512, 200, P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  
  song = minim.loadFile("sample1.mp3", 2048);
  song.play();
  
  // set buffer size and sample rate according to the input song
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);  
  
  //GUI initializations
  kickSize = snareSize = hatSize = 16;
  snareHeight = kickHeight = hatHeight = height/2;
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  
  arduino.pinMode(ledPin, Arduino.OUTPUT);    // set the arduino led's to output
  arduino.pinMode(ledPin2, Arduino.OUTPUT);  
  arduino.pinMode(ledPin3, Arduino.OUTPUT);  
}

void draw() {
  background(0);
  fill(255);
  if(beat.isKick()) {
      arduino.digitalWrite(ledPin, Arduino.HIGH);   // set the LED on
      kickSize = 32;
      kickHeight = height/1.75;
  }
  if(beat.isSnare()) {
      arduino.digitalWrite(ledPin2, Arduino.HIGH);   // set the LED on
      snareSize = 32;
      snareHeight = height/1.75;
  }
  if(beat.isHat()) {
      arduino.digitalWrite(ledPin3, Arduino.HIGH);   // set the LED on
      hatSize = 32;
      hatHeight = height/1.75;
  }
  arduino.digitalWrite(ledPin, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin2, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin3, Arduino.LOW);    // set the LED off
  
  // changing the textsize and position of text on gui for easier visualization
  textSize(kickSize);
  fill(255,217,0);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  fill(64,173,38);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  fill(222,29,42);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
  
  kickHeight = snareHeight = hatHeight = height/2;
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}