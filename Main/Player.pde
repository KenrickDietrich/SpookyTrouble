class Player extends Actor {
  float dragX = 0.07;
  float velLimit = 10;
  float inputDelta = 0.5;
  int animationSpeed = 40;
  boolean jumping = false;
  float jumpTime = 0;
  float jumpDelay = 0;

  int lastMilAni;
  int frameC;
  ArrayList<PImage> images;

  Player(int size_, String fileName_) {
    super(fileName_+"0.png");
    lastMilAni = millis();
    frameC = 0;

    images = new ArrayList<PImage>();
    for (int c = 0; c < size_; c++)
      images.add(loadImage(fileName_+ c +".png"));
    img = images.get(0);

    cWidth = img.width;
    cHeight = img.height/2;
  }

  @Override
    void update() {
    inputCalculations();
    checkWalls();
    animationController();
    drawImage();
  }

  void inputCalculations() {
    // make a new input vector
    PVector input = new PVector();
    jumpDelay = millis() - jumpTime;

    // set the input vector
    if (rightHold)
      input.x += 1;
    if (leftHold)
      input.x -= 1;
    if (downHold)
      input.y += 1;
    if (upHold) {
      if (vel.y == 0) {
        jumping = false;
      }
      if (!jumping && jumpDelay > 1500 ) {
        vel.y = -10;
        jumping = true;
        jumpTime = millis();
      }
    }
    input.normalize();

    movementControl(input);
  }

  void movementControl(PVector input_) {
    // speedup for slowdown the input vector by delta
    input_.mult(inputDelta);

    // gravity
    input_.add(new PVector(0, gravity));

    // make input the acc
    acc = input_;

    // limit speed of player
    vel.limit(velLimit);

    //movement dampening on x axis
    vel.sub(new PVector(vel.x*dragX*deltaTime, 0));

    // calculate physics
    simplePhysicsCal();
  }

  void animationController() {
    if (upHold && jumping) {
      animate(29, 43, animationSpeed, false);
    } else if (rightHold) { 
      imgFlip = false;
      animate(14, 28, animationSpeed, true);
    } else if (leftHold) {
      imgFlip = true;
      animate(14, 28, animationSpeed, true);
    } else {
      animate(0, 13, animationSpeed, true);
    }
  }

  void animate(int min, int max, int aniSpeed, boolean loop) {
    if (millis() - lastMilAni > aniSpeed) {
      frameC++;
      lastMilAni = millis();
    }
    if (frameC < min)
      frameC = min;
    else if (loop && frameC > max)
      frameC = min;
    else if (!loop && frameC > max)
      frameC = max;

    img = images.get(frameC);
  }

  void checkScene(String direction) {


    if (direction == "next") {
      sceneIndex += 1;
    }
    if (direction == "previous") {
      sceneIndex -= 1;
    }
  }


  @Override
    void drawImage() {
    pushMatrix();
    translate(loc.x, loc.y);

    if (imgFlip)
      scale(-1, 1);

    if (img != null)
      image(img, 0, 0);

    noTint();
    popMatrix();
  }

  @Override
    void checkWalls() {
    rightWall = loc.x+cWidth/2 > width;
    leftWall  = loc.x-cWidth/2 < 0;
    topWall   = loc.y-cHeight/2 < 0;
    bottomWall= loc.y+cHeight > height;

    if (rightWall) {
      if (sceneIndex != scenes.size() -1) {
        loc.x = 0 +  cWidth/2;
        checkScene("next");
      } else { 
        vel.x = 0;
        loc.x = width - cWidth/2;
      }
    }
    if (leftWall) {
      if (sceneIndex != 0) {
        loc.x = width - cWidth/2;
        checkScene("previous");
      } else { 
        vel.x = 0;
        loc.x = 0 + cWidth/2;
      }
    }
    if (topWall) {
      vel.y = 0;
      loc.y = 0;
    }
    if (bottomWall) {
      vel.y = 0;
      loc.y = height - cHeight;
    }
  }
}
