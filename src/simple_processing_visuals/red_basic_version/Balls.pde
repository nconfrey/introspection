public class Ball
{
  private int xPos;
  private int yPos; 
  private int rad;
  private int prev_rad = 1;
  public Ball(int x, int y, int r)
   {
      xPos = x;
      yPos = y;
      rad = r;
   }

  private float xspeed = random(8);  // Speed of the shape
  private float yspeed = random(8);  // Speed of the shape
  final float ORIGIONAL_xspeed = xspeed;  // Speed of the shape
  final float ORIGIONAL_yspeed = yspeed;  // Speed of the shape
  
  color c = color(55,155,55);
  
  private int xdirection = 1;  // Left or Right
  private int ydirection = 1;  // Top to Bottom
  
  private boolean overCircle = false;
  
  public int getx(){return xPos;}
  public int gety(){return yPos;}
  public int getRad(){return rad;}
  public void setRad(int r){rad = r;}
  public int getPrevRad(){return prev_rad;}
  public float getxSpeed(){return xspeed;}
  public float getySpeed(){return yspeed;}
  public int getxDirection(){return xdirection;}
  public int getyDirection(){return ydirection;}
  public void updateXpos(){xPos += ( xspeed * xdirection );}
  public void updateYpos(){yPos += ( yspeed * ydirection );}
  public void setPrevRad(int r){prev_rad = r;}
  public void stopMotion(){xspeed = 0; yspeed = 0;}
  public void go(){xspeed = ORIGIONAL_xspeed; yspeed = ORIGIONAL_yspeed;}
  public void reverseMotion(){xdirection *= -1; ydirection *= -1;}
  public color getColor(){return c;}
  public void randomColor(){c = color((int)random(255),(int)random(250),(int)random(250));}

public void updateDirection()
{
     if (xPos > width-rad || xPos < rad && xPos > 0) 
     {
       xdirection *= -1;
     }
     if (yPos > height-rad || yPos < rad && yPos > 0) 
     {
       ydirection *= -1;
     }
}

public boolean overCircle(int radius) {
  if( (dist(xPos, yPos, mouseX, mouseY) - (radius)) < 0) {
    //System.out.println("Mouse in Position" + second());
    return true;
  } else {
    //System.out.println("NOPE");
    return false;
  }
}
}
