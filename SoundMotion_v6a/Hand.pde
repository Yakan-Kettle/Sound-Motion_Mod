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
      handState(handLog);
      break;
    }
  }
  
  void drawHandMarker(int _d, int _w) {
    strokeWeight(_w);
    ellipse(x, y, _d, _d);  //pushMatrix()しなくてもプログラム的に問題はないが精度が悪くなってる説
  }
}