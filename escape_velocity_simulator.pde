float G = 6.67*(pow(10, -11));
float earthMass = 5.972*pow(10, 24);
float earthRadius = 6371000;
float rocketAccel = 0;
float rocketVel = 10000;
float rocketPos = 0;
float gravForce = 0; 
float mappedRocketPos=0;

boolean play, hoveredPlayPause, hoveredReset, hoveredSlider;
boolean isReset = true;

float sliderVal = map(rocketVel, 0, 11200, 0, 150);

// Constants for gradient function
int Y_AXIS = 1;
int X_AXIS = 2;

PImage orbit, rocket, prohibited; 



PrintWriter pos, accel, vel;



void setup() {
  size(500, 1000);
  orbit = loadImage("orbit logo.png");
  orbit.resize(100, 50);
  rocket = loadImage("orbit_rocket.png");
  rocket.resize(50, 50);



  // Used to write data to a file
  //pos = createWriter("positions.txt");
  //accel = createWriter("acceleration.txt");
  //vel = createWriter("velocity.txt");
}

void draw() {
  background(0);

  if (play) simulate();
  
  displayRocketAndScene();

  displaySlider();

  displayPlayPauseButton();
  displayResetButton();
  

  if (rocketPos<=0 && rocketVel<0) {
    play = false;
    isReset = true;
    rocketPos = 0;
    rocketAccel = 0;
    rocketVel = int(map(sliderVal, 0, 150, 0, 11200));
  }
}

void displayRocketAndScene() {

  setGradient(0, height/4, width, height, color(0), color(#00ECFF), Y_AXIS);

  image(orbit, 0, height/4-50);

  fill(255);
  text("36000 km", 0, height/4+20);



  mappedRocketPos = height-50-map(rocketPos, 0, 36000000, 0, height*.75);

  stroke(0);
  pushMatrix();
  if (rocketVel>0 || isReset) {
    translate(width/2, mappedRocketPos-30);
    rotate(radians(45));
  } else {
    translate(width/2, mappedRocketPos+30);
    rotate(radians(-135));
  }

  image(rocket, 0, 0);
  popMatrix();

  textSize(15);
  text(rocketPos/1000 + " km", width/2+40, mappedRocketPos);

  stroke(255);
  line(0, height/4, width, height/4);
}


void simulate() {
  gravForce = -(G * earthMass) / (pow(earthRadius+rocketPos, 2));
  rocketAccel += gravForce;
  rocketVel += rocketAccel;
  rocketPos += rocketVel;
  rocketAccel *= 0;
}

void displaySlider() {
  hoveredSlider = mouseX>=10 && mouseX<=160
    && mouseY>height-30 && mouseY<height-10;
  noFill();
  stroke(color(#00ECFF));
  rect(10, height-30, 150, 20);

  fill(255);
  rect(10, height-30, sliderVal, 20);

  if (hoveredSlider) {
     if(isReset) cursor(HAND);
     else cursor(prohibited);
  } else {
    if (!hoveredPlayPause &&
      !hoveredReset) cursor(ARROW);
  }

  if (mousePressed && hoveredSlider && isReset) {
    sliderVal = mouseX-10;
    rocketVel = int(map(sliderVal, 0, 150, 0, 11200));
  }  

  textSize(13);
  text("Initial Velocity: " + int(map(sliderVal, 0, 150, 0, 11200)) + " m/s", 10, height-35);
}


void displayPlayPauseButton() {
  hoveredPlayPause = (mouseX>=10 && mouseX<=85 &&
    mouseY>=height-130 && mouseY<=height-100);

  if (hoveredPlayPause) {
    cursor(HAND);
    fill(#24BAC4);
    stroke(#24BAC4);
  } else {
    if (!hoveredReset
      && !hoveredSlider)cursor(ARROW);
    fill(#00ECFF);
    stroke(#00ECFF);
  }

  if (mousePressed && hoveredPlayPause) {
    fill(#21969D);
    stroke(#21969D);
  }



  rect(10, height-130, 75, 30);
  fill(255);
  textSize(17);
  textAlign(CENTER, CENTER);
  if (!play) text("Play", 46, height-118);
  else text("Pause", 48, height-118);
  textSize(15);
  textAlign(LEFT);
}


void displayResetButton() {
  hoveredReset = (mouseX>=10 && mouseX<=85 &&
    mouseY>=height-90 && mouseY<=height-60);

  if (hoveredReset) {
    cursor(HAND);
    fill(#24BAC4);
    stroke(#24BAC4);
  } else {
    if (!hoveredPlayPause
      && !hoveredSlider) cursor(ARROW);
    fill(#00ECFF);
    stroke(#00ECFF);
  }

  if (mousePressed && hoveredReset) {
    fill(#21969D);
    stroke(#21969D);
  }

  rect(10, height-90, 75, 30);
  textSize(17);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Reset", 48, height-78);
  textSize(15);
  textAlign(LEFT);
}


void mouseReleased() {
  if (hoveredPlayPause) {
    play = !play;
    isReset = false;
  } 
  if (hoveredReset) {
    play = false;
    isReset = true;
    rocketPos = 0;
    rocketAccel = 0;
    rocketVel = int(map(sliderVal, 0, 150, 0, 11200));
  }
}


void writeDataToFiles() {
  if (millis()*1000>23) {
    pos.flush(); // Writes the remaining data to the file
    pos.close(); // Finishes the file
    vel.flush(); // Writes the remaining data to the file
    vel.close(); // Finishes the file
    accel.flush(); // Writes the remaining data to the file
    accel.close(); // Finishes the file
    exit(); // Stops the program
  }
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}