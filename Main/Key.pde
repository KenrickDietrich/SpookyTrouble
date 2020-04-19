class Key extends Actor {


  Key(float x_, float y_) {
    super(x_, y_);

    img = loadImage("Sprites/key.png");
    img.resize(40, 20);


    cWidth = img.width;
    cHeight = img.height;
  }

  @Override
    void update() {
    drawImage();
  }

  @Override
    void drawImage() {
    pushMatrix();
    translate(loc.x, loc.y);

    if (img != null) {
      scale(-1, 1);
      rotate(radians(290));
      image(img, 0, 0);
    }

    popMatrix();
  }
}
