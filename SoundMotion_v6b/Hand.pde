class Hand {
  private float[] HandRight = new float[2];
  private float[] HandLeft = new float[2];
  private int[] HandState = new int[2];
  private int[] HandMarker = new int[4];
  //private float x;
  //private float y;
  //private boolean catching;
  private boolean open;
  private boolean[] openClose = new boolean[2];
  //private int either;
  private int handLog;
  
  private int d;
  private int w;
  
  Hand (float _handRightX, float _handRightY,
       float _handLeftX, float _handLeftY,
       int _handRightS, int _handLeftS/*,
       int _either*/) {
    HandRight[0] = _handRightX;
    HandRight[1] = _handRightY;
    HandLeft[0] = _handLeftX;
    HandLeft[1] = _handLeftY;
    HandState[0] = _handRightS;
    HandState[1] = _handLeftS;
    //x = 0;
    //y = 0;
    openClose[0] = false;
    openClose[1] = false;
    //either = 0; //右手か左手かを識別する。0が右、1が左。
    //handLog = new IntList();  //手の状態遷移を保存するリスト
    handLog = 2;
  }
  
  /*void setXY(float _x, float _y) {
    x = _x;
    y = _y;
  }*/
  
  float[] getHandRight() {
    return HandRight;
  }
  
  float[] getHandLeft() {
    return HandLeft;
  }
  /*
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float eitherHand() {
    return either;
  }
  */
  
  /*
  boolean checkGraped(float _x, float _y, int r) {
    if (openClose == true && 
        sq(_x-HandRight[0]) + sq(_y-HandRight[1]) < sq(r)) {
        catching = true;
        either = 0;  //右手で掴んだ
        return true;
    } else if(openClose == true && 
        sq(_x-HandLeft[0]) + sq(_y-HandLeft[1]) < sq(r)) {
        catching = true;
        either = 1;  //左手で掴んだ
        return true;
    } else {
      catching = false;
      return false;
    }
  }
  */
  
  void drawHandState() {
    //setXY(_joint.getX(), _joint.getY());
    for(int i = 0; i < HandState.length; i++) {
      handState(HandState[i]);
      HandMarker[i*2] = d;  //0,2
      HandMarker[i*2+1] = w;  //1,3
      openClose[i] = open;  //0,1
    }
    drawHandMarker();
  }
  
  void handState(int handState) {
    switch(handState) {
    case 3:  //HandState_Closed
    case 4:  //HandState_Lasso
      d = 15;
      w = 7;
      stroke(255);
      open = true;
      handLog = 3;
      break;
    case 2:  //HandState_Open
      d = 30;
      w = 3;
      stroke(172);
      open = false;
      handLog = 2;
      break;
    case 0:  //Nodata
    case 1:  //HandState_NotTracked
      handState(handLog);
      break;
    }
  }
  
  void drawHandMarker() {
    strokeWeight(HandMarker[1]);
    ellipse(HandRight[0], HandRight[1], HandMarker[0], HandMarker[0]);  //pushMatrix()しなくてもプログラム的に問題はないが精度が悪くなってる説
    strokeWeight(HandMarker[3]);
    ellipse(HandLeft[0], HandLeft[1], HandMarker[2], HandMarker[2]);
  }
}