class Bat extends Actor {

  int timeDelta;

  Bat(float x_, float y_, int size_) {
    super(x_, y_);

    img = loadImage("Sprites/bat.png");
    img.resize(size_, size_);
    timeDelta = millis();


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
      rotate(radians(290));
      image(img, 0, 0);
    }
    popMatrix();
  }
}
