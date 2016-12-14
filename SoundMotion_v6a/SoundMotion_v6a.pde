import processing.sound.*;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;
boolean hand;  //手の状態をセットする
Hand rightHand;  //右手の諸々の情報
Hand leftHand;  //左手の諸々の情報

int i = 0;  //カウンター
int ir = 100;  //ボール半径の基本値
int r = ir; //ボールの半径
int t = 10; //変位の基本定数
int mintx = 5; //ボールのx変位の最小値
int minty = 5; //ボールのy変位の最小値
int tx = 0; //ボールのx変位
int ty = 0; //ボールのy変位
int x = 0; //ボールのx座標
int y = 0; //ボールのy座標
float positionX = 0;
float positionY = 0;
int d = 10; //手のマーカーの直径
int w = 3; //マーカーの太さ

int alpha = 150; //簡易版エフェクトで使う
int elwid = 10;

int colorID = 0;  //色情報が入った下記配列を参照するための値
int oldID = 8;  //色が変化したタイミングを検知するための値
int[][] colorData = {  //色情報
  {255, 0, 0}, 
  {255, 0, 255}, 
  {  0, 0, 255}, 
  {  0, 255, 255}, 
  {  0, 255, 0}, 
  {255, 255, 0}, 
  {255, 128, 0}, 
  {255, 0, 0}
};

int pos = 0; //現在のボールの中心座標を一瞬記録する
ArrayList<Integer> temp;  //ボールの中心座標を保持する配列
ArrayList<Note> notes;
boolean trigger = false; //ballActionのモード切り替えスイッチ
boolean eitherHand;

SoundFile player; // = AudioPlayer player;?
ArrayList<SoundFile> piano;  // = ArrayList<AudioPlayer> piano = new ArrayList<AudioPlayer>();
ArrayList<SoundFile> drums;

void setup() {
  fullScreen(2);  //size()とケンカするので片方だけ宣言しよう
  //size(800, 640); //width = 800px, height = 640px;
  background(0);
  frameRate(30);

  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
  
  rightHand = new Hand(0);
  leftHand = new Hand(1);

  temp = new ArrayList<Integer>();
  notes = new ArrayList<Note>();
  piano = new ArrayList<SoundFile>(); 
  drums = new ArrayList<SoundFile>();

  //ボールの初期座標をセット
  x = round(setValue(r, width)); //返り値を四捨五入.切り上げはceil(value).
  y = round(setValue(r, height)); //返り値を四捨五入.切り捨てはfloor(value).

  //ボールの漂う速度をセット
  tx = round(setValue(-t, t));
  ty = round(setValue(-t, t));

  //ArrayListに初期値をセット
  for (i = 0; i < 2; i++) temp.add(0);

  audioInit();  //音声ファイルの取り込み
}

