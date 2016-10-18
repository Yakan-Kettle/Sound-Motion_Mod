class Panel {
  int x, y, f, p, i;
  int Color[][];
  
  Panel(int _x, int _y, int _f, int _p, int _Color[][], int _i) {
    x = _x;
    y = _y;
    f = _f;
    p = _p;
    Color = _Color;
    i = _i;
  }
  
  void fieldDraw() {
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(x, y, f, f);
  }
  
  void outsideDraw() {
    noStroke();
    fill(255);
    rect(0, 0, x, height);
    rect(0, 0, width, y);
    rect(x+field, 0 , x, height);
    rect(0, y+field, width, y);
  }
  
  void panelDraw() {
    stroke(0);
    strokeWeight(1);
    fill(Color[i][0], Color[i][1], Color[i][2]);
    rect(x + i*p, y - p, p, p);
    fill(Color[i+7][0], Color[i+7][1], Color[i+7][2]);
    rect(f + x, y + i*p, p, p);
    fill(Color[20-i][0], Color[20-i][1], Color[20-i][2]);
    rect(x + i*p, f + y, p, p);
  }
}
