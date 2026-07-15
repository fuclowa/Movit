class Game_object {
  float x, y, z, d, w, h;
  float Vx = 0, Vy = 0, Vz = 0;
  float Sx, Sy, Sz;
  int speed = 4, cp;
  boolean moveable, isSelected;
  boolean isOnGround;
  String type;
  boolean isOpen = false;
  PVector lastPos;
  PVector movePos;
  Game_object(float x, float y, float z, int w, int h, int d, boolean moveable, String type, int cp) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.Sx = x;
    this.Sy = y;
    this.Sz = z;
    this.d = d;
    this.w = w;
    this.h = h;
    this.moveable = moveable;
    isSelected = false;
    this.type = type;
    this.cp = cp;
  }
  void display() {
    pushMatrix();
    translate(x, y, z);
    if (moveable) {
      if (isSelected)fill(#009AAA);
      else fill(#FF5622);
    } else {
      fill(#FFFFFF);
    }
    if (!(cp == 0)&&!moveable) {
      fill(#E53935);
    }
    if (type == "box") {
      box(w, h, d);
    }
    if (type == "button") {
      push();
      if (moveable) {
        if (isSelected)stroke(#33C4D4, 100);
        else stroke(#FF845C, 100);
      } else {
        stroke(#E53935, 100);
      }
      strokeWeight(0);
      //emissive(50, 50, 50);
      rotateY(radians(-55));
      cylinder(w/2, h, 6);
      pop();
    }
    if (type == "goal") {
      push();
      emissive(30, 30, 30);
      rotateY(radians(-45));
      flag(w, h/4, moveable, isSelected);
      pop();
    }
    popMatrix();
    if (type == "goal") {
      pushMatrix();
      float PuB = 10000;
      for (Game_object B : objects) {
        boolean insideXZ =
          x >= B.x - B.w/2 &&
          x <= B.x + B.w/2 &&
          z >= B.z - B.d/2 &&
          z <= B.z + B.d/2;
        if (insideXZ) {
          float top = B.y - B.h/2;
          if (top >= y) {
            if (top < PuB) {
              PuB = top;
            }
          }
        }
      }
      if (!(PuB==10000)) {
        translate(x, -0.1, z);
        beginShape();
        fill(0, 100);
        float scale = max(0.3, 1.0 - abs(PuB - y) / 500.0);
        for (int i = 0; i < 360; i += 10) {
          float r = radians(i);
          vertex(cos(r) * w * scale, PuB, sin(r) * d * scale);
        }
        endShape(CLOSE);
      }
      popMatrix();
    }
  }
  void move() {
    if (isSelected) {
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
    x += Vx;
    if (collision()) {
      x -= Vx;
      Vx = 0;
    }
    y += Vy;
    if (collision()) {
      y -= Vy;
      Vy = 0;
    }
    y += 3;
    if (collision()) {
      isOnGround = true;
    } else {
      isOnGround = false;
    }
    y -= 3;
    z += Vz;
    if (collision()) {
      z -= Vz;
      Vz = 0;
    }
    Vx *= 0.9;
    Vz *= 0.9;
    Vy *= 0.9;
  }
  void Passive_Move() {
    for (Game_object B : objects) {
      if (B.type == "goal")continue;
      if (B == this)continue;
      if (
        x + w/2 >= B.x - B.w/2 &&
        x - w/2 <= B.x + B.w/2 &&

        y + h/2 + 5>= B.y - B.h/2 &&
        y - h/2 <= B.y + B.h/2 &&

        z + d/2 >= B.z - B.d/2 &&
        z - d/2 <= B.z + B.d/2
        ) {
        if (!(B.movePos == null)) {
          if (B.movePos.y < 0) {
            y += B.movePos.y;
            if (collision()) {
              if (B.moveable) {
                y -= B.movePos.y;
              } else {
                Game_object obj = findObject(0, 0, 0);
                if (obj == null) {
                  if (P_collision()) {
                    Py += B.movePos.y ;
                  }
                } else {
                  if (obj.moveable)y += B.movePos.y;
                }
              }
            }
          }
          if (!(type == "goal")) {
            x += B.movePos.x;
            if (collision()) {
              x -= B.movePos.x;
            }
            z += B.movePos.z;
            if (collision()) {
              z -= B.movePos.z;
            }
          }
        }
      }
    }
    if (
      x + w/2 >= Px - Pw/2 &&
      x - w/2 <= Px + Pw/2 &&

      y + h/2 + 5>= Py - Ph/2 &&
      y - h/2 <= Py + Ph/2 &&

      z + d/2 >= Pz - Pd/2 &&
      z - d/2 <= Pz + Pd/2
      ) {
      if (!(movePos == null)) {
        x += PmovePos.x;
        if (collision()) {
          x -= PmovePos.x;
        }
        y += PmovePos.y;
        if (collision()) {
          y -= PmovePos.y;
        }
        z += PmovePos.z;
        if (collision()) {
          z -= PmovePos.z;
        }
      }
    }
  }
  void box_open() {
    if (cp == 1) {
      if (isOpen) {
        if (Sy-h<y) {
          Vy = -2;
        } else Vy = 0;
      } else {
        if (Sy>y) {
          Vy = 2;
        } else Vy = 0;
      }
    }
    if (cp == 2) {
      if (isOpen) {
        if (Sx+w>x) {
          Vx = 4;
        } else Vx = 0;
      } else {
        if (Sx<x) {
          Vx = -4;
        } else Vx = 0;
      }
    }
    if (cp == 3) {
      if (isOpen) {
        if (Sy+h>y) {
          Vy = 2;
        } else Vy = 0;
      } else {
        if (Sy<y) {
          Vy = -2;
        } else Vy = 0;
      }
    }
    x += Vx;
    y += Vy;
    z += Vz;
  }
  boolean collision() {
    for (Game_object B : objects) {
      if (B == this) continue;
      if (
        x + w/2 >= B.x - B.w/2 &&
        x - w/2 <= B.x + B.w/2 &&

        y + h/2 >= B.y - B.h/2 &&
        y - h/2 <= B.y + B.h/2 &&

        z + d/2 >= B.z - B.d/2 &&
        z - d/2 <= B.z + B.d/2

        ||

        Px + Pw/2 >= x - w/2 &&
        Px - Pw/2 <= x + w/2 &&

        Py + Ph/2 >= y - h/2 &&
        Py - Ph/2 <= y + h/2 &&

        Pz + Pd/2 >= z - d/2 &&
        Pz - Pd/2 <= z + d/2
        ) {
        return true;
      }
    }
    return false;
  }
  boolean Bcollision() {
    for (Game_object B : objects) {
      if (B == this||(B.moveable == false&&!(cp == 0))) continue;
      if (
        x + w/2 >= B.x - B.w/2 &&
        x - w/2 <= B.x + B.w/2 &&

        y + h/2 >= B.y - B.h/2 &&
        y - h/2 <= B.y + B.h/2 &&

        z + d/2 >= B.z - B.d/2 &&
        z - d/2 <= B.z + B.d/2
        ) {
        return true;
      }
    }
    return false;
  }
  boolean Pcollision() {
    if (
      x + w/2 >= Px - Pw/2 &&
      x - w/2 <= Px + Pw/2 &&

      y + h/2 >= Py - Ph/2 &&
      y - h/2 <= Py + Ph/2 &&

      z + d/2 >= Pz - Pd/2 &&
      z - d/2 <= Pz + Pd/2
      ) {
      return true;
    }
    return false;
  }
  Game_object findObject(float vx, float vy, float vz) {
    for (Game_object B : objects) {
      if (B == this) continue;
      if (
        x + w/2 +vx>= B.x - B.w/2 &&
        x - w/2 +vx<= B.x + B.w/2 &&

        y + h/2 +vy>= B.y - B.h/2 &&
        y - h/2 +vy<= B.y + B.h/2 &&

        z + d/2 +vz>= B.z - B.d/2 &&
        z - d/2 +vz<= B.z + B.d/2
        ) {
        return B;
      }
    }
    return null;
  }
  void goal() {
    if (type == "goal") {
      if (
        Px + Pw/2 >= x - w/2 -2 &&
        Px - Pw/2 <= x + w/2 +2&&

        Py + Ph/2 >= y - h/2 -2&&
        Py - Ph/2 <= y + h/2 +2&&

        Pz + Pd/2 >= z - d/2 -2&&
        Pz - Pd/2 <= z + d/2 +2

        &&isPlaying == true
        ) {
        isPlaying = false;
        if (HintOpen)HintMoving = true;
      }
    }
  }
  void button() {
    if (type == "button") {
      y -= 5;
      if (
        Px + Pw/2 >= x - w/2 &&
        Px - Pw/2 <= x + w/2 &&

        Py + Ph/2 >= y - h/2 &&
        Py - Ph/2 <= y + h/2 &&

        Pz + Pd/2 >= z - d/2 &&
        Pz - Pd/2 <= z + d/2

        || Bcollision()

        ) {
        for (int i = 0; i < objects.size(); i++) {
          Game_object B = objects.get(i);
          if (B == this) continue;
          if (cp == B.cp) {
            B.isOpen = true;
          }
        }
      } else {
        for (int i = 0; i < objects.size(); i++) {
          Game_object B = objects.get(i);
          if (B == this) continue;
          if (cp == B.cp) {
            B.isOpen = false;
          }
        }
      }
      y +=5;
    }
  }
}

void processBox() {
  for (int i = 0; i < objects.size(); i++) {
    Game_object B = objects.get(i);
    B.lastPos = new PVector(B.x, B.y, B.z);
    B.goal();
    B.button();
    if (!(B.cp==0)&&B.type == "box")B.box_open();
    if (B.moveable||B.type == "goal") {
      B.move();
      B.Passive_Move();
    }
    if (B.isSelected)println(B.movePos);
    if ((i == bIndex)) {
      isControlP = false;
    } else {
      B.isSelected = false;
    }
    if (B.y > 500) {
      addBoxes();
    }
    B.movePos = PVector.sub(new PVector(B.x, B.y, B.z), B.lastPos);
  }
}

void processBox2() {
  for (Game_object B : objects) {
    B.display();
  }
}

void addBoxes() {
  objects.clear();
  switch(stage) {
  case 1:
    objects.add(new Game_object(0, 100, 0, 900, 200, 900, false, "box", 0));
    objects.add(new Game_object(300, -200, -300, 70, 400, 70, false, "goal", 0));
    setP();
    break;
  case 2:
    objects.add(new Game_object(0, 100, 0, 900, 200, 900, false, "box", 0));
    objects.add(new Game_object(-300, -100, -300, 300, 300, 300, false, "box", 0));
    objects.add(new Game_object(300, -150, -300, 150, 75, 150, true, "box", 0));
    objects.add(new Game_object(300, -150, 300, 150, 75, 150, true, "box", 0));
    objects.add(new Game_object(-300, -450, -300, 70, 400, 70, false, "goal", 0));
    setP();
    break;
  case 3:
    objects.add(new Game_object(0, 100, 0, 900, 200, 900, false, "box", 0));
    objects.add(new Game_object(300, -150, -300, 200, 200, 200, true, "box", 0));
    objects.add(new Game_object(300, -700, -300, 70, 400, 70, false, "goal", 0));
    setP();
    break;
  case 4:
    objects.add(new Game_object(0, 100, 0, 900, 200, 900, false, "box", 0));
    objects.add(new Game_object(225, -100, 0, 450, 200, 900, false, "box", 0));
    objects.add(new Game_object(300, -700, -300, 70, 400, 70, true, "goal", 0));
    Sx = -200;
    setP();
    break;
  case 5:
    objects.add(new Game_object(-300, 100, 0, 400, 200, 900, false, "box", 0));
    objects.add(new Game_object(300, 100, 0, 400, 200, 900, false, "box", 0));
    objects.add(new Game_object(-300, -100, -320, 75, 75, 75, true, "box", 0));
    objects.add(new Game_object(-300, -10, 320, 200, 20, 200, false, "button", 2));
    objects.add(new Game_object(-200, -25, 0, 200, 50, 200, false, "box", 2));
    objects.add(new Game_object(350, -200, 0, 70, 400, 70, false, "goal", 0));
    Sx = -400;
    setP();
    break;
  case 6:
    objects.add(new Game_object(0, 100, 0, 800, 200, 800, false, "box", 0));
    objects.add(new Game_object(250, -100, -325, 300, 200, 150, false, "box", 0));
    objects.add(new Game_object(325, -100, -175, 150, 200, 150, false, "box", 0));
    objects.add(new Game_object(175, 99.5, -175, 150, 200, 150, false, "box", 1));
    objects.add(new Game_object(325, -400, -325, 70, 400, 70, false, "goal", 0));
    objects.add(new Game_object(-275, -11, 275, 200, 20, 200, true, "button", 1));
    Sx = 0;
    setP();
    break;
  case 7:
    objects.add(new Game_object(300, -125, -300, 200, 200, 200, false, "box", 3));
    objects.add(new Game_object(300, -275, -300, 200, 200, 200, false, "box", 3));
    objects.add(new Game_object(100, -125, -100, 200, 200, 200, false, "box", 3));
    objects.add(new Game_object(300, -125, 100, 200, 200, 200, false, "box", 3));
    objects.add(new Game_object(300, -100, -100, 50, 50, 50, true, "box", 0));
    objects.add(new Game_object(300, -200, -100, 50, 50, 50, true, "box", 0));
    objects.add(new Game_object(-300, -10, 300, 200, 20, 200, false, "button", 3));
    objects.add(new Game_object(0, 100, 0, 800, 200, 800, false, "box", 0));
    objects.add(new Game_object(300, -500, -300, 70, 400, 70, false, "goal", 0));
    Sx = -200;
    Sy = -200;
    Sz = 0;
    setP();
    break;
  case 8:
    objects.add(new Game_object(0, 100, 0, 800, 200, 800, false, "box", 0));
    objects.add(new Game_object(275, -500, -275, 70, 400, 70, false, "goal", 0));
    objects.add(new Game_object(0, -220, 250, 100, 50, 100, true, "box", 0));
    objects.add(new Game_object(-275, -200, -275, 200, 20, 200, false, "button", 1));
    objects.add(new Game_object(325, 99.5, -75, 150, 200, 150, false, "box", 1));
    objects.add(new Game_object(0, -95, -275, 800, 190, 250, false, "box", 0));
    setP();
    Sx = 150;
    Sy = -200;
    Sz = -150;
    break;
  case 9:
    objects.add(new Game_object(0, 100, 0, 600, 200, 600, false, "box", 0));
    objects.add(new Game_object(0, -100, -150, 600, 200, 300, false, "box", 0));
    objects.add(new Game_object(-150, -300, -150, 300, 200, 300, false, "box", 0));
    objects.add(new Game_object(0, -200, -200, 70, 400, 70, false, "goal", 0));
    objects.add(new Game_object(-150, -100, 150, 100, 100, 100, true, "box", 0));
    objects.add(new Game_object(25, -99.5, 149.5, 50, 200, 300, false, "box", 3));
    objects.add(new Game_object(150, -10, 150, 200, 20, 200, false, "button", 3));
    objects.add(new Game_object(-150, -700, -150, 70, 400, 70, false, "goal", 0));
    Sx = 150;
    Sz = -150;
    Sy = -300;
    setP();
    break;
  case 10:
    objects.add(new Game_object(-350, 100, 0, 200, 200, 900, false, "box", 0));
    objects.add(new Game_object(350, 100, 0, 200, 200, 900, false, "box", 0));
    objects.add(new Game_object(900, 100, 0, 200, 200, 200, false, "box", 0));
    objects.add(new Game_object(0, 200, 0, 200, 200, 200, false, "box", 0));
    objects.add(new Game_object(-350, -11, 0, 200, 20, 200, true, "button", 2));
    objects.add(new Game_object(350, -25, 0, 400, 50, 200, false, "box", 2));
    objects.add(new Game_object(350, -201, -300, 70, 400, 70, true, "goal", 0));
    Sx = 900;
    Sz = 0;
    setP();
  case 11:
    if (stage == 11) {
      objects.add(new Game_object(0, 100, 0, 600, 200, 600, false, "box", 0));
      objects.add(new Game_object(200, -200, -200, 70, 400, 70, false, "goal", 0));
      Sx = 0;
      Sz = 0;
      setP();
    }
    break;
  default:
    break;
  }
}

void flag(float w, float h, boolean moveable, boolean isSelected) {

  float poleH = h * 2.0;
  float poleW = 4;
  float thick = 4;

  pushMatrix();
  translate(0, poleH/2, 0);
  fill(140);
  box(poleW, poleH, poleW);
  popMatrix();

  if (moveable) {
    if (isSelected) {
      fill(#009AAA);
    } else {
      fill(#FF5622);
    }
  } else {
    fill(#FFFFFF);
  }

  float y1 = h * 0.2;
  float y2 = h * 0.8;
  float tipY = h * 0.5;

  beginShape(TRIANGLES);
  vertex(0, y1, thick/2);
  vertex(w, tipY, thick/2);
  vertex(0, y2, thick/2);
  endShape();

  beginShape(TRIANGLES);
  vertex(0, y1, -thick/2);
  vertex(0, y2, -thick/2);
  vertex(w, tipY, -thick/2);
  endShape();

  beginShape(QUADS);
  vertex(0, y1, thick/2);
  vertex(0, y1, -thick/2);
  vertex(w, tipY, -thick/2);
  vertex(w, tipY, thick/2);
  endShape();

  beginShape(QUADS);
  vertex(w, tipY, thick/2);
  vertex(w, tipY, -thick/2);
  vertex(0, y2, -thick/2);
  vertex(0, y2, thick/2);
  endShape();

  beginShape(QUADS);
  vertex(0, y2, thick/2);
  vertex(0, y2, -thick/2);
  vertex(0, y1, -thick/2);
  vertex(0, y1, thick/2);
  endShape();
}

void cylinder(float r, float h, int detail) {
  float halfH = h / 2.0;

  beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI * i / detail;
    float x = cos(angle) * r;
    float z = sin(angle) * r;

    normal(cos(angle), 0, sin(angle));
    vertex(x, -halfH, z);
    vertex(x, halfH, z);
  }
  endShape();

  beginShape(TRIANGLE_FAN);
  normal(0, -1, 0);
  vertex(0, halfH, 0);
  for (int i = detail; i >= 0; i--) {
    float angle = TWO_PI * i / detail;
    vertex(cos(angle) * r, halfH, sin(angle) * r);
  }
  endShape();

  beginShape(TRIANGLE_FAN);
  normal(0, 1, 0);
  vertex(0, -halfH, 0);
  for (int i = detail; i >= 0; i--) {
    float angle = TWO_PI * i / detail;
    vertex(cos(angle) * r, -halfH, sin(angle) * r);
  }
  endShape();
}
