class Note {
  private float x;
  private float y;
  private int elwid;  //ellipse width
  private int alfa;  //color alfa

  Note (float _x, float _y) {
    x = _x;
    y = _y;
    elwid = 10;
    alfa = 200;
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  int getWid() {
    return elwid;
  }
  /*
  int getAlfa() {
    return alfa;
  }
  */
  void soundWave(int _r) {
    ellipse(x, y, _r+elwid, _r+elwid);
    reload();
  }

  void reload() {
    elwid += 100;
    //alfa -= 75;
  }
  /*
  void setX(float _x) {
    x = _x;
  }

  void setY(float _y){
    y = _y;
  }
  
  void setXY(float _x, float _y) {
    x = _x;
    y = _y;
  }  //あえて座標のリアルタイム更新を切った
  */
}

//使ってない値多すぎなので最適化必須