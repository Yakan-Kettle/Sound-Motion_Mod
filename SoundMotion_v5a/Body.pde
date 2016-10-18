class Body {
  private float[] Head = new float[2];
  private float[] HandRight = new float[2];
  private float[] HandLeft = new float[2];
  private float[] FootRight = new float[2];
  private float[] FootLeft = new float[2];

  Body(float _headX, float _headY,
      float _handRightX, float _handRightY,
      float _handLeftX, float _handLeftY,
      float _footRightX, float _footRightY,
      float _footLeftX, float _footLeftY
      ) {
    Head[0] = _headX;
    Head[1] = _headY;
    HandRight[0] = _handRightX;
    HandRight[1] = _handRightY;
    HandLeft[0] = _handLeftX;
    HandLeft[1] = _handLeftY;
    FootRight[0] = _footRightX;
    FootRight[1] = _footRightY;
    FootLeft[0] = _footLeftX;
    FootLeft[1] = _footLeftY;
  }

  float[] getHead() {
    return Head;
  }

  float[] getHandRight() {
    return HandRight;
  }

  float[] getHandLeft() {
    return HandLeft;
  }

  float[] getFootRight() {
    return FootRight;
  }

  float[] getFootLeft() {
    return FootLeft;
  }

}