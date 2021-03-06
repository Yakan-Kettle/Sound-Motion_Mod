int i = 0;  //カウンター
int r = 50; //ボールの半径
int t = 5; //変位の基本定数
int tx = 0; //ボールのx変位
int ty = 0; //ボールのy変位
int x = 0; //ボールのx座標
int y = 0; //ボールのy座標

int pos = 0; //現在のボールの中心座標を一瞬記録する
ArrayList<Integer> temp = new ArrayList<Integer>();  //ボールの中心座標を保持する配列

boolean trigger = false; //ballActionのモード切り替えスイッチ

void setup() {
  background(0);
  frameRate(60);
  size(800, 640); //width = 800px, height = 640px;
  
  //ボールの初期座標をセット
  x = round(setValue(r, width)); //返り値を四捨五入.切り上げはceil(value).
  y = round(setValue(r, height)); //返り値を四捨五入.切り捨てはfloor(value).
  
  //ボールの漂う速度をセット
  tx = round(setValue(-t, t));
  ty = round(setValue(-t, t));
  
  //ArrayListに初期値をセット
  for(i = 0; i < 2; i++) temp.add(0);
  
  println(tx, ty); //デバッグ
}

void draw() {
  if(mousePressed == true && 
     sq(x-mouseX) + sq(y-mouseY) < sq(r)) trigger = true;
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
    
    pos = 1000*x + y;  //ボールの中心座標をひとつの数で記憶する魔法（？）
    temp.add(pos);
    
  } else {
    background(0); //背景塗りつぶし
    
    tx = temp.get(0)/1000 - temp.get(1)/1000;  //posからx座標の成分を抜き出してx変位を計算
    ty = temp.get(0)%1000 - temp.get(1)%1000;  //posからy座標の成分を抜き出してy変位を計算
    
    x -= tx;
    y -= ty;
  }
  
  if(temp.size() >= 3) temp.remove(0);
}

void fade() {
  noStroke();
  fill(0, 55);
  rectMode(CORNER);
  rect(0, 0, width, height);
}