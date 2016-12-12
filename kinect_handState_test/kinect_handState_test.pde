import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

void setup() {
  size(1920, 1080);
  
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
      
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }
  
  fill(255, 0, 0);
  text(frameRate, 50, 50); 
}

void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  //pushMatrix();
  //translate(joint.getX(), joint.getY(), joint.getZ());
  //ellipse(0, 0, 70, 70);
  //popMatrix();
  
  ellipse(joint.getX(), joint.getY(), 70, 70);  //プログラム的に問題はないが精度が悪くなってる説
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}