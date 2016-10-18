import KinectPV2.KJoint;
import KinectPV2.*;
import ddf.minim.*;

int dx = 7;     //タイムコードの速さ
int weight = 5; //タイムコードの太さ
int lineColor = 255;  //ラインの色（暫定版）

int X = 0;  //タイムコードの位置

KinectPV2 kinect;
//部位の位置情報（x, y）を格納する変数
ArrayList<Body> bodys = new ArrayList<Body>();  //kinectの最大人数が6人のはず

//オーディオをぶち込むリスト等
Minim minim;
AudioPlayer player;
ArrayList<AudioPlayer> wavs = new ArrayList<AudioPlayer>();

ArrayList<Note> notes = new ArrayList<Note>();

void setup() {
  size(1920, 1080);
  audioInit();  //音声ファイルの取り込み

  //キネクト初期化？
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
}

void draw() {
  //pushMatrix();//現在の座標系を保存

  //scale(1.457);//全体（座標系）を拡大
  background(0);//背景色

  setJointPosition();  //部位の位置情報（x, y）を格納
  drawBody(bodys);//部位の位置に〇を描く関数

  checkHit(X);  //タイムコードが当たったら

  //タイムコードの描画
  for(int i=0; i < 5; i++){
    stroke(lineColor, 255 - 51 * i);     //タイムコード(？)の色
    strokeWeight(weight - 1.1 * i);  //太さ
    line(X - 10 * i - i, 0, X - 10 * i - i, height); //タイムコード(？)を書き出し
  }
  X = X+dx;              //動かし
  if(X >= width) X = 0;  //端に到達したらループ。


  for (int i=0; i < notes.size (); i++) {
    noStroke();
    float rcol = random(1);
    float rdx = random(-30, 30);
    float rdy = random(-30, 30);
    float rwid = random(15,25);

    if(notes.get(i).getJoint() == KinectPV2.JointType_Head){
      fill(255, 255, 0, notes.get(i).getAlfa() * 0.5);
      ellipse(notes.get(i).getX(), notes.get(i).getY(), 50, 50);
      if(rcol > 0.5) fill(255, 128, 0, notes.get(i).getAlfa());
      else fill(255, 255, 0, notes.get(i).getAlfa());
    } else if(notes.get(i).getJoint() == KinectPV2.JointType_HandRight || notes.get(i).getJoint() == KinectPV2.JointType_HandLeft){
      fill(0, 255, 255, notes.get(i).getAlfa() * 0.5);
      ellipse(notes.get(i).getX(), notes.get(i).getY(), 50, 50);
      if(rcol > 0.5) fill(0, 255, 255, notes.get(i).getAlfa());
      else fill(0, 0, 255, notes.get(i).getAlfa());
    } else if(notes.get(i).getJoint() == KinectPV2.JointType_FootRight || notes.get(i).getJoint() == KinectPV2.JointType_FootLeft){
      fill(255, 0, 255, notes.get(i).getAlfa() * 0.5);
      ellipse(notes.get(i).getX(), notes.get(i).getY(), 50, 50);
      if(rcol > 0.5) fill(128, 0, 255, notes.get(i).getAlfa());
      else fill(255, 0, 255, notes.get(i).getAlfa());
    }
    ellipse(notes.get(i).getX() + rdx, notes.get(i).getY() + rdy, rwid, rwid);

    noFill();
    stroke(200, notes.get(i).getAlfa());
    strokeWeight(1);

    ellipse(notes.get(i).getX(), notes.get(i).getY(), notes.get(i).getWid(), notes.get(i).getWid());

    notes.get(i).reload();
    if (notes.get(i).getAlfa() <= 0) notes.remove(notes.get(i));
    //text(notes.size(), 20, 320);
    noFill();
  }

  //popMatrix();//保存した座標系に戻す

  //デバック用部位の位置表示
  //fill(255);
  //text("Head X: " + Head[0], 20, 20);
  //text("Head Y: " + Head[1], 20, 40);

  //text("HandRight X: " + HandRight[0], 20, 80);
  //text("HandRight Y: " + HandRight[1], 20, 100);

  //text("HandLeft X: " + HandLeft[0], 20, 140);
  //text("HandLeft Y: " + HandLeft[1], 20, 160);

  //text("FootRight X: " + FootRight[0], 20, 200);
  //text("FootRight Y: " + FootRight[1], 20, 220);

  //text("FootLeft X: " + FootLeft[0], 20, 260);
  //text("FootLeft Y: " + FootLeft[1], 20, 280);
  //noFill();

  //stroke(255);
  //rect(0, 0, 920, 700);

}

//５つの部位の箇所に○を描く
void drawBody(ArrayList<Body> _bodys) {
  stroke(100);//部位に描く○の色
  strokeWeight(1);//○の線の太さ
  for (Body body : _bodys) {
    ellipse(body.getHead()[0], body.getHead()[1], 10, 10);
    ellipse(body.getHandRight()[0], body.getHandRight()[1], 10, 10);
    ellipse(body.getHandLeft()[0], body.getHandLeft()[1], 10, 10);
    ellipse(body.getFootRight()[0], body.getFootRight()[1], 10, 10);
    ellipse(body.getFootLeft()[0], body.getFootLeft()[1], 10, 10);
  }
}

