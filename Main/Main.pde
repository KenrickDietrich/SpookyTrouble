import processing.sound.*;

// keycodes
private final int UP_KEY    = 38;
private final int LEFT_KEY  = 37;
private final int DOWN_KEY  = 40;
private final int RIGHT_KEY = 39;

// States for the menu and game state
final String    MENU_STATE = "Menu State";
final String    ACTIVE_STATE = "Active State";
String  currentState = MENU_STATE;

// List with backgrounds and index
final ArrayList<SceneObject> scenes = new ArrayList<SceneObject>();
int sceneIndex = 0;

// Arrow keys being held boolean
boolean upHold, leftHold, downHold, rightHold;

// Player object
Player player;

// Lists with bats and spiders
ArrayList<Bat> bats = new ArrayList<Bat>();
boolean batsSpawned = false;
ArrayList<Spider> spiders = new ArrayList<Spider>();

// All furniture in scenes
Furniture cabinet, doorClosed, doorOpen, cabinetSide, couch, painting, window, kitchen, table, candles; 

Key itemKey; // Key item
boolean keyPickUp = false; // If key is picked up

float gravity = 0.35; // Gravity value
PImage menu, credits; // Image of menu

int oldMil;          // Keep track of the millisecond from last frame
float deltaTime = 0; // The time it took between last frame and this frame
int endTimer; // Timer to end the game

//http://api.openweathermap.org/data/2.5/weather?id=2756071&appid=bfdc0783cafeb0234f533c77bd347346


// Soundfiles for the weather and bats
SoundFile weatherSound, batsSound, pickUpSound, doorSound, walkSound;

void setup() {
  size(1280, 720, P2D);
  imageMode(CENTER);
  rectMode(CENTER);
  frameRate(60);
  setScenes();
  player = new Player(44, "Sprites/Player/Player");
  walkSound = new SoundFile(Main.this, "data/walking.mp3");
  itemKey = new Key(1078, 700);
  menu = loadImage("Sprites/menu.png");
  credits = loadImage("Sprites/credit.png");
  oldMil = millis();
  calcWeather();
  createSpiders();
  couch = new Furniture(612, 638, "Sprites/couch.png");
}

void draw() {
  if ( currentState == "Menu State") {
    background(menu);
    keyPickUp = false;
  } else if (currentState == "Credit State") {
    background(credits);
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
    placeFurnitureClose();

    if (sceneIndex == 3 && millis() - endTimer > 3000) {
      currentState = "Credit State";
      sceneIndex = 0;
      keyPickUp = false;
      walkSound.stop();
      batsSpawned = false;
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

void placeFurnitureClose() {
  if (sceneIndex == 1 ) {
    couch.update();
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
    painting = new Furniture(520, 480, "Sprites/painting.png");
    window = new Furniture(1082, 520, "Sprites/window.png");
    cabinetSide.update();
    painting.update();
    window.update();
  }
  if (sceneIndex == 2) {
    kitchen = new Furniture(630, 604, "Sprites/kitchen.png");
    table = new Furniture(1110, 665, "Sprites/table.png");
    candles = new Furniture(1106, 588, "Sprites/candles.png");
    window = new Furniture(589, 484, "Sprites/window.png");
    kitchen.update();
    table.update();
    candles.update();
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
    walkSound.play();
    walkSound.loop();
    break;
  case DOWN_KEY:
    downHold = true;
    break;
  case RIGHT_KEY:
    rightHold = true;
    walkSound.play();
    walkSound.loop();
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
    walkSound.stop();
    break;
  case DOWN_KEY:
    downHold = false;
    break;
  case RIGHT_KEY:
    rightHold = false;
    walkSound.stop();
    break;
  }
}
