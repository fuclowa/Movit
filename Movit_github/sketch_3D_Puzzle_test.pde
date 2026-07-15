import ddf.minim.*;
import com.jogamp.newt.opengl.GLWindow;
Minim minim;
AudioSample clickSound;
AudioPlayer BGM;
{
  System.setProperty("sun.java2d.uiScale", "1.0");
}
ArrayList<Game_object> objects ;
ArrayList<Text> texts ;
float Px = 0, Py = -200, Pz = 0;
float Sx = 0, Sy = -200, Sz = 0;
float cameraX = -2000, cameraY = -1675, cameraZ = 2000;
float Vx = 0, Vy = 0, Vz = 0;
float centerX, centerY = 0, centerZ = 0;
float angle = -45, angleH = 30;
int speed = 4;
int Pw = 60, Ph = 60, Pd = 60;
boolean isOnGround;
boolean isControlP = true;
float Pshadow;
boolean isTitle = true;
int stage = 1;
boolean isPlaying = true;
PFont font;
PImage title;
PImage VolumeMute;
PImage VolumeSmall;
PImage VolumeBig;
PImage ControlPanel;
PImage Hint;
PImage HintLight;
void settings() {
  size(1920, 1080, P3D);
  //size(950, 540, P3D);
  //fullScreen(P3D);
  smooth(4);
}
void setup() {
  imageMode(CENTER);
  minim = new Minim(this);
  font = createFont("UO.ttf", 256);
  title = loadImage("Movit.png");
  VolumeMute = loadImage("VolumeMute (3).png");
  VolumeSmall = loadImage("VolumeSmall (3).png");
  VolumeBig = loadImage("VolumeBig (3).png");
  ControlPanel = loadImage("Controls2.png");
  HintLight = loadImage("Hint (3).png");
  HintLight.resize(248/4, 472/4);
  Hint = loadImage("Hint (2).png");
  Hint.resize(248/4, 472/4);
  VolumeSmall.resize(190/4, 281/4);
  VolumeBig.resize(341/4, 281/4);
  VolumeMute.resize(341/4, 360/4);
  ControlPanel.resize(int(694/1.5), int(800/1.5));
  clickSound = minim.loadSample("click.mp3");
  BGM = minim.loadFile("tim_kulig_free_music-studying-on-the-weekend-181515.mp3");
  textFont(font);
  noStroke();
  strokeWeight(5);
  textSize(32);
  objects = new ArrayList<Game_object>();
  texts = new ArrayList<Text>();
  addBoxes();
  addTexts();
  perspective(radians(60), float(width)/float(height), 0.1, 100000);
  BGM.loop();
}
void draw() {
  if (mute)BGM.setGain(-80);
  else BGM.setGain(gain);
  if (isTitle)title();
  else process();
  pushStyle();
  pushMatrix();
  textAlign(CENTER, CENTER);
  textSize(300);
  translate(0, -1875, 0);
  rotateY(radians(-45));
  fill(0);
  println(stage2);
  displayClear();
  popMatrix();
  popStyle();
  hint(DISABLE_DEPTH_TEST);
  camera();
  noLights();
  //debug();
  drawGUI();
  hint(ENABLE_DEPTH_TEST);
}
void debug() {
  fill(0);
  text("Angle"+" "+angle+",  "+angleH, 100, 100);
  text("Pos"+" "+int(Px)+",  "+Py+",  "+int(Pz), 100, 150);
  text("Velocity"+"  "+Vx+",  "+Vy+",  "+Vz, 100, 200);
  text("Key(AWSD)"+" "+str(isA)+",  "+str(isW)+",  "+str(isS)+",  "+str(isD), 100, 250);
  //text("Moveable"+" "+str(P_moveableX())+" "+str(P_moveableY())+" "+str(P_moveableZ()), 100, 300);
  text("collition"+" "+str(P_collision()), 100, 300);
  text("Pshadow"+" "+Pshadow, 100, 350);
  text(worldX+","+worldZ, 100, 400);
  text("isControlP"+" "+str(isControlP), 100, 450);
  text("CameraPos"+" "+int(cameraX)+",  "+cameraY+",  "+int(cameraZ), 100, 500);
  text("stage,pStage"+" "+stage+" "+pStage, 100, 550);
  text("isPlaying"+" "+str(isPlaying), 100, 600);
  text("CameraVy"+" "+cameraVy, 100, 650);
  //ellipse(width/2, height/2+80, 10, 10);
}
void displayClear() {
  if (!isPlaying) {
    switch(stage2) {
    case 1:
      text("Clear", 0, 0, 0);
      break;
    case 2:
      text("Clear", 0, 0, 0);
      break;
    case 3:
      text("Clear", 0, 0, 0);
      break;
    case 4:
      text("Clear", 0, 0, 0);
      break;
    case 5:
      text("Clear", 0, 0, 0);
      break;
    case 6:
      text("Clear", 0, 0, 0);
      break;
    case 7:
      text("Clear", 0, 0, 0);
      break;
    case 12:
      text("Thank you for\nplaying!  : )", 0, 0, 0);
      break;
    default:
      text("Clear", 0, 0, 0);
      break;
    }
  }
}
void title() {
  background(#F5F5F5);
  hint(DISABLE_DEPTH_TEST);
  camera();
  fill(0);
  //text("Movit", width/2, height/2);
  image(title, width/2, height/2-100, 1050, 450);
  pushStyle();
  fill(100, 100);
  textAlign(CENTER, CENTER);
  textSize(100);
  //text("Click to start", width/2, height/2 + 200);
  text("クリックして始める", width/2, height/2 + 200);
  popStyle();
  hint(ENABLE_DEPTH_TEST);
}
int pStage = 1;
void process() {
  background(#EFEFEF);
  ambientLight(160, 160, 160);
  directionalLight(255, 255, 255, 1, 1, 0);
  //directionalLight(255, 255, 255, 0, 1, 0);
  //pointLight(255, 255, 255, cameraX,cameraY,cameraZ);
  ortho();
  if (!(pStage == stage)) {
    addBoxes();
    addTexts();
  }
  pStage = stage;
  cameraSet();
  processBox();
  PlastPos = new PVector(Px, Py, Pz);
  P_Move();
  P_Passive_Move();
  PmovePos = PVector.sub(new PVector(Px, Py, Pz), PlastPos);
  changeStage();
  if (Py > 500) {
    addBoxes();
  }
  processBox2();
  processText();
  P_Display();
}

void displayTitleDesign() {
  pushMatrix();
  pushStyle();
  noLights();
  translate(300, -350, 300);
  rotateY(radians(-90));
  image(title, 0, 0, 1657/2, 689/2);
  popMatrix();
  popStyle();
}
boolean isW = false, isS = false, isA = false, isD = false, isSPACE = false, isSHIFT = false;
void keyPressed() {
  if (key == 'w')
    isW = true;
  if (key == 's') {
    isS = true;
  }
  if (key == 'd')
    isD = true;
  if (key == 'a') {
    isA = true;
  }
  if (keyCode == SHIFT) {
    isSHIFT = true;
  }
  if (key == ' ') {
    isSPACE = true;
  }
  //if (keyCode == RIGHT) {
  //  stage += 1;
  //  stage2 += 1;
  //}
  //if (keyCode == LEFT) {
  //  stage -= 1;
  //  stage2 -=1;
  //}
  if (key == 'r') {
    addBoxes();
  }
}
void keyReleased() {
  if (key == 'w')
    isW = false;
  if (key == 's') {
    isS = false;
  }
  if (key == 'd')
    isD = false;
  if (key == 'a') {
    isA = false;
  }
  if (keyCode == SHIFT) {
    isSHIFT = false;
  }
  if (key == ' ') {
    isSPACE = false;
  }
}
boolean isClick = false;
void mousePressed() {
  clickSound.trigger();
  if (isTitle) {
    isTitle = false;
  } else pointObject();
  isClick = true;
}
void mouseReleased() {
  isClick = false;
}
