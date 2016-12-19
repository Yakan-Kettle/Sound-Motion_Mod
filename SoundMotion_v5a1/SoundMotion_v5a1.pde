import KinectPV2.KJoint;
import KinectPV2.*;
import processing.sound.*;

int dx = 7;     //タイムコードの速さ
int weight = 5; //タイムコードの太さ
int lineColor = 255;  //ラインの色（暫定版）

int X = 0;  //タイムコードの位置

KinectPV2 kinect;
//部位の位置情報（x, y）を格納する変数
ArrayList<Body> bodys = new ArrayList<Body>();  //kinectの最大人数が6人のはず

//オーディオをぶち込むリスト等
SoundFile player; // = AudioPlayer player;?
ArrayList<SoundFile> wavs = new ArrayList<SoundFile>(); // = ArrayList<AudioPlayer> wavs = new ArrayList<AudioPlayer>();

ArrayList<Note> notes = new ArrayList<Note>();

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

void setup() {
  size(1920, 1080);
  audioInit();  //音声ファイルの取り込み

  //キネクト初期化？
  kinect = new KinectPV2(this);
  kinect.enableSkeletonColorMap(true);
  kinect.init();
}

void draw() {
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
    
    float px = notes.get(i).getX();
    float py = notes.get(i).getY();
    int alpha = notes.get(i).getAlfa();
    
    fillColor(0, setID(py), alpha);
    ellipse(px, py, 50, 50);
    
    if(rcol > 0.5) fillColor(1, setID(py), alpha);
    else fillColor(2, setID(py), alpha);
    ellipse(notes.get(i).getX() + rdx, notes.get(i).getY() + rdy, rwid, rwid);

    noFill();
    stroke(200, notes.get(i).getAlfa());
    strokeWeight(1);

    ellipse(notes.get(i).getX(), notes.get(i).getY(), notes.get(i).getWid(), notes.get(i).getWid());

    notes.get(i).reload();
    if (notes.get(i).getAlfa() <= 0) notes.remove(notes.get(i));
    noFill();
  }
}

void fillColor(int mode, int id, int _alpha) {
  if(mode == 0) {
    fill(colorData[id][0], colorData[id][1], colorData[id][2], _alpha * 0.5);
  } else if(mode == 1) {
    if(id != 0) id--;
    else id++;
    fill(colorData[id][0], colorData[id][1], colorData[id][2], _alpha * 0.5);
  } else if(mode == 2) {
    fill(colorData[id][0], colorData[id][1], colorData[id][2], _alpha);
  }
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
  wavs.get(setID(_y)).play();
}

int setID(float _y) {
  int ID = 0;  //赤
  if (_y < height * 0.125 * 7) ID = 1;  //紫
  if (_y < height * 0.125 * 6) ID = 2;  //青
  if (_y < height * 0.125 * 5) ID = 3;  //水
  if (_y < height * 0.125 * 4) ID = 4;  //緑
  if (_y < height * 0.125 * 3) ID = 5;  //黄
  if (_y < height * 0.125 * 2) ID = 6;  //橙
  if (_y < height * 0.125) ID = 7;  //赤
  return ID;
}


void audioInit(){
  player = new SoundFile(this, "C4do.wav");  //ID = 0
  wavs.add(player);
  player = new SoundFile(this, "C4re.wav");  //ID = 1
  wavs.add(player);
  player = new SoundFile(this, "C4mi.wav");  //ID = 2
  wavs.add(player);
  player = new SoundFile(this, "C4fa.wav");  //ID = 3
  wavs.add(player);
  player = new SoundFile(this, "C4so.wav");  //ID = 4
  wavs.add(player);
  player = new SoundFile(this, "C4la.wav");  //ID = 5
  wavs.add(player);
  player = new SoundFile(this, "C4ti.wav");  //ID = 6
  wavs.add(player);
  player = new SoundFile(this, "C5do.wav");  //ID = 7
  wavs.add(player);
}