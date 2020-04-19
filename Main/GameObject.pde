class GameObject {
  PVector loc; // location Vector
  PVector vel; // Velocity Vector
  PVector acc; // Acceleration Vector

  PVector des; // Smooth pan destination, only use for smoothpan
  float smoothFactor; //Smooth factor from 0 to 1 where 0 is no smootning


  GameObject() {
    loc = new PVector();
    vel = new PVector();
    acc = new PVector();
    des = new PVector();
  }

  GameObject(float x_, float y_) {
    loc = new PVector(x_, y_);
    vel = new PVector();
    acc = new PVector();
    des = new PVector();
  }

  void update() {
  }

  void simplePhysicsCal() {
    vel.add(acc.copy().mult(deltaTime));
    loc.add(vel.copy().mult(deltaTime));
  }

  void smoothMove() {
    float vX = des.x - loc.x;
    float vY = des.y - loc.y;

    vX *= smoothFactor;
    vY *= smoothFactor;

    vel = new PVector(vX, vY);
  }

  void setsmoothFactor(float smoothFactor_) {
    smoothFactor = smoothFactor_;
  }
}