//部位の座標を更新
void setJointPosition(){
  //以下、部位の位置を取得して描画する部分

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  int i;
  for (i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      Body body = new Body(joints[KinectPV2.JointType_Head].getX(),
                          joints[KinectPV2.JointType_Head].getY(),
                          joints[KinectPV2.JointType_HandRight].getX(),
                          joints[KinectPV2.JointType_HandRight].getY(),
                          joints[KinectPV2.JointType_HandLeft].getX(),
                          joints[KinectPV2.JointType_HandLeft].getY(),
                          joints[KinectPV2.JointType_FootRight].getX(),
                          joints[KinectPV2.JointType_FootRight].getY(),
                          joints[KinectPV2.JointType_FootLeft].getX(),
                          joints[KinectPV2.JointType_FootLeft].getY()
                          );
      if (bodys.size() == i)
        bodys.add(body);
      else
        bodys.set(i, body);
    }
  }
  for (; i < bodys.size(); i++) {
    bodys.remove(i);
  }
}

void checkHit(int _x) {  //タイムコード(？)がパネルを通過したかをチェックする関数
  noStroke();
  fill(200, 100);
  //意図的にごく短い範囲を指定している。こうしないと音声ファイルが高速で連続再生されてすごいことになる。
  for (Body body : bodys) {
    if(_x >= body.getHead()[0]-5 && _x <= body.getHead()[0]+5){
      //ellipse(body.getHead()[0], body.getHead()[1], 120, 120);
      playSound(body.getHead()[1]);
      Note note = new Note(body.getHead()[0], body.getHead()[1], KinectPV2.JointType_Head);
      notes.add(note);
    }
    if(_x >= body.getHandRight()[0]-5 && _x <= body.getHandRight()[0]+5){
      //ellipse(HandRight[0], HandRight[1], 120, 120);
      playSound(body.getHandRight()[1]);
      Note note = new Note(body.getHandRight()[0], body.getHandRight()[1], KinectPV2.JointType_HandRight);
      notes.add(note);
    }
    if(_x >= body.getHandLeft()[0]-5 && _x <= body.getHandLeft()[0]+5){
      //ellipse(HandLeft[0], HandLeft[1], 120, 120);
      playSound(body.getHandLeft()[1]);
      Note note = new Note(body.getHandLeft()[0], body.getHandLeft()[1], KinectPV2.JointType_HandLeft);
      notes.add(note);
    }
    if(_x >= body.getFootRight()[0]-5 && _x <= body.getFootRight()[0]+5){
      //ellipse(FootRight[0], FootRight[1], 120, 120);
      playSound(body.getFootRight()[1]);
      Note note = new Note(body.getFootRight()[0], body.getFootRight()[1], KinectPV2.JointType_FootRight);
      notes.add(note);
    }
    if(_x >= body.getFootLeft()[0]-5 && _x <= body.getFootLeft()[0]+5){
      //ellipse(FootLeft[0], FootLeft[1], 120, 120);
      playSound(body.getFootLeft()[1]);
      Note note = new Note(body.getFootLeft()[0], body.getFootLeft()[1], KinectPV2.JointType_FootLeft);
      notes.add(note);
    }
  }
  noFill();
}

void playSound(float _y) {
  if(_y < 0){
    wavs.get(0).rewind();
    wavs.get(0).play();
  } else if (_y/(1080/20) > 19) {
    wavs.get(19).rewind();
    wavs.get(19).play();
  } else {
    wavs.get((int)_y/(1080/20)).rewind();
    wavs.get((int)_y/(1080/20)).play();
  }
}


void audioInit(){
  minim = new Minim(this);  //オーディオリストの生成
  player = minim.loadFile("C5la.wav");
  wavs.add(player);
  player = minim.loadFile("C5so.wav");
  wavs.add(player);
  player = minim.loadFile("C5fa.wav");
  wavs.add(player);
  player = minim.loadFile("C5mi.wav");
  wavs.add(player);
  player = minim.loadFile("C5re.wav");
  wavs.add(player);
  player = minim.loadFile("C5do.wav");
  wavs.add(player);
  player = minim.loadFile("C4ti.wav");
  wavs.add(player);
  player = minim.loadFile("C4la.wav");
  wavs.add(player);
  player = minim.loadFile("C4so.wav");
  wavs.add(player);
  player = minim.loadFile("C4fa.wav");
  wavs.add(player);
  player = minim.loadFile("C4mi.wav");
  wavs.add(player);
  player = minim.loadFile("C4re.wav");
  wavs.add(player);
  player = minim.loadFile("C4do.wav");
  wavs.add(player);
  player = minim.loadFile("C3ti.wav");
  wavs.add(player);
  player = minim.loadFile("C3la.wav");
  wavs.add(player);
  player = minim.loadFile("C3so.wav");
  wavs.add(player);
  player = minim.loadFile("C3fa.wav");
  wavs.add(player);
  player = minim.loadFile("C3mi.wav");
  wavs.add(player);
  player = minim.loadFile("C3re.wav");
  wavs.add(player);
  player = minim.loadFile("C3do.wav");
  wavs.add(player);
}