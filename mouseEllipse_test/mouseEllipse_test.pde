int r = 50; //ボールの半径
int t = 5; //変位の基本定数
int tx = 0; //ボールのx変位
int ty = 0; //ボールのy変位
int x = 0; //ボールのx座標
int y = 0; //ボールのy座標

boolean trigger = false; //ballActionのモード切り替えスイッチ

void setup() {
  background(0);
  frameRate(30);
  size(800, 640); //width = 800px, height = 640px;
  
  //ボールの初期座標をセット
  x = round(setValue(r, width)); //返り値を四捨五入.切り上げはceil(value).
  y = round(setValue(r, height)); //返り値を四捨五入.切り捨てはfloor(value).
  
  //ボールの漂う速度をセット
  tx = round(setValue(-t, t));
  ty = round(setValue(-t, t));
  
  println(tx, ty); //デバッグ
}

void draw() {
  if(mousePressed == true && 
     pow((x-mouseX), 2) + pow((y-mouseY), 2) < pow(r, 2)) trigger = true;
  if(mousePressed == false) trigger = false;
  
  ballAction(trigger);
  
  noStroke();
  fill(255);
  ellipse(x, y, r, r);
}

float setValue(int a, int b) {
  float X = 0;
  while(X == 0) X = random(a, b); //0がセットされないように頑張ってくれるはず
  return X;
}

void ballAction(boolean trigger) {
  if(trigger){
    fade(); //残像
    x = mouseX;
    y = mouseY;
  } else {
    background(0); //背景塗りつぶし
    x += tx; //ボールを変位させる
    y += ty;
    //壁にぶつかったら変位を逆転させる
    if(x > width || x < 0) {
      tx = -tx;
    }
    if(y > height || y < 0) {
      ty = -ty;
    }
  }
}

void fade() {
  noStroke();
  fill(0, 55);
  rectMode(CORNER);
  rect(0, 0, width, height);
}

//初期状態の設定
//ボールをフヨつかせる
//つかむ/はなす状態を管理
//掴んでる時に動かせる
//物理演算は現状未設定

//(x+a)^2 + (y+b)^2 = r^2