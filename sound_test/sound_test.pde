import processing.sound.*;

SoundFile player; // = AudioPlayer player;?
ArrayList<SoundFile> wavs;
void setup() {
  size(114, 514);
  wavs = new ArrayList<SoundFile>(); // = ArrayList<AudioPlayer> wavs = new ArrayList<AudioPlayer>();

  audioInit();
  //wavs.get(0).play();
}

void draw() {
}

void audioInit() {
  println("aaaa");
  player = new SoundFile(this, "C:/Users/だれかさん/Documents/GitHub/Sound-Motion_Mod/ballAction_test/data/C4do.wav");  //ID = 0
  wavs.add(player);
  player = new SoundFile(this, "data/C4re.wav");  //ID = 1
  wavs.add(player);
  player = new SoundFile(this, "C4mi.wav");  //ID = 2
  wavs.add(player);
  player = new SoundFile(this, "C4fa.wav");  //ID = 3
  wavs.add(player);
  player = new SoundFile(this, "C4so.wav");  //ID = 4
  wavs.add(player);
  player = new SoundFile(this, "C4la.wav");  //ID = 5
  wavs.add(player);
  player = new SoundFile(this, "C4ti.wav");  //ID = 6
  wavs.add(player);
  player = new SoundFile(this, "C5do.wav");  //ID = 7
  wavs.add(player);*/
}