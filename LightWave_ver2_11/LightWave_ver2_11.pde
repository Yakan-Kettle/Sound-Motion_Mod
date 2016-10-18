import ddf.minim.*;
import ddf.minim.signals.*;

int screen = 900;
int field = (int)(screen * 0.6);
int rect_sp = (int)((screen - field)/2);
int panel_size = (int)(field / 7);
float fDiagonal = sqrt(field*field + field*field);

float x = 0;
float y = 0;
float dr = 0;
float dt = field*0.015;
int R = 0;
int G = 0;
int B = 0;
int trans = 255;
int s = 0;
int id;
int Color[][] = {
  {238,  41,  40},//0
  {239,  61,  41},
  {242, 101,  45},
  {248, 154,  64},
  {242, 209,  74},
  {236, 233,  75},
  {194, 216,  74},//6
  {123, 193,  69},
  {118, 193,  82},
  {108, 191,  93},
  {106, 197, 166},
  {100, 200, 203},
  { 32, 187, 217},
  { 70, 157, 214},//13
  { 52,  91, 169},
  { 84,  84, 164},
  {140,  83, 161},
  {158,  94, 166},
  {195,  37, 126},
  {238,  42, 124},
  {239,  74,  93}//20
};
ArrayList<Wave> wv = new ArrayList<Wave>();
Panel p = new Panel(rect_sp, rect_sp, field, panel_size, Color, id);

boolean trigger = false;

Minim minim;
AudioOutput out;
SineWave sine;
float pitch;
float volume = 1.0;

PImage img;

void setup(){
  size(900, 900);
}

void mousePressed() {
  x = mouseX;
  y = mouseY;
  setWave();
  if(x > rect_sp && y > rect_sp &&
     x < rect_sp+field && y < rect_sp+field) {
    s = 1;
  } else {
    s = 0;
  }
  if(trigger && s == 1) {
    Wave a = new Wave(x, y, dr, dt, 
                      R, G, B, trans,
                      s, id, wv,
                      pitch, volume);
    wv.add(a);
    a.perform();
  }
}

void draw() {
  background(0);
  p.fieldDraw();
  
  for(int i = 0; i < wv.size(); i++) {
    Wave a = wv.get(i);
    a.id = i;
    a.draw();
    a.trans = (int)(255*(1-a.dr/(2*fDiagonal)));
    //a.volume = 1 - a.dr/(2*fDiagonal);
    if(a.dr > 2*fDiagonal) {
      a.stop();
      wv.remove(i);
      i--;
    }
  }
  
  p.outsideDraw();
  
  for(int i = 0; i < 7; i++) {
    Panel p = new Panel(rect_sp, rect_sp, field, panel_size, Color, i);
    p.panelDraw();
  }
  
  img = loadImage("bouzu2.png");
  image(img, mouseX-24, mouseY-139);
}

void stop() {
  super.stop();
}

