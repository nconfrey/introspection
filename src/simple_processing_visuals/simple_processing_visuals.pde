import beads.*;
import org.jaudiolibs.beads.*;

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

//Muse variables
BufferedReader reader;
String[] muse_data;
Color current_muse;
boolean MUSE_OKAY = true; //just so we can run even without the muse

//set some calibration values
float startAccX = 0;
float startAccY = 0;
float startAccZ = 0;
float startDelta = 0;
float startTheta = 0;
float startAlpha = 0;
float startBeta = 0;
float startGamma = 0;


public class Color{
   public float r, g, b;
   public Color(float r, float g, float b){
    this.r = r;
    this.g = g;
    this.b = b;
   }
}
//COLOR CONSTANTS FOR MOODS
Color MELLOW = new Color(227,255,13);
Color CALM = new Color(86,238,254);
Color LOVE = new Color(255,49,31);
Color UNCERTAIN = new Color(219,0,219);
Color FRUSTRATED = new Color(255,165,56);
Color DEVILISH = new Color(138,0,247);
Color STRESSED = new Color(70,232,0);
Color ANGRY = new Color(230,0,0);
Color TIRED = new Color(238,204,115);
Color CONTENT = new Color(255,229,63);
Color CREATIVE = new Color(0,204,51);

int frame = 0; //used to keep track of numbers of draw loops

void setup()
{
  
  size(displayWidth, displayHeight, P3D);
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
    sF = sketchPath("") + "werk.wav";
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
  sfs.setChunkSize(2048);
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
  beatDetector.setThreshold(0.3f);
  beatDetector.setAlpha(.8f);
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
  
    try
    {
      muse_data = loadStrings("data.txt");//reader.readLine();  
    }
    catch(Exception e)
    {
      muse_data = null;
      return; //maybe a dangerous assumption, but the show must go on!
    }
    if(muse_data != null)
    {
       String[] pieces = split(muse_data[0], ',');
       startAccX = float(pieces[0]);
       startAccY = float(pieces[1]);
       startAccZ = float(pieces[2]);
       startDelta = float(pieces[3]);
       startTheta = float(pieces[4]);
       startAlpha = float(pieces[5]);
       startBeta = float(pieces[6]);
       startGamma = float(pieces[7]);
    }
  
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

//==========================================Draw Loop=======================================

void draw()
{
  frame++;
  background(255*brightness);
  //slow down the data so people have a chance to view it
  
  //values provided from the muse - zeroed out just in case
  float cAccX = 0;
  float cAccY = 0;
  float cAccZ = 0;
  float cDelta = 0;
  float cTheta = 0;
  float cAlpha = 0;
  float cBeta = 0;
  float cGamma = 0;
  
  if(MUSE_OKAY)
  {
    println("hi");
    try
    {
      muse_data = loadStrings("data.txt");//reader.readLine();  
    }
    catch(Exception e)
    {
      muse_data = null;
      return; //maybe a dangerous assumption, but the show must go on!
    }
    if(muse_data != null)
    {
       try{ 
         String[] pieces = split(muse_data[0], ',');
         cAccX = float(pieces[0]) - startAccX;
         cAccY = float(pieces[1]) - startAccY;
         cAccZ = float(pieces[2]) - startAccZ;
         cDelta = float(pieces[3]) - startDelta;
         cTheta = float(pieces[4]) - startTheta;
         cAlpha = float(pieces[5]) - startAlpha;
         cBeta = float(pieces[6]) - startBeta;
         cGamma = float(pieces[7]) - startGamma;
       }
       catch(Exception e)
       {
         cAccX = startAccX;
         cAccY = startAccY;
         cAccZ = startAccZ;
         cDelta = startDelta;
         cTheta = startTheta;
         cAlpha = startAlpha;
         cBeta = startBeta;
         cGamma = startGamma;
       }
    }
    println("accx " + cAccX + " accy is " + cAccY);
    println("muse_data is " + muse_data);
  }

  //current_muse = new Color(map(cL_ear,0,1500,0,255),map(cL_forehead,0,1500,0,255),map(cR_forehead,0,1500,0,255));
  //Compute mood color based on brain waves

  float[] waves_sorted = {cDelta, cTheta, cAlpha, cBeta, cGamma};
  sort(waves_sorted);
  float max = waves_sorted[4];
  float penulmax = waves_sorted[3];
  println("max is " + max);

    if(cAlpha == max)
    {
      if(cDelta == penulmax)
        current_muse = MELLOW;// MELLOW
      else if(cTheta == penulmax)
        current_muse = CALM;// CALM
      else if(cBeta == penulmax)
        current_muse = CONTENT;
      else if(cGamma == penulmax)
        current_muse = CREATIVE;
    }
    else if(cBeta == max)
    {
      if(cDelta == penulmax)
        current_muse = ANGRY;
      else if(cTheta == penulmax)
        current_muse = ANGRY;
      else if(cAlpha == penulmax)
        current_muse = FRUSTRATED;
      else if(cGamma == penulmax)
        current_muse = STRESSED;
    }
    else if(cGamma == max)
    {
      if(cDelta == penulmax)
        current_muse = UNCERTAIN;
      else if(cTheta == penulmax)
        current_muse = UNCERTAIN;
      else if(cAlpha == penulmax)
        current_muse = LOVE;
      else if(cBeta == penulmax)
        current_muse = DEVILISH;
    }
    else // ur basically asleep or something weird. black.
    {
      current_muse = new Color(255,255,255);
      // TIRED (or sleeping) // black
      // if this happens, ur like dead or somethin
      
    }



  //Draw the background muse filling color data
  pg.beginDraw();
  pg.stroke(current_muse.r, current_muse.g, current_muse.b);
  pg.noFill();
  pg.ellipse((width/2),(height/2),frame,frame);
  pg.endDraw();
  
  //Draw the rythmn balls
  float[] features = ps.getFeatures();
  if(features != null)
  {
    balls_buffer.beginDraw();
    balls_buffer.fill(104,104,104); //slowly fade out old balls
    balls_buffer.background(0);
    for(int i = 0; i < ballList.size(); i++)
    {
        Ball ball = (Ball) ballList.get(i);
        
        int featureIndex = i + features.length / 35;
        int rad = ball.getPrevRad();
        int new_rad = (int)(Math.min(features[featureIndex], 400));
        rad = abs(rad - new_rad);
        ball.setPrevRad(rad);
        balls_buffer.noStroke();
        //balls_buffer.fill(map(cL_ear,0,1500,0,255),map(cL_forehead,0,1500,0,255),map(cR_forehead,0,1500,0,255),75); //fully transparent
        balls_buffer.fill(255);
        balls_buffer.ellipse(ball.getx(), ball.gety(), rad, rad);
    }
    balls_buffer.endDraw();
    
    PImage pi = pg.get();
    pi.mask(balls_buffer);
    image(pi, 0, 0);
    //tint(255, 255);
    //image(balls_buffer, 0, 0);
    //blendMode(DIFFERENCE);
    //image(pg, 0, 0);
    //blend(balls_buffer, 0, 0, width, height, 0,0,width,height,SCREEN); 
  }
  //brightness = 0;
  int dt = millis() - time;
  brightness -= (dt * 0.009);
  if (brightness < 0) brightness = 0;
  time += dt;
}
