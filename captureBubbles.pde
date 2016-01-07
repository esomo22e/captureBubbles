import processing.video.*;
Capture cam;

int numPixels;
int[] prevFrame;
int[][] movePts;
int moveAmt = 0;

int particleMin = 2;

// Previous Frame
PImage previousFrame;
// How different must a pixel be to be a "motion" pixel
float threshold = 50;

void setup() 
{
  size(640, 480);
  background (0);
  
 //noStroke();
  frameRate(30);
 // fill(100);
  smooth();
 // cam = new Capture(this, width, height, "Logitech HD Webcam C615");
 cam = new Capture(this, width, height, 30);
  cam.start();
  numPixels = width * height;
  prevFrame = new int[numPixels];
  movePts = new int[height][width];
}

void draw() 
{
  if (cam.available() == true) {
    cam.read();
  }
     
       
     graffBubbles();
     
     

    
 
}


void graffBubbles(){
  
  moveAmt = 0;
  for (int i = 0; i < numPixels; i++) 
  {
    movePts[abs(i / width)][i / height] = 0;
    color currColor = cam.pixels[i];
    color prevColor = prevFrame[i];
    // Extract the red, green, and blue components from current pixel
    int currR = (currColor >> 16) & 255; 
    int currG = (currColor >> 8) & 255;
    int currB = currColor & 255;
    // Extract red, green, and blue components from previous pixel
    int prevR = (prevColor >> 16) & 255;
    int prevG = (prevColor >> 8) & 255;
    int prevB = prevColor & 255;
    // Compute the difference of the red, green, and blue values
    int diffR = abs(currR - prevR);
    int diffG = abs(currG - prevG);
    int diffB = abs(currB - prevB);
    // Render the difference image to the screen
    color diff = color(diffR, diffG, diffB);
   // color diff = color(233,233,23);
    int isPointDiff = 0;
  if (diff > -15000000)      //-16777216
  {
    isPointDiff = 1;
    moveAmt++;
  }
    movePts[abs(i / width)][i % width] = isPointDiff;

  }
  checkBubblePoint(moveAmt);
  
  arraycopy(cam.pixels, prevFrame); 
}




void checkBubblePoint(int moveAmt)
{  
 
 for (int i = 0; i < height; i++) 
  {
    for (int j = 0; j < width; j++)
    {      
      if(i > 1 && j > 1 && movePts[i][j] == 1)
      {
        if(movePts[i - 1][j] == 1 || movePts[i][j - 1] == 1 )
        {
     
         color c = prevFrame[(i * width) + j];
         fill(c, 255);
      //  stroke(c, 255);
          int particleSize = moveAmt / 700;
          
          if(random(particleSize) > (particleSize - (1.0/ particleSize))) 
          {
        ellipse(j, i, particleMin + particleSize, particleMin + particleSize);
           

          }
        }
      }
    }
  }  
}

void mousePressed() {
  fill(0);
  rect(0, 0, width, height);
}
