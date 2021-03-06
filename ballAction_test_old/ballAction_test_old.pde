int i = 0;  //カウンター
int r = 50; //ボールの半径
int t = 10; //変位の基本定数
int mintx = 5; //ボールのx変位の最小値
int minty = 5; //ボールのy変位の最小値
int tx = 0; //ボールのx変位
int ty = 0; //ボールのy変位
int x = 0; //ボールのx座標
int y = 0; //ボールのy座標

int alpha = 200; //簡易版エフェクトで使う
int elwid = 10;

int pos = 0; //現在のボールの中心座標を一瞬記録する
ArrayList<Integer> temp = new ArrayList<Integer>();  //ボールの中心座標を保持する配列

ArrayList<Note> notes = new ArrayList<Note>();

boolean trigger = false; //ballActionのモード切り替えスイッチ

void setup() {
  //fullScreen(2);  //size()とケンカするので片方だけ宣言しよう
  size(800, 640); //width = 800px, height = 640px;
  background(0);
  frameRate(30);

  //ボールの初期座標をセット
  x = round(setValue(r, width)); //返り値を四捨五入.切り上げはceil(value).
  y = round(setValue(r, height)); //返り値を四捨五入.切り捨てはfloor(value).

  //ボールの漂う速度をセット
  tx = round(setValue(-t, t));
  ty = round(setValue(-t, t));

  //ArrayListに初期値をセット
  for (i = 0; i < 2; i++) temp.add(0);

  println(tx, ty); //デバッグ
}

void draw() {
  //background(0);
  fade(0);

  if (mousePressed == true && 
    sq(x-mouseX) + sq(y-mouseY) < sq(r)) trigger = true;
  if (mousePressed == false) trigger = false;

  ballAction(trigger);

  noStroke();
  fill(255);
  ellipse(x, y, 2*r, 2*r);
  visualEffect();  //ここを切るときはsetNode()もOFFにしよう
}

float setValue(int a, int b) {
  float X = 0;
  while (abs(X) <= 5) X = random(a, b); //5以上がセットされないように頑張ってくれるはず
  return X;
}

void ballAction(boolean trigger) {
  if (trigger) {
    setNote();  //visualEffect()を切ってるときはここも消す
    ballGrab();
  } else ballDrift();
}

void ballDrift() {
  //background(0); //背景塗りつぶし

  x += tx;
  y += ty;

  //壁にぶつかったら変位を逆転させ、最小速度より大きい速度の場合は減速させる
  if (x+r > width) {
    if (tx < mintx) tx = mintx;
    if (tx > mintx) tx *= 0.9;
    tx = -abs(tx);
  }
  if (x-r < 0) {
    if (abs(tx) < abs(mintx)) tx = -mintx;
    if (abs(tx) > abs(mintx)) tx *= 0.9;
    tx = abs(tx);
  }
  if (y+r > height) {
    if (ty < minty) ty = minty;
    if (ty > minty) ty *= 0.9;
    ty = -abs(ty);
  }
  if (y-r < 0) {
    if (abs(ty) < abs(minty)) ty = -minty;
    if (abs(ty) > abs(minty)) ty *= 0.9;
    ty = abs(ty);
  }
}

void ballGrab() {
  //fade(0); //残像
  x = mouseX;
  y = mouseY;

  pos = 1000*x + y;  //ボールの中心座標をひとつの数で記憶する魔法（？）

  if (temp.size() >= 3) temp.remove(0);
  temp.add(pos);
  tx = temp.get(1)/1000 - temp.get(0)/1000;  //posからx座標の成分を抜き出してx変位を計算
  ty = temp.get(1)%1000 - temp.get(0)%1000;  //posからy座標の成分を抜き出してy変位を計算
}

void fade(int Color) {
  noStroke();
  fill(Color, 55);
  rectMode(CORNER);
  rect(0, 0, width, height);
}

void setNote() {
  Note note = new Note(x, y, 1);
  notes.add(note);
}

void visualEffect() {
  for (int i=0; i < notes.size (); i++) { //ここがエフェクトを描画するシステム
    noStroke();  //メインでnoStroke()しているが、ここでも必要な様子
    float rcol = random(1);  //後述の小円を描画に関する変数
    float rdx = random(-30, 30);
    float rdy = random(-30, 30);
    float rwid = random(15, 25);

    if (notes.get(i).getJoint() == 1) {
      fill(255, 255, 0, notes.get(i).getAlfa() * 0.5);  //中心の円の色
      ellipse(notes.get(i).getX(), notes.get(i).getY(), r, r);  //中心の円
      if (rcol > 0.5) fill(255, 128, 0, notes.get(i).getAlfa());  //周囲の小円の色
      else fill(255, 255, 0, notes.get(i).getAlfa());             //当確率でバラつくようになっている
    } 
    ellipse(notes.get(i).getX() + rdx, notes.get(i).getY() + rdy, rwid, rwid);//周囲の小円.描画位置が確率で変動する.

    noFill();
    stroke(200, notes.get(i).getAlfa());
    strokeWeight(1);

    ellipse(notes.get(i).getX(), notes.get(i).getY(), r+notes.get(i).getWid(), r+notes.get(i).getWid());

    notes.get(i).reload();
    if (notes.get(i).getAlfa() <= 0) notes.remove(notes.get(i)); //一応メモリ解放はしてるっぽい？
    noFill();
  }
}

void reload() {
  alpha -= 2;
  elwid += 100;
}