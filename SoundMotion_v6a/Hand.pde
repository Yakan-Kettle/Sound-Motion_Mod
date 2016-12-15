class Hand {
  private float x;
  private float y;
  private boolean catching;
  private boolean openClose;
  private int either;
  private int handLog;
  
  private int d;
  private int w;
  
  Hand (int _either) {
    x = 0;
    y = 0;
    openClose = false;
    either = _either; //右手か左手かを識別する。0が右、1が左。
    //handLog = new IntList();  //手の状態遷移を保存するリスト
    handLog = 2;
  }
  
  void setXY(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float eitherHand() {
    return either;
  }
  
  boolean checkGraped(float _x, float _y, int r) {
    if (openClose == true && 
        sq(_x-x) + sq(_y-y) < sq(r)) {
        catching = true;
        return true;
    } else {
      catching = false;
      return false;
    }
  }
  
  void drawHandState(KJoint _joint) {
    setXY(_joint.getX(), _joint.getY());
    handState(_joint.getState());
    drawHandMarker(d, w);
  }
  
  void handState(int handState) {
    //println(handState);
    //if(either == KinectPV2.JointType_HandRight) changeHand(handState, handLogR);
    //else changeHand(handState, handLogL);
    
    switch(handState) {
    case 3:  //HandState_Closed
    case 4:  //HandState_Lasso
      d = 20;
      w = 5;
      stroke(255);
      openClose = true;
      handLog = 3;
      break;
    case 2:  //HandState_Open
      d = 10;
      w = 3;
      stroke(192);
      openClose = false;
      handLog = 2;
      break;
    case 0:  //Nodata
    case 1:  //HandState_NotTracked
      /*d = 20;
      w = 7;
      stroke(255, 0, 0);
      openClose = false;
      */
      handState(handLog);
      break;
    }
  }
  
  void drawHandMarker(int _d, int _w) {
    //update(_x, _y);
    int tempx = round(map(x, 0, width, -width*0.5, width*0.5));  //positionXを 0 ~ width から -width/2 ~ width/2 の座標系に適するように変換
    int tempy = round(map(y, 0, width, -width*0.5, width*0.5));
    
    strokeWeight(_w);
    pushMatrix();
      translate(tempx, tempy);
      ellipse(0, 0, _d, _d);  //pushMatrix()しなくてもプログラム的に問題はないが精度が悪くなってる説
    popMatrix();
  }
  /*
  void update(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  void updateState(boolean newState) {
    openClose = newState;
  }
  */
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
}