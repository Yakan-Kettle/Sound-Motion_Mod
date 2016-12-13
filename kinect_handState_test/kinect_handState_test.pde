import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

void setup() {
  fullScreen(2);
  //size(1920, 1080, P3D);
  
  kinect = new KinectPV2(this);
  
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  
  kinect.init();
}

void draw() {
  background(0);
  
  ArrayList<KSkeleton> skeletonArray = kinect.getSkeletonColorMap();
  
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if(skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      
      drawHandState(joints[KinectPV2.JointType_HandRight], KinectPV2.JointType_HandRight);
      drawHandState(joints[KinectPV2.JointType_HandLeft], KinectPV2.JointType_HandLeft);
    }
  }
  
  fill(255, 0, 0);
  text(frameRate, 50, 50);
}

void drawHandState(KJoint joint, int either) {
  noStroke();
  handState(joint.getState());
  println(joint.getState());
  //pushMatrix();
  //translate(joint.getX(), joint.getY(), joint.getZ());
  //ellipse(0, 0, 70, 70);
  //popMatrix();
  
  ellipse(joint.getX(), joint.getY(), 70, 70);  //プログラム的に問題はないが精度が悪くなってる説
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:  // = 2
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed: // = 3
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso: // = 4
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked: // = 1
    fill(255, 255, 255);
    break;
  //ボーンからしてすでにNotTrackedだった場合はおそらく0
  }
}