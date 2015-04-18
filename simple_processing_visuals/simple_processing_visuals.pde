import beads.*;
import org.jaudiolibs.beads.*;

String sF = "test.mp3";
SamplePlayer sp;
AudioContext ac;
Gain g;
Glide gainValue;
ArrayList ballList;

void setup()
{
  size(1024, 760);
  
  //Set up all the equilizer balls
  ballList = new ArrayList();
  for(int i = 0; i < 35; i++)
  {
     ballList.add(new Ball(i*30, 500, 30));
  }
  //set up the sound file
  ac = new AudioContext();
  try{
    sF = sketchPath("") + "Lift.wav";
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
  
  ac.start();
  
  gainValue.setValue(50);
  sp.setToLoopStart();
  sp.start();
  
  background(0);
  noStroke();
}

void draw()
{
  for(int i = 0; i < ballList.size(); i++)
  {
      Ball ball = (Ball) ballList.get(i);
      ellipse(ball.getx(), ball.gety(), ball.getRad(), ball.getRad());
      fill(ball.getColor());
  }
  
}
