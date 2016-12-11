class Note {
  private float x;
  private float y;
  private int joint;
  private int elwid;  //ellipse width
  private int alfa;  //color alfa

  Note (float _x, float _y, int _joint) {
    x = _x;
    y = _y;
    joint = _joint;
    elwid = 10;
    alfa = 200;
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  int getJoint(){
    return joint;
  }

  int getWid() {
    return elwid;
  }

  int getAlfa() {
    return alfa;
  }

  void reload() {
    elwid += 2;
    alfa -= 2;
  }

  void setX(float _x) {
    x = _x;
  }

  void setY(float _y){
    y = _y;
  }
}