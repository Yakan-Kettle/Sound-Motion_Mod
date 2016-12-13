class RightHand {
  private float x;
  private float y;
  private KJoint joint;
  private boolean openClose;
  private int either;
  private IntList handLog;
  
  private int d;
  private int w;
  
  RightHand () {
    openClose = false;
    either = 0; //右手か左手かを識別する。0が右、1が左。
    handLog = new IntList();  //手の状態遷移を保存するリスト
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
  
  void drawHandState(KJoint _joint) {
    handState(_joint.getState());
    drawHandMarker(_joint.getX(), _joint.getY(), d, w);
  }
  
  void handState(int handState) {
    //println(handState);
    //if(either == KinectPV2.JointType_HandRight) changeHand(handState, handLogR);
    //else changeHand(handState, handLogL);
    
    switch(handState) {
    case 3:  //HandState_Closed
    case 4:  //HandState_Lasso
    case 0:  //Nodata
      d = 20;
      w = 5;
      stroke(255);
      openClose = true;
      break;
    case 2:  //HandState_Open
    case 1:  //HandState_NotTracked
      d = 10;
      w = 3;
      stroke(192);
      openClose = false;
      break;
    }
  }
  
  void drawHandMarker(float _x, float _y, int _d, int _w) {
    //update(_x, _y);
    strokeWeight(_w); 
    ellipse(_x, _y, _d, _d);  //pushMatrix()しなくてもプログラム的に問題はないが精度が悪くなってる説
  }
  
  void update(float _x, float _y) {
    x = _x;
    y = _y;
  }
  
  void updateState(boolean newState) {
    openClose = newState;
  }
  
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

//手の状態を別々に管理する必要がある
//ボールマーカはこのクラスに描画させる