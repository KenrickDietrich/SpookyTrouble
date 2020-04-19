class Actor extends GameObject {

  PImage img;
  int cWidth, cHeight;
  boolean topWall, bottomWall, rightWall, leftWall;
  boolean imgFlip;

  Actor() {
    super();
  }

  Actor(float x_, float y_) {
    super(x_, y_);
  }

  Actor(float x_, float y_, String fileName_) {
    super(x_, y_);
    img = loadImage(fileName_);
  }

  Actor(String fileName_) {
    super();
    img = loadImage(fileName_);
  }

  @Override
    void update() {
    simplePhysicsCal();
  }

  void drawImage() {
    pushMatrix();
    translate(loc.x, loc.y);

    ellipse(0, 0, 10, 10);

    popMatrix();
  }

  void offScreenS(float screenExtention) {
    if (loc.x < 0 - img.width/2       -screenExtention)
      loc.x = width + img.width/2     +screenExtention;
    if (loc.x > width + img.width/2   +screenExtention)
      loc.x = 0 - img.width/2         -screenExtention;
    if (loc.y < 0 - img.height/2      -screenExtention)
      loc.y = height + img.height/2   +screenExtention;
    if (loc.y > height + img.height/2 +screenExtention)
      loc.y = 0 - img.height/2        -screenExtention;
  }

  void checkWalls() {
    rightWall = loc.x-cWidth/2 > width;
    leftWall  = loc.x+cWidth/2 < 0;
    topWall   = loc.y+cHeight/2 < 0;
    bottomWall= loc.y-cHeight > height;
  }
}
