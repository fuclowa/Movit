float volX =1800, volY = 482;
float gain = 0;
boolean mute = false;
int muteW;
float cpX = -110, cpY = 280;
float cpVx = 40;
boolean cpMoving = false;
boolean cpOpen = false;
float HintX = 1760;
float HintY = -84;
boolean HintOpen = false;
boolean HintOpen2 = false;
boolean HintMoving = false;
float HintVy = 20;
void drawGUI() {

  if (dist(volX, volY, mouseX, mouseY) < 100 && isClick && mouseY >= 402 && mouseY <= 628) {
    volY = mouseY;
  }

  if (dist(1800, 335, mouseX, mouseY) < 30 && isClick && muteW + 500 < millis()) {
    if (mute)mute = false;
    else mute = true;
    muteW = millis();
  }

  gain = map(volY, 628, 402, -40, 40);
  pushStyle();
  strokeCap(ROUND);
  stroke(#DCDCE0);
  strokeWeight(8);
  line(1800, 390, 1800, volY - 12);
  stroke(#AEAEB2);
  line(1800, volY + 12, 1800, 640);
  noStroke();
  fill(#DCDCE0);
  circle(1800, 390, 8);
  fill(#AEAEB2);
  circle(1800, 640, 8);
  noFill();
  stroke(#AEAEB2);
  strokeWeight(8);
  circle(1800, volY, 32);
  popStyle();

  if (mouseX < 100 && isClick && cpMoving == false && cpOpen == false) {
    cpMoving = true;
  }
  if (mouseX < cpX + 200 && cpMoving == false && cpOpen == true && isClick) {
    cpMoving = true;
  }
  if (cpMoving&&cpOpen == false) {
    cpVx -= 2;
    cpX += cpVx;
    if (cpVx <= 0) {
      cpOpen = true;
      cpMoving = false;
      cpVx = 40;
    }
  }
  if (cpMoving&&cpOpen == true) {
    cpVx -= 2;
    cpX -= cpVx;
    if (cpVx <= 0) {
      cpOpen = false;
      cpMoving = false;
      cpVx = 40;
    }
  }

  image(VolumeSmall, 1800, 690);
  if (mute) image(VolumeMute, 1800, 334);
  else image(VolumeBig, 1800, 335);

  image(ControlPanel, cpX, cpY);
  pushMatrix();
  pushStyle();
  strokeWeight(10);
  stroke(#AEAEB2);
  line(cpX + 120, 50, cpX + 120, 510);
  noStroke();
  fill(#AEAEB2);
  circle(cpX + 120, 50, 10);
  circle(cpX + 120, 510, 10);
  textSize(80);
  textAlign(CENTER, CENTER);
  fill(#AEAEB2);
  translate(cpX + 165, cpY);
  rotate(radians(90));
  //text("C o n t r o l s", 0, 0);
  text("操　作　方　法", 0, 0);
  popMatrix();
  popStyle();

  if (dist(1800, 100, mouseX, mouseY) < 50 && isClick && HintMoving == false) {
    HintMoving = true;
  }
  if (HintMoving && !(HintOpen)) {
    HintOpen2 = true;
    HintVy -= 1;
    HintY += HintVy;
    if (HintVy <= 0) {
      HintOpen = true;
      HintMoving = false;
      HintVy = 20;
    }
  }
  if (HintMoving && HintOpen) {
    HintOpen2 = false;
    HintVy -= 1;
    HintY -= HintVy;
    if (HintVy <= 0) {
      HintOpen = false;
      HintMoving = false;
      HintVy = 20;
    }
  }
  pushStyle();
  textAlign(RIGHT, CENTER);
  textSize(80);
  fill(#AEAEB2);
  fill(#FFD23F);
  switch(stage) {
  case 1:
    text("ここで！？！？", HintX, HintY);
    break;
  case 2:
    text("つんでつんで", HintX, HintY);
    break;
  case 3:
    text("重力を感じる", HintX, HintY);
    break;
  case 4:
    text("箱しか動かせな\nいとは限らない", HintX, HintY);
    break;
  case 5:
    text("スイッチが押せるの\nはプレイヤーだけ？", HintX, HintY);
    break;
  case 6:
    text("動かせるものの色は？", HintX, HintY);
    break;
  case 7:
    text("スイッチを押し\nつつ上るには？", HintX, HintY);
    break;
  case 8:
    text("ただの足場ブロック？", HintX, HintY);
    break;
  case 9:
    text("スイッチはなんでも押せる", HintX, HintY);
    break;
  default:
    text("ここで！？！？", HintX, HintY);
    break;
  }
  //stroke(#FFD23F);
  //noFill();
  //circle(1800, 100, 200);
  if (HintOpen2)image(HintLight, 1800, 100);
  else image(Hint, 1800, 100);
  popStyle();
}
