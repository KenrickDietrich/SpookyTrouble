class SceneObject {

  PImage background;


  SceneObject(PImage _background) {
    background = _background;
  }

  PImage getBackground() {

    return background;
  }

  void update() {
    background(background);
  }
}