void setWave() {
  //Top Panels
  if(mouseX > rect_sp && 
     mouseX < rect_sp + panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[0][0];
    G = Color[0][1];
    B = Color[0][2];
    pitch = 1046.50;//do
    trigger = true;
    volume = 0.25;
  }
  if(mouseX > rect_sp + panel_size && 
     mouseX < rect_sp + 2*panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[1][0];
    G = Color[1][1];
    B = Color[1][2];
    pitch = 1174.65;//re
    trigger = true;
    volume = 0.25;
  }
  if(mouseX > rect_sp + 2*panel_size && 
     mouseX < rect_sp + 3*panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[2][0];
    G = Color[2][1];
    B = Color[2][2];
    pitch = 1318.51;//mi
    trigger = true;
    volume = 0.25;
  } 
  if(mouseX > rect_sp + 3*panel_size && 
     mouseX < rect_sp + 4*panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[3][0];
    G = Color[3][1];
    B = Color[3][2];
    pitch = 1396.91;//fa
    trigger = true;
    volume = 0.25;
  } 
  if(mouseX > rect_sp + 4*panel_size && 
     mouseX < rect_sp + 5*panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[4][0];
    G = Color[4][1];
    B = Color[4][2];
    pitch = 1567.98;//so
    trigger = true;
    volume = 0.25;
  } 
  if(mouseX > rect_sp + 5*panel_size && 
     mouseX < rect_sp + 6*panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[5][0];
    G = Color[5][1];
    B = Color[5][2];
    pitch = 1760;//la
    trigger = true;
    volume = 0.25;
  } 
  if(mouseX > rect_sp + 6*panel_size && 
     mouseX < rect_sp + 7*panel_size &&
     mouseY > rect_sp - panel_size &&
     mouseY < rect_sp) {
    R = Color[6][0];
    G = Color[6][1];
    B = Color[6][2];
    pitch = 1975.53;//ti
    trigger = true;
    volume = 0.25;
  } 
  
  //Side Panels
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp &&
     mouseY < rect_sp + panel_size) {
    R = Color[7][0];
    G = Color[7][1];
    B = Color[7][2];
    pitch = 523.25;//do
    trigger = true;
    volume = 0.5;
  } 
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp + panel_size &&
     mouseY < rect_sp + 2*panel_size) {
    R = Color[8][0];
    G = Color[8][1];
    B = Color[8][2];
    pitch = 587.32;//re
    trigger = true;
    volume = 0.5;
  } 
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp + 2*panel_size &&
     mouseY < rect_sp + 3*panel_size) {
    R = Color[9][0];
    G = Color[9][1];
    B = Color[9][2];
    pitch = 659.25;//mi
    trigger = true;
    volume = 0.5;
  } 
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp + 3*panel_size &&
     mouseY < rect_sp + 4*panel_size) {
    R = Color[10][0];
    G = Color[10][1];
    B = Color[10][2];
    pitch = 698.45;//fa
    trigger = true;
    volume = 0.5;
  } 
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp + 4*panel_size &&
     mouseY < rect_sp + 5*panel_size) {
    R = Color[11][0];
    G = Color[11][1];
    B = Color[11][2];
    pitch = 783.99;//so
    trigger = true;
    volume = 0.5;
  } 
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp + 5*panel_size &&
     mouseY < rect_sp + 6*panel_size) {
    R = Color[12][0];
    G = Color[12][1];
    B = Color[12][2];
    pitch = 880;//la
    trigger = true;
    volume = 0.5;
  } 
  if(mouseX > rect_sp + 7*panel_size && 
     mouseX < rect_sp + 8*panel_size &&
     mouseY > rect_sp + 6*panel_size &&
     mouseY < rect_sp + 7*panel_size) {
    R = Color[13][0];
    G = Color[13][1];
    B = Color[13][2];
    pitch = 987.76;//ti
    trigger = true;
    volume = 0.5;
  } 
  
  //Bottom Panels 
  if(mouseX > rect_sp + 6*panel_size && 
     mouseX < rect_sp + 7*panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[14][0];
    G = Color[14][1];
    B = Color[14][2];
    pitch = 261.62;//do
    trigger = true;
    volume = 1;
  } 
  if(mouseX > rect_sp + 5*panel_size && 
     mouseX < rect_sp + 6*panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[15][0];
    G = Color[15][1];
    B = Color[15][2];
    pitch = 293.66;//re
    trigger = true;
    volume = 1;
  } 
  if(mouseX > rect_sp + 4*panel_size && 
     mouseX < rect_sp + 5*panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[16][0];
    G = Color[16][1];
    B = Color[16][2];
    pitch = 329.62;//mi
    trigger = true;
    volume = 1;
  } 
  if(mouseX > rect_sp + 3*panel_size && 
     mouseX < rect_sp + 4*panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[17][0];
    G = Color[17][1];
    B = Color[17][2];
    pitch = 349.22;//fa
    trigger = true;
    volume = 1;
  } 
  if(mouseX > rect_sp + 2*panel_size && 
     mouseX < rect_sp + 3*panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[18][0];
    G = Color[18][1];
    B = Color[18][2];
    pitch = 391.99;//so
    trigger = true;
    volume = 1;
  } 
  if(mouseX > rect_sp + 1*panel_size && 
     mouseX < rect_sp + 2*panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[19][0];
    G = Color[19][1];
    B = Color[19][2];
    pitch = 440.00;//la
    trigger = true;
    volume = 1;
  } 
  if(mouseX > rect_sp && 
     mouseX < rect_sp + panel_size &&
     mouseY > rect_sp + 7*panel_size &&
     mouseY < rect_sp + 8*panel_size) {
    R = Color[20][0];
    G = Color[20][1];
    B = Color[20][2];
    pitch = 493.88;//ti
    trigger = true;
    volume = 1;
  } 
}