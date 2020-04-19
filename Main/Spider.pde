class Spider extends Actor {
  int flip;

  Spider(float x_, float y_, int size_, int flip_) {
    super(x_, y_);

    img = loadImage("Sprites/spider.png");
    img.resize(size_, size_);
    flip = flip_;


    cWidth = img.width;
    cHeight = img.height;
  }

  @Override
    void update() {

    checkWalls();
    if (leftWall || rightWall) {
      vel.x  = vel.x * -1;
    }
    if (topWall || bottomWall) {
      vel.y  = vel.y * -1;
    }


    simplePhysicsCal();
    drawImage();
  }

  @Override
    void drawImage() {
    pushMatrix();
    translate(loc.x, loc.y);

    if (img != null) {
      switch(flip) {
      case 1: 
        scale(1, 1);
        break;
      case 2: 
        scale(-1, 1);
        break;
      case 3: 
        scale(1, -1);
        break;
      case 4: 
        scale(-1, -1);
        break;
      }
      image(img, 0, 0);
    }
    popMatrix();
  }
}
