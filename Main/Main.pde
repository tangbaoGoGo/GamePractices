
Player player;
//import controlP5.*;

//Map map;
PImage standMario, walkMario, jumpMario;
PImage pinkGem, powerGem;
Map currentMap;
int startTime, timeLimit = 180, passTime = 0;
boolean introduction, removeButtons;
boolean win, fail;
boolean inWater;
Map[] maps;
//ControlP5 cp5;


void setup() { 
  size(1000, 600);
  maps = new Map[2];
  maps[0] = new Map(1);
  maps[1] = new Map(2);
  player = new Player();
  currentMap = maps[0];
  introduction = true;
  inWater = false;
  standMario = loadImage("Mario1.png");
  walkMario = loadImage("Mario2.png");
  jumpMario = loadImage("Mario3.png");
  pinkGem = loadImage("pinkGem.png");
  powerGem = loadImage("powerGem.png");
  PFont f = createFont("Arial", 15);
  frameRate(90);
  win = fail = false;
}

void draw() {
  
  if(introduction) {
    background(0);
    textAlign(CENTER);
    PFont font1 = createFont("Arial", 36);
    PFont font2 = createFont("Arial", 20);
    fill(255);
    textFont(font1);
    text("Mario's New Advanture", width / 2, height / 3);
    fill(#008B00);
    rect(width / 2 - 60, height / 2 - 25, 120, 40);
    fill(255, 0, 0);
    rect(width / 2 - 60, height / 2 + 75, 120, 40);
    fill(255);
    textFont(font2);
    text("PLAY: A", width / 2, height / 2);
    text("QUIT: B", width / 2, height / 2 + 100);
  }
  else if(win) {
    background(0);
    textAlign(CENTER);
    PFont font1 = createFont("Arial", 36);
    PFont font2 = createFont("Arial", 20);
    fill(255);
    textFont(font1);
    text("Congratulations! You win!", width / 2, height / 3);
    text("Pass time:" + passTime / 60 + "minutes" + passTime % 60 + "seconds", width / 2, height / 3 + 100 );
    text("Score:" + player.score, width / 2, height / 3 + 50 );
    fill(#008B00);
    rect(width / 2 - 60, height / 2 +100, 120, 40);
    fill(255, 0, 0);
    rect(width / 2 - 60, height / 2 + 200, 120, 40);
    fill(255);
    textFont(font2);
    text("REPLAY: A", width / 2, height / 2 + 130);
    text("QUIT: B", width / 2, height / 2 + 230);
  }
  else if(fail){
    background(0);
    textAlign(CENTER);
    PFont font1 = createFont("Arial", 36);
    PFont font2 = createFont("Arial", 20);
    fill(255);
    textFont(font1);
    text("Game over", width / 2, height / 3);
    fill(#008B00);
    rect(width / 2 - 60, height / 2 - 25, 120, 40);
    fill(255, 0, 0);
    rect(width / 2 - 60, height / 2 + 75, 120, 40);
    fill(255);
    textFont(font2);
    text("REPLAY: A", width / 2, height / 2);
    text("QUIT: B", width / 2, height / 2 + 100);
  }
  else {
    background(255);
    drawLives();
    fill(0);
    textAlign(CORNER);
    displayTime();
    text("Score: " + player.score, 10, 20 );
    //drawBackground();
    currentMap.update();
    currentMap.drawMap();
    //drawRect(49, 29);
    player.integrate();
    //println(player.onGround);
  }
  
}



void keyPressed() {
  if(introduction){
    if(key == 'a' || key == 'A'){
      introduction = false;
      startTime = millis();
    }
    else if(key == 'b' || key == 'B'){
      exit();
    }
  }
  else if(win) {
    if(key == 'a' || key == 'A'){
      setup();
    }
    if(key == 'b' || key == 'B'){
      exit();
    }
  }
  else if(fail){
    if(key == 'a' || key == 'A'){
      setup();
    }
    if(key == 'b' || key == 'B'){
      exit();
    }
  }
  else{
    if(key == 'a' || key == 'A'|| keyCode == LEFT){
    player.inputs[0] = true;
    }
    else if(key == 'd' || key == 'D' || keyCode == RIGHT){
      player.inputs[1] = true;
    }
    else if(key == 's' || key == 'S' ){
      player.inputs[2] = true;
    }
    else if(key == 'w' || key == 'W' || keyCode == UP){
      player.inputs[3] = true;
    }
    else if(key == 'b' || key == 'B'){   // for debugging
      player.position.set(new PVector(950, 100));
    }
  }
}

void keyReleased() {
  if(key == 'a' || key == 'A' || keyCode == LEFT){
    player.inputs[0] = false;
  }
  else if(key == 'd' || key == 'D' || keyCode == RIGHT){
    player.inputs[1] = false;
  }
  else if(key == 's' || key == 'S' ){
    player.inputs[2] = false;
  }
  else if(key == 'w' || key == 'W' || keyCode == UP){
    player.inputs[3] = false;
  }
}
  
void displayTime() {
  int pastTime = (millis() - startTime)/ 1000;
  int restTime = timeLimit - pastTime;
  int minute = restTime / 60;
  int second = restTime % 60;
  //fill(0);
  //textAlign(CORNER);
  text(minute + ":" + second, 100, 20);
}

void drawBackground() {
  fill(#00BFFF);
  rect(0, 0, width, height / 4);
  fill(255);
  rect(0, height / 4, width, height / 4 * 3);
}

public void Play(int theValue) {
  removeButtons = true;
}

public void Quit(int theValue) {
  exit();
}

void drawLives() {
  for(int i = 0; i < player.lives; i++){
    imageMode(CORNER);
    image(standMario, width / 2 - 30 + i * 20, 15.0, 15, 30); 
  }
}
