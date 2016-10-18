class Wave {  
  float x, y, dr, dt, pitch, volume;
  int R, G, B, trans, s, id;
  ArrayList<Wave> wv;
  
  Minim minim;
  AudioOutput out;
  SineWave sine;
  
  Wave(float _x, float _y, float _dr, float _dt,
       int _R, int _G, int _B, int _trans,
       int _s, int _id, 
       ArrayList<Wave> _wv, float _pitch, float _volume) {
    x = _x;
    y = _y;
    dr = _dr;
    dt = _dt;
    R = _R;
    G = _G;
    B = _B;
    trans = _trans;
    s = _s;
    id = _id;
    wv = _wv;
    pitch = _pitch;
    volume = _volume;
  }
  
  void draw() {
    if(s == 1) {
      dr += dt;
      smooth();
      stroke(R, G, B, trans);
      strokeWeight(5);
      noFill();
      ellipse(x, y, dr, dr);
    }
  }
  
  void perform() {
    minim = new Minim(this);
    out = minim.getLineOut(Minim.STEREO);
    sine = new SineWave(pitch, volume, out.sampleRate());
    out.addSignal(sine);
  }
  
  void stop() {
    out.close();
    minim.stop();
  }
}