void draw() {
  fade(0);

  ArrayList<KSkeleton> skeletonArray = kinect.getSkeletonColorMap();  //こいつはどうやらここにいないとダメらしい
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if(skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
  
      rightHand.drawHandState(joints[KinectPV2.JointType_HandRight]);
      leftHand.drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }

  /*if (hand == true && 
    sq(x-rightHand.getX()) + sq(y-rightHand.getY()) < sq(r)) {
    trigger = true;
    eitherHand = true;
  } else if (hand == true &&
    sq(x-leftHand.getX()) + sq(y-leftHand.getY()) < sq(r)) {
    trigger = true;
    eitherHand = false;
  } else if (hand == false) trigger = false;*/
  
  if(rightHand.checkGraped(x, y, r) || 
     leftHand.checkGraped(x, y, r)) trigger = true;
  else trigger = false;

  ballAction(trigger);
  contract();  //中心の円が徐々に縮む

  noStroke();
  fill(255);
  ellipse(x, y, 2*r, 2*r);
  simpleEffect(trigger);  //簡易版
  
  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

float setValue(int a, int b) {
  float X = 0;
  while (abs(X) <= 5) X = random(a, b); //5以上がセットされないように頑張ってくれるはず
  return X;
}
/*
boolean checkHitHand() {
  return true;
}*/
/*
void drawHandState(KJoint joint, int either) {
  handState(joint.getState());
  if (either < 1)rightHand.drawHandMarker(joint.getX(), joint.getY(), d, w, hand);
  else leftHand.drawHandMarker(joint.getX(), joint.getY(), d, w, hand);
}

void handState(int handState) {
  //println(handState);
  //if(either == KinectPV2.JointType_HandRight) changeHand(handState, handLogR);
  //else changeHand(handState, handLogL);
  
  switch(handState) {
  case KinectPV2.HandState_Closed:
  case KinectPV2.HandState_Lasso:
    d = 20;
    w = 5;
    stroke(255);
    hand = true;
    break;
  case KinectPV2.HandState_Open:
  case KinectPV2.HandState_NotTracked:
    d = 10;
    w = 3;
    stroke(192);
    hand = false;
    break;
  }
}*/

/*void changeHand(int handState, IntList handLog) {
  if (hand == false) {
    if (handState==KinectPV2.HandState_Closed) {
      handLog = new IntList();
      hand=true;
    }
  } else {
    if (handState==KinectPV2.HandState_Closed) {
      handLog = new IntList();
    } else {
      handLog.add(1, handState);
      while (handLog.size()>4) {
        int size = handLog.size();
        handLog.remove(size);
      }
      int count=0;
      for (int i=0; i<handLog.size(); i++) {
        if (handLog.get(i)==KinectPV2.HandState_Open) count++;
      }
      if (count>2) {
        //手を開いたときの処理
        hand=false;
      }
    }
  }
}*/

void ballAction(boolean trigger) {
  if (trigger) {
    ballGrab();
  } else ballDrift();
}

void ballDrift() {
  oldID = 8;
  notes.clear();

  x += tx;
  y += ty;

  //壁にぶつかったら変位を逆転させ、最小速度より大きい速度の場合は減速させる
  if (x+r > width) {  //右
    if (tx < mintx) tx = mintx;
    if (tx > mintx) tx *= 0.9;
    tx = -abs(tx);
    drums.get(0).play();
  }
  if (x-r < 0) {  //左
    if (abs(tx) < abs(mintx)) tx = -mintx;
    if (abs(tx) > abs(mintx)) tx *= 0.9;
    tx = abs(tx);
    drums.get(1).play();
  }
  if (y+r > height) {  //下
    if (ty < minty) ty = minty;
    if (ty > minty) ty *= 0.9;
    ty = -abs(ty);
    drums.get(2).play();
  }
  if (y-r < 0) {  //上
    if (abs(ty) < abs(minty)) ty = -minty;
    if (abs(ty) > abs(minty)) ty *= 0.9;
    ty = abs(ty);
    drums.get(3).play();
  }
}

void ballGrab() {
  if (rightHand.catching) {
    positionX = rightHand.getX();
    positionY = rightHand.getY();
  } else if (leftHand.catching){
    positionX = leftHand.getX();
    positionY = leftHand.getY();
  }

  x = round(positionX);
  y = round(positionY);

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

void simpleEffect(boolean _trigger) {
  if (_trigger) {
    stroke(255);  //メインでnoStroke()しているが、ここでも必要な様子
    setColor();
    fill(colorData[colorID][0], colorData[colorID][1], colorData[colorID][2], alpha);
    ellipse(x, y, 2*r, 2*r);  //中心の円
    if (checkScale()) {  //音階が変化したら
      r = 200;  //中心の円を巨大化
      setNote();
      piano.get(colorID).play();
    }

    noFill();
    stroke(200, alpha);
    strokeWeight(2);
    for (i = 0; i < notes.size(); i++) {
      notes.get(i).setXY(positionX, positionY);
      ellipse(notes.get(i).x, notes.get(i).y, r+notes.get(i).elwid, r+notes.get(i).elwid);  //徐々に広がる灰色の円
      notes.get(i).reload();
    }  //オブジェクト指向が頭から抜けまくってたマン

    noFill();
  }
}

void setColor() {  //色は上から順番に上がっていく感じ（）
  colorID = 0;  //赤
  if (y < height * 0.125 * 7) colorID = 1;  //紫
  if (y < height * 0.125 * 6) colorID = 2;  //青
  if (y < height * 0.125 * 5) colorID = 3;  //水
  if (y < height * 0.125 * 4) colorID = 4;  //緑
  if (y < height * 0.125 * 3) colorID = 5;  //黄
  if (y < height * 0.125 * 2) colorID = 6;  //橙
  if (y < height * 0.125) colorID = 7;  //赤
}  //処理の順番はこうじゃないとダメです

boolean checkScale() {
  boolean changeScale = false;
  if (oldID != colorID) {
    changeScale = true;
    oldID = colorID;
  }
  return changeScale;
}

void setNote() {
  Note note = new Note(x, y, 1);
  notes.add(note);
}

void contract() {
  if (r > ir) r *= 0.5;
  if (r < ir) r = 50;
}

void audioInit() {
  player = new SoundFile(this, "C4do.wav");  //ID = 0
  piano.add(player);
  player = new SoundFile(this, "C4re.wav");  //ID = 1
  piano.add(player);
  player = new SoundFile(this, "C4mi.wav");  //ID = 2
  piano.add(player);
  player = new SoundFile(this, "C4fa.wav");  //ID = 3
  piano.add(player);
  player = new SoundFile(this, "C4so.wav");  //ID = 4
  piano.add(player);
  player = new SoundFile(this, "C4la.wav");  //ID = 5
  piano.add(player);
  player = new SoundFile(this, "C4ti.wav");  //ID = 6
  piano.add(player);
  player = new SoundFile(this, "C5do.wav");  //ID = 7
  piano.add(player);

  //ファイル名の語尾に_rをつけるといかにも電子音源なドラムになる
  player = new SoundFile(this, "tom_r.wav");  //ID = 0 右
  drums.add(player);
  player = new SoundFile(this, "snare_r.wav");  //ID = 1 左
  drums.add(player);
  player = new SoundFile(this, "bassdrum_r.wav");  //ID = 2 下
  drums.add(player);
  player = new SoundFile(this, "cymbal_r.wav");  //ID = 3 上
  drums.add(player);
  /*player = new SoundFile(this, "hat_r.wav");  //ID = 3 上
   drums.add(player);*/
}