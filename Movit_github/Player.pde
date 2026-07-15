void cameraSet() {
  float centerX = cameraX + cos(radians(angle)) * cos(radians(angleH)) * 1;
  float centerZ = cameraZ + sin(radians(angle)) * cos(radians(angleH)) * 1;
  float centerY = cameraY + sin(radians(angleH)) * 1;
  camera(cameraX, cameraY, cameraZ, centerX, centerY, centerZ, 0, 1, 0);
}
int changeF;
int cameraVy = -45;
int stage2 = 1;
void changeStage() {
  if (isPlaying) {
    changeF = 1;
    cameraVy = -60;
  }
  if (isPlaying == false) {
    if (changeF == 1) {
      stage2 += 1;
    }
    cameraVy += 1;
    cameraY += cameraVy;
    changeF += 1;
    if (changeF == 60) {
      if (stage2 == 12) {
        noLoop();
      }
      stage += 1;
      delay(700);
    }
    if (changeF > 119) {
      isPlaying = true;
    }
  }
}
PVector PlastPos;
PVector PmovePos;
void P_Move() {
  if (isControlP&&isPlaying) {
    if (isW) {
      Vx = cos(radians(angle)) * speed;
      Vz = sin(radians(angle)) * speed;
    }
    if (isS) {
      Vx = -cos(radians(angle)) * speed;
      Vz = -sin(radians(angle)) * speed;
    }
    if (isD) {
      Vx = cos(radians(angle)+HALF_PI) * speed;
      Vz = sin(radians(angle)+HALF_PI) * speed;
    }
    if (isA) {
      Vx = cos(radians(angle)-HALF_PI) * speed;
      Vz = sin(radians(angle)-HALF_PI) * speed;
    }
    if (isW && isD) {
      Vx = cos(radians(angle)+QUARTER_PI) * speed;
      Vz = sin(radians(angle)+QUARTER_PI) * speed;
    }
    if (isW && isA) {
      Vx = cos(radians(angle)-QUARTER_PI) * speed;
      Vz = sin(radians(angle)-QUARTER_PI) * speed;
    }
    if (isS && isD) {
      Vx = -cos(radians(angle)-QUARTER_PI) * speed;
      Vz = -sin(radians(angle)-QUARTER_PI) * speed;
    }
    if (isS && isA) {
      Vx = -cos(radians(angle)+QUARTER_PI) * speed;
      Vz = -sin(radians(angle)+QUARTER_PI) * speed;
    }
    if (isSPACE&&isOnGround) {
      Vy -= 30;
    }
  }
  Vy += 1.5;
  Px += Vx;
  if (P_collision()) {
    Px -= Vx;
    Vx = 0;
  }
  Py += Vy;
  if (P_collision()) {
    Py -= Vy;
    Vy = 0;
  }
  Py += 3;
  if (P_collision()) {
    isOnGround = true;
  } else {
    isOnGround = false;
  }
  Py -= 3;
  Pz += Vz;
  if (P_collision()) {
    Pz -= Vz;
    Vz = 0;
  }
  Vx *= 0.9;
  Vz *= 0.9;
  Vy *= 0.9;
}
void P_Passive_Move() {
  for (Game_object B : objects) {
    if (B.type == "goal")continue;
    if (
      Px + Pw/2 >= B.x - B.w/2 &&
      Px - Pw/2 <= B.x + B.w/2 &&

      Py + Ph/2 + 5>= B.y - B.h/2 &&
      Py - Ph/2 <= B.y + B.h/2 &&

      Pz + Pd/2 >= B.z - B.d/2 &&
      Pz - Pd/2 <= B.z + B.d/2
      ) {
      if (!(B.movePos == null)) {
        Px += B.movePos.x;
        if (P_collision()) {
          Px -= B.movePos.x;
        }
        Py += B.movePos.y;
        if (P_collision()) {
          Py -= B.movePos.y;
        }
        Pz += B.movePos.z;
        if (P_collision()) {
          Pz -= B.movePos.z;
        }
      }
    }
  }
}
void P_Display() {
  pushMatrix();
  translate(Px, Py, Pz);
  fill(#FFD23F);
  box(Pw, Ph, Pd);
  popMatrix();
  pushMatrix();
  float PuB = 10000;
  for (Game_object B : objects) {
    boolean insideXZ =
      Px >= B.x - B.w/2 &&
      Px <= B.x + B.w/2 &&
      Pz >= B.z - B.d/2 &&
      Pz <= B.z + B.d/2;
    if (insideXZ) {
      float top = B.y - B.h/2;
      if (top >= Py) {
        if (top < PuB) {
          PuB = top;
        }
      }
    }
  }
  if (!(PuB==10000)) {
    translate(Px, -0.1, Pz);
    beginShape();
    fill(0, 100);
    float scale = max(0.3, 1.0 - abs(PuB - Py) / 500.0);
    for (int i = 0; i < 360; i += 10) {
      float r = radians(i);
      vertex(cos(r) * Pw * scale, PuB, sin(r) * Pd * scale);
    }
    endShape(CLOSE);
  }
  popMatrix();
}

boolean P_collision() {
  for (Game_object B : objects) {
    if (B.type == "goal")continue;
    if (
      Px + Pw/2 >= B.x - B.w/2 &&
      Px - Pw/2 <= B.x + B.w/2 &&

      Py + Ph/2 >= B.y - B.h/2 &&
      Py - Ph/2 <= B.y + B.h/2 &&

      Pz + Pd/2 >= B.z - B.d/2 &&
      Pz - Pd/2 <= B.z + B.d/2
      ) {
      return true;
    }
  }
  return false;
}

float worldX;
float worldZ;
int bIndex = -1;
boolean isHit = false;
void pointObject() {
  float sx = mouseX - width/2;
  float sy = mouseY - height/2;
  worldX = 0.707107*sx - 1.414214*sy + 50;
  worldZ = 0.707107*sx + 1.414214*sy - 50;
  float SworldX = worldX - 707;
  float SworldZ = worldZ + 707;
  float SworldY = -577;
  int count = 0;
  PVector pointPos = new PVector(SworldX, SworldY, SworldZ);
  PVector direction = new PVector(0.6124, 0.5000, -0.6124);
  while (!isHit) {
    for (int i = 0; i < objects.size(); i++) {
      Game_object B = objects.get(i);
      if (
        pointPos.x >= B.x - B.w/2 &&
        pointPos.x <= B.x + B.w/2 &&

        pointPos.y >= B.y - B.h/2 &&
        pointPos.y <= B.y + B.h/2 &&

        pointPos.z >= B.z - B.d/2 &&
        pointPos.z <= B.z + B.d/2

        && B.moveable
        ) {
        isHit = true;
        B.isSelected = true;
        bIndex = i;
      }
    }
    count ++;
    if (count > 10000) {
      bIndex = -1;
      for (int i = 0; i < objects.size(); i++) {
        Game_object B = objects.get(i);
        B.isSelected = false;
      }
      isControlP = true;
      break;
    }
    pointPos.add(direction);
  }
  isHit = false;
}

void setP() {
  Px = Sx;
  Py = Sy;
  Pz = Sz;
}
