// keycodes
private final int UP_KEY    = 38;
private final int LEFT_KEY  = 37;
private final int DOWN_KEY  = 40;
private final int RIGHT_KEY = 39;

final String    MENU_STATE = "Menu State";
final String    ACTIVE_STATE = "Active State";
final ArrayList<SceneObject> scenes = new ArrayList<SceneObject>();
int sceneIndex = 0;

String  currentState = MENU_STATE;

boolean upHold, leftHold, downHold, rightHold;

Player player;

float gravity = 0.35;
PImage menu;

int oldMil;          // keep track of the millisecond from last frame
float deltaTime = 0; // the time it took between last frame and this frame


JSONObject json;

void setup() {
  size(1280, 720, P2D);
  imageMode(CENTER);
  rectMode(CENTER);
  frameRate(60);
  setScenes();
  player = new Player(44, "Sprites/Player/Player");
  menu = loadImage("Sprites/menu.png");
  oldMil = millis();


  calcWeather();
}

void draw() {

  if ( currentState == "Menu State") {
    menu.resize(1280, 720);
    background(menu);
  } else if ( currentState != "Menu State" ) {
    deltaTime = (millis() - oldMil)*0.06;
    oldMil = millis();
    scenes.get(sceneIndex).update();

    spawnController();
    pushMatrix();
    player.update();

    popMatrix();
  }
}

void calcWeather() {
  json = loadJSONObject("data/data.json");
  JSONObject obj = json.getJSONObject("city");
  int id = obj.getInt("timezone");
  int species = obj.getInt("sunrise");
  String name = obj.getString("name");
}

void spawnController() {
}

void setScenes() {

  for (int i = 0; i < 3; i++) {
    SceneObject a = new SceneObject(loadImage("Sprites/scene" + i + ".png"));
    scenes.add(a);
  }
}


void keyPressed() {
  switch (keyCode) {
  case UP_KEY:
    upHold = true;
    break;
  case LEFT_KEY:
    leftHold = true;
    break;
  case DOWN_KEY:
    downHold = true;
    break;
  case RIGHT_KEY:
    rightHold = true;
    break;
  }
  if (key == ENTER) {
    currentState = ACTIVE_STATE;
  }
}

void keyReleased() {
  switch (keyCode) {
  case UP_KEY:
    upHold = false;
    break;
  case LEFT_KEY:
    leftHold = false;
    break;
  case DOWN_KEY:
    downHold = false;
    break;
  case RIGHT_KEY:
    rightHold = false;
    break;
  }
}
