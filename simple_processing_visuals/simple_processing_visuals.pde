import beads.*;
import org.jaudiolibs.beads.*;
/*
String sF = "test.mp3";
SamplePlayer sp;
AudioContext ac;
Gain g;
Glide gainValue;
PowerSpectrum ps;
PeakDetector beatDetector;
PImage background;

float brightness;
int time; // tracks the time 

ArrayList colorWash;
ArrayList ballList;

PGraphics pg;
PGraphics balls_buffer;

Color current_muse;

public class Color{
   public float r, g, b;
   public Color(float r, float g, float b){
    this.r = r;
    this.g = g;
    this.b = b;
   }
}

int frame = 0; //used to keep track of numbers of draw loops

void setup()
{
  size(displayWidth, displayHeight);
  frameRate(30);
  pg = createGraphics(width, height);
  balls_buffer = createGraphics(width, height);
  current_muse = new Color((int)random(255),(int)random(250),(int)random(250));
  time = millis();
  background = createImage(width, height, RGB);
  //Set up all the equilizer balls
  ballList = new ArrayList();
  for(int i = 0; i < 35; i++)
  {
     ballList.add(new Ball(i*(displayWidth/30), height/2, 1));
  }
  
  colorWash = new ArrayList();
  colorWash.add(new Color(100,100,100));
  
  //set up the sound file
  ac = new AudioContext();
  try{
    sF = sketchPath("") + "goldfish.wav";
    sp = new SamplePlayer(ac, new Sample(sF));
  }
  catch(Exception e)
  {
    println("Error loading sample");
    e.printStackTrace();
    exit();  
  }
  gainValue = new Glide(ac, 0.0, 20);
  g = new Gain(ac, 1, gainValue);
  g.addInput(sp);
  ac.out.addInput(g);
  
  
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  sfs.setChunkSize(1024);
  sfs.setHopSize(441);
  // FFT stands for Fast Fourier Transform
  // all you really need to know about the FFT is that it lets you see what frequencies are present in a sound
  // the waveform we usually look at when we see a sound displayed graphically is time domain sound data
  // the FFT transforms that into frequency domain data
  FFT fft = new FFT();
  sfs.addListener(fft); // connect the FFT object to the ShortFrameSegmenter
  SpectralDifference sd = new SpectralDifference(ac.getSampleRate());
  
  ps = new PowerSpectrum(); // the PowerSpectrum pulls the Amplitude information from the FFT calculation (essentially)
  fft.addListener(ps); // connect the PowerSpectrum to the FFT
  ps.addListener(sd);
  beatDetector = new PeakDetector();
  sd.addListener(beatDetector);
  beatDetector.setThreshold(0.2f);
  beatDetector.setAlpha(.9f);
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
  ac.out.addDependent(sfs); // list the frame segmenter as a dependent, so that the AudioContext knows when to update it  
  
  
  ac.start();
  
  gainValue.setValue(1); //Volume: BE CAREFUL DONT PUT PAST 10 IF YOU VALUE YOUR EARS
  sp.setToLoopStart();
  sp.start();
  
  background(0);
  noStroke();
}

void processBackground()
{
   //PImage ret = createImage(width, height,RGB);
  background(0,100);
  for(int i = colorWash.size() - 1; i < 0; i--)
  {
     Color c = (Color)colorWash.get(i);
     fill(c.r, c.g, c.b);
     ellipse(0,0,(i*10) + 10, (i*10) + 10);
  } 
  
  //return ret;
}

void draw()
{
  frame++;
  
  //slow down the data so people have a chance to view it
  if(frame % 10 == 0)
  {
     //update the current color
    current_muse = new Color((int)random(255),(int)random(250),(int)random(250));
  }

  //Draw the background muse filling color data
  pg.beginDraw();
  pg.stroke(current_muse.r, current_muse.g, current_muse.b);
  pg.noFill();
  pg.ellipse(width/2,height/2,frame,frame);
  pg.endDraw();
  
  //Draw the rythmn balls
  float[] features = ps.getFeatures();
  if(features != null)
  {
    balls_buffer.beginDraw();
    for(int i = 0; i < ballList.size(); i++)
    {
        Ball ball = (Ball) ballList.get(i);
        
        int featureIndex = i + features.length / 35;
        int rad = ball.getPrevRad();
        int new_rad = (int)(Math.min(features[featureIndex], 400));
        rad = abs(rad - new_rad);
        ball.setPrevRad(rad);
        balls_buffer.fill(0,0,0,255); //fully transparent
        balls_buffer.ellipse(ball.getx(), ball.gety(), rad, rad);
    }
    balls_buffer.endDraw();
    
    background(0);
    tint(255, 255);
    image(balls_buffer, 0, 0);
    blendMode(DIFFERENCE);
    image(pg, 0, 0);
    //blend(balls_buffer, 0, 0, width, height, 0,0,width,height,SCREEN); 
  }

  int dt = millis() - time;
  brightness -= (dt * 0.01);
  if (brightness < 0) brightness = 0;
  time += dt;
}
*/
