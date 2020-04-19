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

ArrayList<Bat> bats = new ArrayList<Bat>();
ArrayList<Spider> spiders = new ArrayList<Spider>();

Furniture cabinet, doorClosed, doorOpen, cabinetSide, couch, painting, window;

Key itemKey;
boolean keyPickUp = false;

float gravity = 0.35;
PImage menu;

int oldMil;          // keep track of the millisecond from last frame
float deltaTime = 0; // the time it took between last frame and this frame

//{
//    "id": 2756071,
//    "name": "Enschede",
//    "state": "",
//    "country": "NL",
//    "coord": {
//      "lon": 6.89583,
//      "lat": 52.21833
//    }
//  },

//http://api.openweathermap.org/data/2.5/weather?id=2756071&appid=bfdc0783cafeb0234f533c77bd347346

import processing.sound.*;
SoundFile weatherSound, batsSound;

int endTimer;

void setup() {
  size(1280, 720, P2D);
  imageMode(CENTER);
  rectMode(CENTER);
  frameRate(60);
  setScenes();
  player = new Player(44, "Sprites/Player/Player");
  itemKey = new Key(1078, 700);
  menu = loadImage("Sprites/menu.png");
  oldMil = millis();
  calcWeather();
  createSpiders();
}

void draw() {

  if ( currentState == "Menu State") {
    menu.resize(1280, 720);
    background(menu);
    keyPickUp = false;
  } else if ( currentState != "Menu State" ) {
    deltaTime = (millis() - oldMil)*0.06;
    oldMil = millis();
    scenes.get(sceneIndex).update();

    for (int i = 0; i < spiders.size(); i++) {
      spiders.get(i).update();
    }
    placeFurniture();
    for (int i = 0; i < bats.size(); i++) {
      bats.get(i).update();
    }
    pushMatrix();
    if (sceneIndex == 2 && !keyPickUp) {
      itemKey.update();
    }
    player.update();
    popMatrix();


    if (sceneIndex == 3 && millis() - endTimer > 3000) {
      currentState = "Menu State";
    }
  }
}

void calcWeather() {
  JSONObject json = loadJSONObject("data/data.json");
  JSONArray weather = json.getJSONArray("weather");
  JSONObject weatherObject = weather.getJSONObject(0);
  playAudio(weatherObject.getString("main"));
}

void playAudio(String weather) {
  switch(weather) {
  case "Rain": 
    weatherSound = new SoundFile(this, "data/rain.mp3");
    break;
  case "Thunderstorm":
    weatherSound = new SoundFile(this, "data/thunder.mp3");
    break;
  default: 
    weatherSound = new SoundFile(this, "data/wind.mp3");
    break;
  }
  weatherSound.play();
  weatherSound.loop();
}

void spawnController() {
  if (bats.size() < 3) {
    Bat a = new Bat(width + 100, 450, (int) random(100, 130));
    Bat b = new Bat(width + 100, 500, (int) random(100, 130));
    Bat c = new Bat(width + 100, 600, (int) random(100, 130));

    createBat(a);
    createBat(b);
    createBat(c);
  }
}

void createBat(Bat bat) {
  bat.vel.x = -9.5;
  bat.vel.y = -7;
  bats.add(bat);
}

void createSpiders() {
  for (int i = 0; i < 20; i++) {
    Spider a = new Spider(random(0, width), random(0, height), 25, (int) random(0, 4));
    a.vel.x = random(0, 0.8);
    a.vel.y = random(0, 0.8);
    spiders.add(a);
  }
}

void setScenes() {

  for (int i = 0; i < 4; i++) {
    SceneObject a = new SceneObject(loadImage("Sprites/scene" + i + ".png"));
    scenes.add(a);
  }
}

void placeFurniture() {
  if (sceneIndex == 0) {
    cabinet = new Furniture(188, 578, "Sprites/cabinet.png");
    doorClosed = new Furniture(871, 595, "Sprites/doorclosed.png");
    cabinet.update();
    doorClosed.update();
  }
  if (sceneIndex == 1) {
    cabinetSide = new Furniture(41, 585, "Sprites/cabinetside.png");
    couch = new Furniture(612, 638, "Sprites/couch.png");
    painting = new Furniture(520, 480, "Sprites/painting.png");
    window = new Furniture(1082, 520, "Sprites/window.png");

    cabinetSide.update();
    painting.update();
    couch.update();
    window.update();
  }
  if (sceneIndex == 3) {
    cabinet = new Furniture(188, 578, "Sprites/cabinet.png");
    doorOpen = new Furniture(871, 595, "Sprites/dooropen.png");
    cabinet.update();
    doorOpen.update();
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
  if (key == 'e') {
    player.interact();
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
