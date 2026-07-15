class Text {
  float x, y, z;
  float angle;
  String text;
  int textSize;
  Text(float x, float y, float z, float angle, String text, int textSize) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.angle = angle;
    this.text = text;
    this.textSize = textSize;
  }
  void display() {
    pushMatrix();
    textAlign(CENTER, CENTER);
    translate(x, y, z);
    rotateY(radians(angle));
    fill(0);
    textSize(textSize);
    text(text, 0, 0, 0);
    popMatrix();
  }
}
void processText() {
  for (int i = 0; i < texts.size(); i++) {
    Text B = texts.get(i);
    B.display();
  }
}

void addTexts() {
  texts.clear();
  switch(stage) {
  case 1:
    texts.add(new Text(500, -200, 0, -90, "旗に触れるとゴールができます。", 75));
    break;
  case 2:
    texts.add(new Text(500, -200, 0, -90, "オレンジ色の物体は選択して、\n動かすことができます。\n(何もないところをクリックでプレイヤー操作に戻る)", 75));
    break;
  case 3:
    texts.add(new Text(400, -100, -500, 0, "おめでとう！", 30));
    break;
  case 4:
    texts.add(new Text(500, -200, 0, -90, "うわあ、これは難しい。", 75));
    break;
  case 5:
    texts.add(new Text(500, -200, 0, -90, "六角形の物体はスイッチです。\n乗ってみよう。", 75));
    break;
  case 7:
    texts.add(new Text(-100, -200, -500, 0, "ゴールが見えない！", 75));
    break;
  case 9:
    texts.add(new Text(500, -250, 0, -90, "ややこしい", 75));
    break;
  case 10:
    texts.add(new Text(-100, -200, -500, 0, "さらにややこしい！", 75));
    break;
  case 11:
    texts.add(new Text(-200, -200, -400, 0, "ゲームクリア！\n遊んでくれてありがとう！", 150));
    texts.add(new Text(300, -200, 400, -90, "ステージが少ないのは許してください。\nアイデアが思い浮かびませんでした。\nよければアイデアください。", 80));
    break;
  default:
    break;
  }
}
