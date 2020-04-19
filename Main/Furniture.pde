class Furniture extends Actor {

  Furniture(float x_, float y_, String fileName_) {
    super(x_, y_, fileName_);

    cWidth = img.width;
    cHeight = img.height;
  }

  @Override
    void update() {

    checkWalls();
    if (leftWall || topWall || bottomWall) {
      bats.remove(this);
      return;
    }

    simplePhysicsCal();
    drawImage();
  }

  @Override
    void drawImage() {
    pushMatrix();
    translate(loc.x, loc.y);

    if (img != null) {
      image(img, 0, 0);
    }
    popMatrix();
  }
}
