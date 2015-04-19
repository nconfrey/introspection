// Beat_Detection_01.pde

// this example is based in part on an example included with the Beads download originally written by Beads creator Ollie Brown
// in this example we draw a shape on screen whenever a beat is detected

import beads.*;

/*
AudioContext ac;
PeakDetector beatDetector;

// In this example we detect onsets in the audio signal
// and pulse the screen when they occur. The brightness is controlled by 
// the following global variable. The draw() routine decreases it over time.
float brightness;
int time; // tracks the time 

void setup()
{
  size(300,300);
  time = millis();
  
  // set up the AudioContext and the master Gain object
  ac = new AudioContext();
  Gain g = new Gain(ac, 2, 0.2);
  ac.out.addInput(g);
  
  // load up a sample included in code download
  SamplePlayer player = null;
  try
  {
    player = new SamplePlayer(ac, new Sample(sketchPath("") + "goldfish.wav")); // load up a new SamplePlayer using an included audio file
    g.addInput(player); // connect the SamplePlayer to the master Gain
  }
  catch(Exception e)
  {
    e.printStackTrace(); // if there is an error, print the steps that got us to that error
  }  
  
  // set up the ShortFrameSegmenter
  // this class allows us to break an audio stream into discrete chunks
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.setChunkSize(2048); // how large is each chunk?
  sfs.setHopSize(441);
  sfs.addInput(ac.out); // connect the sfs to the AudioContext
  
  FFT fft = new FFT();
  PowerSpectrum ps = new PowerSpectrum();
  
  sfs.addListener(fft);
  fft.addListener(ps);
  
  // the SpectralDifference unit generator does exactly what it sounds like
  // it calculates the difference between two consecutive spectrums returned by an FFT (through a PowerSpectrum object)
  SpectralDifference sd = new SpectralDifference(ac.getSampleRate());
  ps.addListener(sd);
  
  // we will use the PeakDetector object to actually find our beats
  beatDetector = new PeakDetector();
  sd.addListener(beatDetector);
  
  // the threshold is the gain level that will trigger the beat detector - this will vary on each recording
  beatDetector.setThreshold(0.2f);
  beatDetector.setAlpha(2f);
 
  // whenever our beat detector finds a beat, set a global variable 
  beatDetector.addMessageListener
  (
    new Bead()
    {
      protected void messageReceived(Bead b)
      {
        brightness = 1.0;      
      }
    }
  );
  
  ac.out.addDependent(sfs); // tell the AudioContext that it needs to update the ShortFrameSegmenter
  ac.start(); // start working with audio data
}

// the draw method draws a shape on screen whwenever a beat is detected
void draw()
{
  background(0);
  fill(brightness*255);
  ellipse(width/2,height/2,width/2,height/2);  
  
  // decrease brightness over time
  int dt = millis() - time;
  brightness -= (dt * 0.01);
  if (brightness < 0) brightness = 0;
  time += dt;
  
  // set threshold and alpha to the mouse position
  beatDetector.setThreshold((float)mouseX/width);
  beatDetector.setAlpha((float)mouseY/height);
}
*/
