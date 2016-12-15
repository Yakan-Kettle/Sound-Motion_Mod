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
  
  void soundWave(int _r) {
    ellipse(x, y, _r+elwid, _r+elwid);
    reload();
  }

  void reload() {
    elwid += 100;
  }
}