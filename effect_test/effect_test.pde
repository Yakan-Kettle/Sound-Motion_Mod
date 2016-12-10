int dx = 7;     //タイムコードの速さ
int weight = 5; //タイムコードの太さ
int lineColor = 255;  //ラインの色（暫定版）

int X = 0;  //タイムコードの位置

ArrayList<Note> notes = new ArrayList<Note>();

void setup() {
  size(1920, 1080);
}

void draw() {
  background(0);//背景色

  drawBody(mouseX, mouseY);//部位の位置に〇を描く関数

  checkHit(mouseX, X, mouseY);  //タイムコードが当たったら

  //タイムコードの描画
  for(int i=0; i < 5; i++){
    stroke(lineColor, 255 - 51 * i);     //タイムコード(？)の色
    strokeWeight(weight - 1.1 * i);  //太さ
    line(X - 10 * i - i, 0, X - 10 * i - i, height); //タイムコード(？)を書き出し
  }
  X = X+dx;              //動かし
  if(X >= width) X = 0;  //端に到達したらループ。


  for (int i=0; i < notes.size (); i++) { //ここがエフェクトを描画するシステム
    noStroke();
    float rcol = random(1);
    float rdx = random(-30, 30);
    float rdy = random(-30, 30);
    float rwid = random(15,25);

    if(notes.get(i).getJoint() == 1){
      fill(255, 255, 0, notes.get(i).getAlfa() * 0.5);
      ellipse(notes.get(i).getX(), notes.get(i).getY(), 50, 50);
      if(rcol > 0.5) fill(255, 128, 0, notes.get(i).getAlfa());
      else fill(255, 255, 0, notes.get(i).getAlfa());
    } 
    ellipse(notes.get(i).getX() + rdx, notes.get(i).getY() + rdy, rwid, rwid);

    noFill();
    stroke(200, notes.get(i).getAlfa());
    strokeWeight(1);

    ellipse(notes.get(i).getX(), notes.get(i).getY(), notes.get(i).getWid(), notes.get(i).getWid());

    notes.get(i).reload();
    if (notes.get(i).getAlfa() <= 0) notes.remove(notes.get(i)); //一応メモリ解放はしてるっぽい？
    noFill();
  }
}

//５つの部位の箇所に○を描く
void drawBody(int _x, int _y) {
  stroke(100);//部位に描く○の色
  strokeWeight(1);//○の線の太さ
  ellipse(_x, _y, 10, 10);
}

void checkHit(int _x, int _X, int _y) {  //タイムコード(？)がパネルを通過したかをチェックする関数
  noStroke();
  fill(200, 100);
  //意図的にごく短い範囲を指定している。こうしないと音声ファイルが高速で連続再生されてすごいことになる。
  if(_x >= _X-5 && _x <= _X+5){
    Note note = new Note(_x, _y, 1);
    notes.add(note);
  }
  noFill();
}