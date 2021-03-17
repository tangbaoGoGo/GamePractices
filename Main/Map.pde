class Map {
  // hold all of the map specific data
  // level geometry
  private Tile[][] tiles;
  private PVector position;
  public final int MAP_WIDTH = width / Tile.TILE_SIZE, MAP_HEIGHT = height / Tile.TILE_SIZE;
  int t1, t2;
  ArrayList<Bomb> triggeredBombs;
  ArrayList<Map> maps;
  int moveCount = 0, pLeft1 = 7, pLeft2 = 0, pLeft3 = 34, pLeft4 = 18, pLeft5 = 32;
  boolean goLeft1 = true, goLeft2 = true, goLeft3 = true;
  boolean goLeft5 = true, goLeft4 = true;
  int level;
  ArrayList<Monster> monsters;
  ArrayList<Stone> stones;
  ArrayList<Savepoint> savepoints;
  int saveCount = 0;
  int gemNumber = 0;
  boolean groundHasWater = false;
  Exit exit;
  
  Map(int level) {
    this.level = level;
    println("Map width = " + MAP_WIDTH + ", Map height = " + MAP_HEIGHT);
    tiles = new Tile[MAP_WIDTH][MAP_HEIGHT]; 
    t1 = t2 = 0;
    triggeredBombs = new ArrayList<Bomb>(0);
    for(int i = 0; i < MAP_WIDTH; i++) {
      for(int j = 0; j < MAP_HEIGHT; j++) {
        tiles[i][j] = null;
      }
    }
    monsters = new ArrayList<Monster>();
    stones = new ArrayList<Stone>();
    savepoints = new ArrayList<Savepoint>();
    if(level == 1){
      exit = new Exit(new PVector(49 * Tile.TILE_SIZE, 4 * Tile.TILE_SIZE));
      createLevelOne(); 
    }
    else if (level == 2){
      exit = new Exit(new PVector(47 * Tile.TILE_SIZE, 29 * Tile.TILE_SIZE));
      createLevelTwo();
    }
  }
  
  public PVector tileAtPoint(PVector position) {
    int i, j;
    i = (int)position.x / Tile.TILE_SIZE;
    j = (int)position.y / Tile.TILE_SIZE;
    return new PVector(i, j);
  }
  
  public int tileXAtPointX(float x) {
    return (int)x / Tile.TILE_SIZE;
  }
  
  public int tileYAtPointY(float y) {
    return (int)y / Tile.TILE_SIZE;
  }
  
  public PVector getTilePosition(int i, int j) {
    PVector pos = new PVector(0, 0); 
    pos.x = i * Tile.TILE_SIZE;
    pos.y = j * Tile.TILE_SIZE;
    return pos;
  }
  
  public Tile getTile(int i, int j) {
   if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT){
     return Tile.BLOCK; 
   }
   
   return tiles[i][j];
  }
  
  public ArrayList<Monster> getMonsters() {
    return monsters; 
  }
  
  public boolean isObstacle(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return true; 
      
    //return (getTile(i, j) != Tile.EMPTY && getTile(i, j) != Tile.WATER
    //&& getTile(i, j) != Tile.GEM);
    return(getTile(i, j) == Tile.BLOCK || getTile(i, j) == Tile.BOMB 
    || getTile(i, j) == Tile.BOUNCE || getTile(i, j) == Tile.ICE 
    || getTile(i, j) == Tile.MOVINGBLOCK || isStone(i, j)
    || getTile(i, j) == Tile.HITBLOCK);
  }
  
  public boolean isWater(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.WATER);
  }
  
  public boolean isStone(int i, int j) {
    for(Stone st: stones){
      if((int)st.getPosition().x / Tile.TILE_SIZE == i 
      && (int)st.getPosition().y / Tile.TILE_SIZE == j)
        return true;
    }
    
    return false;
  }
  
  //public boolean isGround(int i, int j) {
  //  if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
  //   return false; 
      
  //  return (getTile(i, j) == Tile.BLOCK || );
  //}
  
  public boolean isEmpty(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.EMPTY);
  }
  
  public boolean isIce(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.ICE);
  }
  
  public boolean isBounce(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.BOUNCE);
  }
  
  public boolean isBomb(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.BOMB);
  }
  
  public boolean isGem(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.GEM);
  }
  
  public boolean isPowergem(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.POWERGEM);
  }
  
  public boolean isHitblock(int i, int j) {
    if(i < 0 || i >= MAP_WIDTH || j < 0 || j >= MAP_HEIGHT)
     return false; 
      
    return (getTile(i, j) == Tile.HITBLOCK);
  }
  
  public boolean hasGround(PVector oldPos, PVector pos, PVector speed) {
    PVector center = pos.copy().add(player.AABBOffset);
    float left = center.x - player.halfWidth;
    float right = center.x + player.halfWidth;
    float top = center.y - player.halfHeight;
    float bottom = center.y + player.halfHeight;
    
    int i1 = tileXAtPointX(left);
    int i2 = tileXAtPointX(right - 2);
    int j1 = tileYAtPointY(top );
    int j2 = tileYAtPointY(bottom);
    
    for(int i = i1; i <= i2; i++ ){
        if(isObstacle(i, j2) && !isObstacle(i, j2 - 1)){
          //println("old position: " + oldPos + ", position: " + pos);
          if(oldPos.y + player.halfHeight * 2 <= getTilePosition(i, j2).y){
            player.setPosition(pos.x, getTilePosition(i, j2).y - 2 * player.halfHeight);
            if(speed.y > 0){
              player.setCurrentState(PlayerState.STAND); 
            }
            player.onGround = true;
            if(isIce(i, j2)) {
              player.onIce = true;
              player.onBounce = false;
              player.onBomb = false;
            }
            else if (isBounce(i, j2)){
              player.onIce = false;
              player.onBounce = true;
              player.onBomb = false;
            }
            else if (isBomb(i, j2)) {
              player.onIce = false;
              player.onBounce = false;
              player.onBomb = true;
              Bomb nb = new Bomb(i, j2, millis());
              triggeredBombs.add(nb);
              // add this Bomb block to queue, wait for explosion
              
            }
            else {
              player.onIce =false;
              player.onBounce = false;
              player.onBomb = false;
            }
            return true;
          }
          return true;
        }
        if(isWater(i, j2) && !inWater) {
          
          groundHasWater = true;
        }
        else if(!isWater(i, j2)){
          inWater = false;
        }
          
          
        if(isGem(i, j2)) {
          PVector tileCenter = getTilePosition(i, j2).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            player.score++;
            timeLimit += 20;
            tiles[i][j2] = Tile.EMPTY;
          }
        }
        else if(isPowergem(i, j2) && !player.powered){
        PVector tileCenter = getTilePosition(i, j2).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
            if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
              //player.score++;
              tiles[i][j2] = Tile.EMPTY;
              player.halfWidth *= 1.5;
            player.halfHeight *= 1.5;
            player.powered = true;
            player.setCenter();
            }
        }
        if(i == i2){
          player.onGround = false;
      if(groundHasWater){
        player.position.set(player.lastSavepoint());
        player.onGround = false;
        player.lives--;
        inWater = true;
        groundHasWater = false;
      }
        }
      
    }
    return false;
  }
  
  public boolean hasCeiling(PVector oldPos, PVector pos, PVector speed) {
    PVector center = pos.copy().add(player.AABBOffset);
    float left = center.x - player.halfWidth;
    float right = center.x + player.halfWidth;
    float top = center.y - player.halfHeight;
    float bottom = center.y + player.halfHeight;
    
    int i1 = tileXAtPointX(left);
    int i2 = tileXAtPointX(right - 2);
    int j1 = tileYAtPointY(top);
    int j2 = tileYAtPointY(bottom);
    
    for(int i = i1; i <= i2; i++ ){
      if(isObstacle(i, j1)){
        if(oldPos.y >= getTilePosition(i, j1).y + Tile.TILE_SIZE){
          // collide with the block above
          player.setPosition(pos.x, getTilePosition(i, j1).y + Tile.TILE_SIZE);
          if(speed.y < 0)
            player.speed.set(speed.x, 0);
          if (isBomb(i, j1)) {
            player.onBomb = true;
            Bomb nb = new Bomb(i, j1, millis());
            triggeredBombs.add(nb);
            // add this Bomb block to queue, wait for explosion
          }
          if (isHitblock(i, j1)) {
            tiles[i][j1 - 1] = Tile.POWERGEM;
            tiles[i][j1] = Tile.BLOCK;
          }
          player.atCeiling = true;
          
          return true;
        }
        
      }
      
      else if(isGem(i, j1)) {
          PVector tileCenter = getTilePosition(i, j1).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            player.score++;
            timeLimit += 20;
            tiles[i][j1] = Tile.EMPTY;
          }
        }
        else if(isPowergem(i, j1) && !player.powered){
      PVector tileCenter = getTilePosition(i, j1).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            //player.score++;
            tiles[i][j1] = Tile.EMPTY;
            player.halfWidth *= 1.5;
          player.halfHeight *= 1.5;
          player.powered = true;
          player.setCenter();
          }
    }
    }
    return false;
  }
  
  public boolean pushesRightWall(PVector oldPos, PVector pos, PVector speed) {
  PVector center = pos.copy().add(player.AABBOffset);
  float left = center.x - player.halfWidth;
  float right = center.x + player.halfWidth;
  float top = center.y - player.halfHeight;
  float bottom = center.y + player.halfHeight;
  
  int i1 = tileXAtPointX(left);
  int i2 = tileXAtPointX(right);
  int j1 = tileYAtPointY(top);
  int j2 = tileYAtPointY(bottom);
  
  for(int j = j1; j <= j2; j++ ){
    if(isObstacle(i1, j)){
      //println("old position: " + oldPos + ", position: " + pos);
      //bottom > getTilePosition(i1, j).y
      if(oldPos.x >= getTilePosition(i1, j).x + Tile.TILE_SIZE){
        if(!((j == j2 && bottom <= getTilePosition(i1, j).y)
        || (j == j1 && top >= getTilePosition(i1, j).y + Tile.TILE_SIZE))){
          player.setPosition(getTilePosition(i1, j).x + Tile.TILE_SIZE, player.position.y);
          if(speed.x < 0){
            speed.x = 0; 
          }
          player.pushesRightWall = true;
          return true;
        }
      }
    }
    else if(isGem(i1, j)) {
          PVector tileCenter = getTilePosition(i1, j).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            player.score++;
            timeLimit += 20;
            tiles[i1][j] = Tile.EMPTY;
          }
        }
    else if(isPowergem(i1, j) && !player.powered){
      PVector tileCenter = getTilePosition(i1, j).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            //player.score++;
            tiles[i1][j] = Tile.EMPTY;
            player.halfWidth *= 1.5;
          player.halfHeight *= 1.5;
          player.powered = true;
          player.setCenter();
          }

    }
  }
  return false;
 }
  
  public boolean pushesLeftWall(PVector oldPos, PVector pos, PVector speed) {
  PVector center = pos.copy().add(player.AABBOffset);
  float left = center.x - player.halfWidth;
  float right = center.x + player.halfWidth;
  float top = center.y - player.halfHeight;
  float bottom = center.y + player.halfHeight;
  
  int i1 = tileXAtPointX(left);
  int i2 = tileXAtPointX(right);
  int j1 = tileYAtPointY(top);
  int j2 = tileYAtPointY(bottom);
  
  for(int j = j1; j <= j2; j++ ){
    if(isObstacle(i2, j)){
      //println("old position: " + oldPos + ", position: " + pos);
      //bottom > getTilePosition(i1, j).y
      if(oldPos.x + 2 * player.halfWidth <= getTilePosition(i2, j).x){
        if(!((j == j2 && bottom <= getTilePosition(i2, j).y)
        || (j == j1 && top >= getTilePosition(i2, j).y + Tile.TILE_SIZE))){
          player.setPosition(getTilePosition(i2, j).x - 2 * player.halfWidth, player.position.y);
          if(speed.x > 0){
            speed.x = 0; 
          }
          player.pushesLeftWall = true;
          return true;
        }
      }
    }
    else if(isGem(i2, j)) {
          PVector tileCenter = getTilePosition(i2, j).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            player.score++;
            timeLimit += 20;
            tiles[i2][j] = Tile.EMPTY;
          }
        }
        else if(isPowergem(i2, j) && !player.powered){
      PVector tileCenter = getTilePosition(i2, j).copy().add(new PVector(Tile.TILE_SIZE / 2, Tile.TILE_SIZE / 2));
          if(tileCenter.sub(player.position).mag() <= 3 / 4.0 * Tile.TILE_SIZE) {
            //player.score++;
            tiles[i2][j] = Tile.EMPTY;
            player.halfWidth *= 1.5;
          player.halfHeight *= 1.5;
          player.powered = true;
          player.setCenter();
          }
          
    }
  }
  return false;
 }
 
 public void checkBombs() {
   int t = millis();
   for(int i = 0; i < triggeredBombs.size(); i++) {
     Bomb b = triggeredBombs.get(i);
      if(b.timeToExplode(t)) {
        println("Time to explode");
        // explode
        tiles[(int)b.getIndex().x][(int)b.getIndex().y] = Tile.EMPTY;
      }
      if(b.formation(t)) {
        println("formation");
        strokeWeight(1);
        stroke(0);
        fill(255, 0, 0, b.transparency(t));
        rect(b.getPosition().x, b.getPosition().y, Tile.TILE_SIZE, Tile.TILE_SIZE, 5);
      }
      if(b.timeToRegenerate(t)) {
        println("Time to regenerate");
        // regenerate the bomb tile
        tiles[(int)b.getIndex().x][(int)b.getIndex().y] = Tile.BOMB;
        triggeredBombs.remove(i);
      }
   }
 }
  
  public void createTestLevel() {
    for(int i = 0; i < MAP_WIDTH; i++) {
      for(int j = 0; j < MAP_HEIGHT; j++) {
        if((i == 20 && j == 27) || (i == 21 && j == 27)) {
          tiles[i][j] = Tile.BLOCK;
        }
        else if(i <= 5 && j == 20) { // BLOCK FLOOR 2
          tiles[i][j] = Tile.BLOCK;
        }
        else if(i <= 5 && j == 25) { // BLOCK FLOOR 1
          tiles[i][j] = Tile.BLOCK;
        }
        else if(i == 0 && j == 29) { // test pushesRightWall
          tiles[i][j] = Tile.BLOCK; 
        }
        else if(i <= 49 && i >= 40 && j == 27) { // test BOMB
          tiles[i][j] = Tile.BOMB;
        }
        else if(i == 35 && j == 28) { // test bounce
          tiles[i][j] = Tile.BOUNCE; 
        }
        else if(i == 39 && j == 27) {
          tiles[i][j] = Tile.BOMB;
        }
        else if(i == 34 && j == 28) { // test ceiling
          tiles[i][j] = Tile.BLOCK;
        }
        else if(i >= 8 && i <= 20 && j == 18) {
          tiles[i][j] = Tile.BLOCK; 
        }
        else if(i >= 8 && i <= 11 && j == 17) {
          tiles[i][j] = Tile.BLOCK; 
        }
        else if(i >= 16 && i <= 20 && j == 17) {
          tiles[i][j] = Tile.BLOCK; 
        }
        else if(i >= 12 && i <= 15 && j == 17) {
          tiles[i][j] = Tile.WATER; 
        }
        else
          tiles[i][j] = Tile.EMPTY;
      }
    }
  }
  
  public void createLevelOne() {
    for(int i = 0; i < 20; i++) { // birth
      tiles[i][25] = Tile.BLOCK; 
    }
    tiles[12][27] = Tile.BLOCK;
    tiles[13][27] = Tile.BLOCK;
    tiles[3][24] = Tile.BLOCK;
    tiles[6][23] = Tile.BLOCK;
    tiles[6][24] = Tile.BLOCK;
    tiles[9][24] = Tile.BLOCK;
    tiles[12][22] = Tile.BLOCK;
    tiles[12][23] = Tile.BLOCK;
    tiles[12][24] = Tile.BLOCK;
    
    for(int i = 10; i < 13; i++){
        tiles[i][29] = Tile.WATER;
    }
    tiles[13][29] = Tile.BLOCK;
    tiles[9][29] = Tile.BLOCK;
    tiles[12][26] = Tile.GEM;
    tiles[13][26] = Tile.GEM;
    //tiles[19][29] = Tile.BLOCK;
    //tiles[6][29] = Tile.BLOCK;
    
    for(int j = 3; j < 26; j++) { // a column
      tiles[20][j] = Tile.BLOCK; 
    }
    
    for(int i = 14; i < 16; i++) { // a horizontal road
      tiles[i][20] = Tile.BLOCK; 
    }
    
    for(int i = 0; i < 12; i++) { // a horizontal road
      tiles[i][18] = Tile.BLOCK; 
    }
   
    // blocks on the road
    tiles[6][17] = Tile.BLOCK;
    tiles[6][16] = Tile.BLOCK; 
    tiles[5][17] = Tile.WATER;
    tiles[4][17] = Tile.WATER;
    tiles[3][17] = Tile.WATER;
    tiles[2][17] = Tile.BLOCK;
    tiles[2][16] = Tile.BLOCK;
    tiles[1][17] = Tile.WATER;
    tiles[0][17] = Tile.BLOCK;
    tiles[0][16] = Tile.BLOCK; 
    tiles[5][14] = Tile.BLOCK;
    //tiles[6][14] = Tile.BLOCK;
    //tiles[6][15] = Tile.BLOCK;
    
    // a horizontal road
    for(int i = 3; i < 20 ; i++) { // a horizontal road
      tiles[i][5] = Tile.BLOCK; 
    }
    
    for(int i = 3; i < 5; i++) {
      tiles[i][14] = Tile.BLOCK; 
    }
    
    tiles[19][8] = Tile.BLOCK;
    tiles[18][8] = Tile.BLOCK;
    tiles[19][7] = Tile.GEM;
    tiles[5][8] = Tile.MOVINGBLOCK;
    
    tiles[16][3] = Tile.BLOCK;
    tiles[16][4] = Tile.BLOCK;
    for(int i = 17; i < 20; i++) {
      tiles[i][3] = Tile.BOMB; 
      tiles[i][4] = Tile.GEM;
    }
    
    tiles[0][15] = Tile.GEM;
    tiles[13][7] = Tile.GEM;
    tiles[14][6] = Tile.GEM;
    tiles[15][7] = Tile.GEM;
    
      
    for(int j = 0; j < 23; j++) // a column of bl
    {
      tiles[33][j] = Tile.BLOCK;
    }
    
    for(int j = 9; j < 17; j++) // a column of bl
    {
      tiles[32][j] = Tile.GEM;
    }
      
    tiles[32][19] = Tile.BOUNCE;
    
    for(int i = 29; i < 33; i++) {
     
      tiles[i][21] = Tile.WATER;
      tiles[i][22] = Tile.BLOCK; 
    }
    tiles[28][20] = Tile.BLOCK;
    tiles[28][21] = Tile.BLOCK;
    tiles[26][21] = Tile.BLOCK;
    tiles[26][20] = Tile.BLOCK;
    tiles[26][19] = Tile.BLOCK;
    tiles[27][21] = Tile.WATER;
    tiles[27][19] = Tile.GEM;
    
    for(int i = 22; i < 30; i++)
      tiles[i][22] = Tile.BLOCK;
    
    for(int j = 5; j < 19; j++){
      if(j == 8 || j == 9 || j == 14 || j == 13)
        tiles[24][j] = Tile.GEM;
      else
        tiles[24][j] = Tile.BLOCK;
    }
    
    for(int i = 21; i < 24; i++){
      tiles[i][18] = Tile.BLOCK;
      tiles[i][17] = Tile.WATER;
    }
    //tiles[25][18] = Tile.BOMB;
    for(int j = 7; j < 20; j++){
      if(j == 11 || j == 10 || j == 16 || j == 15)
        tiles[28][j] = Tile.GEM;
      else
        tiles[28][j] = Tile.BLOCK;
    }
    
    for(int i = 15; i < 20; i++){
      tiles[i][14] = Tile.BLOCK; 
      tiles[i][12] = Tile.GEM;
    }
    
    // riddle part, have a relax
    for(int i = 27; i < 36; i++)
      tiles[i][29] = Tile.WATER;
    //tiles[25][29] = Tile.BLOCK;
    tiles[36][29] = Tile.BLOCK;
    tiles[36][28] = Tile.BLOCK;
    for(int i = 26; i < 33; i++)
      tiles[i][24] = Tile.BOMB;
    tiles[26][23] = Tile.BOMB;
    
    tiles[31][27] = Tile.GEM;
    tiles[32][26] = Tile.GEM;
    tiles[33][25] = Tile.GEM;
    tiles[34][26] = Tile.GEM;
    tiles[35][27] = Tile.GEM;
    
    tiles[21][29] = Tile.BLOCK;
    for(int i = 22; i < 24; i ++)
      tiles[i][29] = Tile.WATER;
    
    // part 3
    tiles[49][26] = Tile.HITBLOCK;
    for(int i = 40; i < 49; i++)
      tiles[i][26] = Tile.BLOCK;
    tiles[41][25] = Tile.BLOCK;
    tiles[42][25] = Tile.BLOCK;
    for(int i = 36; i < 40; i++) {
      tiles[i][22] = Tile.BLOCK; 
    }
    Monster m4 = new Monster(36, 39, 21, "low");
    monsters.add(m4);
    for(int i = 42; i < 46; i++) {
      tiles[i][19] = Tile.BLOCK; 
    }
    Monster m5 = new Monster(42, 45, 18, "low");
    monsters.add(m5);
    for(int i = 36; i < 40; i++) {
      tiles[i][16] = Tile.BLOCK; 
    }
    Monster m6 = new Monster(36, 39, 15, "low");
    monsters.add(m6);
    //for(int i = 42; i < 46; i++) {
    //  tiles[i][13] = Tile.BLOCK; 
    //}
    //Monster m7 = new Monster(42, 45, 12, "low");
    //monsters.add(m7);
    
    tiles[36][10] = Tile.BOMB;
    tiles[36][8] = Tile.GEM;
    tiles[38][9] = Tile.BOMB;
    tiles[38][7] = Tile.GEM;
    tiles[40][8] = Tile.BOMB;
    tiles[40][6] = Tile.GEM;
    //tiles[41][8] = Tile.BOMB;
    tiles[42][7] = Tile.BOMB;
    tiles[42][5] = Tile.GEM;
    //tiles[43][6] = Tile.BOMB;
    tiles[44][6] = Tile.BOMB;
    tiles[44][4] = Tile.GEM;
    tiles[46][5] = Tile.BOMB;
    tiles[46][3] = Tile.GEM;
    
    tiles[27][25] = Tile.GEM;
    tiles[27][27] = Tile.GEM;
    tiles[28][26] = Tile.GEM;
    tiles[29][25] = Tile.GEM;
    tiles[29][27] = Tile.GEM;
    tiles[30][26] = Tile.GEM;
    tiles[31][25] = Tile.GEM;
    
    //modification
    tiles[23][15] = Tile.BOMB;
    tiles[29][14] = Tile.BOMB;
    for(int i = 0; i < 9; i += 2){
      tiles[i][27] = Tile.GEM;
      if(i != 8)
      tiles[i + 1][27] = Tile.BLOCK;
    }
    tiles[48][26] = Tile.BOUNCE;
    
    
    Monster m1 = new Monster(7, 11, 17, "low");
    monsters.add(m1);
    Monster m2 = new Monster(15, 19, 13, "low");
    monsters.add(m2);
    //Monster m3 = new Monster(22, 25, 21, "low");
    //monsters.add(m3);
    Monster m7 = new Monster(0, 8, 29, "low");
    monsters.add(m7);
    
    Stone st1 = new Stone(27, 23);
    Stone st2 = new Stone(29, 23);
    Stone st3 = new Stone(31, 23);
    Stone st4 = new Stone(25, 29);
    Stone st5 = new Stone(32, 23);
    Stone st6 = new Stone(28, 23);
    Stone st7 = new Stone(30, 23);
    Stone st8 = new Stone(24, 29);
    Stone st9 = new Stone(26, 29);
    Stone st10 = new Stone(11, 29);
    stones.add(st1);
    stones.add(st2);
    stones.add(st3);
    stones.add(st4);
    stones.add(st5);
    stones.add(st6);
    stones.add(st7);
    stones.add(st8);
    stones.add(st9);
    stones.add(st10);
    
    Savepoint sp1 = new Savepoint(5, 12);
    Savepoint sp2 = new Savepoint(20, 1);
    Savepoint sp3 = new Savepoint(20, 28);
    Savepoint sp4 = new Savepoint(49, 24);
    savepoints.add(sp1);
    savepoints.add(sp2);
    savepoints.add(sp3);
    savepoints.add(sp4);
    //savepoints.add(sp5);
    
    for(int ii = 0 ; ii < MAP_WIDTH; ii++) {
      for(int j = 0; j < MAP_HEIGHT; j++) {
        if(tiles[ii][j] == Tile.GEM)
          gemNumber++;
        if(tiles[ii][j] == null)
          tiles[ii][j] = Tile.EMPTY;
       }
    }
    
    println("Gem number: " + gemNumber);
  }
  
  
  public void createLevelTwo() {
    
    // The exit, two vertical columns
    tiles[49][29] = Tile.BOUNCE;
    tiles[43][29] = Tile.BOUNCE;
    for(int j = 29; j > 20; j--)
    {
      tiles[48][j] = Tile.BLOCK;
      tiles[44][j] = Tile.BLOCK;
      if(j % 2 == 1 && j != 29){
        tiles[43][j] = Tile.GEM;
        tiles[49][j] = Tile.GEM;
      }
    }
    tiles[45][21] = Tile.BLOCK;
    tiles[47][23] = Tile.BLOCK;
    tiles[45][25] = Tile.BLOCK;
    tiles[47][27] = Tile.BLOCK;
    
    // the top right corner
    for(int i = 49; i > 36; i--) {
      tiles[i][8] = Tile.BLOCK;
      tiles[i][13] = Tile.BLOCK;
      if(i % 2 == 0){
        tiles[i][11] = Tile.GEM; 
      }
    }
    for(int j = 7; j > 4; j--) {
      tiles[46][j] = Tile.BLOCK;
      tiles[44][j] = Tile.BLOCK;
      tiles[42][j] = Tile.BLOCK;
      tiles[40][j] = Tile.BLOCK;
    }
    tiles[47][7] = Tile.GEM;
    tiles[45][7] = Tile.WATER;
    tiles[43][7] = Tile.GEM;
    tiles[41][7] = Tile.WATER;
    tiles[39][7] = Tile.GEM;
    
    // a slope
    tiles[36][9] = Tile.BLOCK;
    tiles[35][10] = Tile.BLOCK;
    tiles[34][11] = Tile.BOMB;
    tiles[33][12] = Tile.BLOCK;
    
    // two pools in the middle
    for(int i = 32; i > 17; i--){
      if(i == 25)
        tiles[i][15] = Tile.BOMB;
      else
        tiles[i][15] = Tile.BLOCK; 
    }
    for(int j = 14; j > 12; j--){
      tiles[32][j] = Tile.BLOCK;
      tiles[27][j] = Tile.BLOCK;
      tiles[23][j] = Tile.BLOCK;
      tiles[18][j] = Tile.BLOCK;
      if(j == 14){
        tiles[22][j] = Tile.WATER;
        tiles[28][j] = Tile.WATER;
        tiles[21][j] = Tile.WATER;
        tiles[20][j] = Tile.WATER;
        tiles[19][j] = Tile.WATER;
        tiles[31][j] = Tile.WATER;
        tiles[30][j] = Tile.WATER;
        tiles[29][j] = Tile.WATER;
      }
      
    }
    for(int j = 10; j > 8; j--){
      tiles[31][j] = Tile.BLOCK;
      tiles[28][j] = Tile.BLOCK;
      tiles[22][j] = Tile.BLOCK;
      tiles[19][j] = Tile.BLOCK;
    }
    tiles[29][9] = Tile.GEM;
    tiles[30][10] = Tile.GEM;
    tiles[21][10] = Tile.GEM;
    tiles[20][9] = Tile.GEM;
    tiles[29][12] = Tile.BOMB;
    tiles[30][12] = Tile.BOMB;
    tiles[21][12] = Tile.BOMB;
    tiles[20][12] = Tile.BOMB;
    
    // an ice Platform
    for(int i = 23; i < 28; i++){
      tiles[i][7] = Tile.ICE; 
      tiles[i][4] = Tile.GEM; 
    }
    
    // an safe funtion
    for(int i = 32; i > 17; i--){
      tiles[i][17] = Tile.BLOCK; 
    }
    tiles[36][14] = Tile.BLOCK;
    tiles[35][15] = Tile.BLOCK;
    tiles[34][16] = Tile.BLOCK;
    tiles[33][17] = Tile.BLOCK;
    tiles[24][14] = Tile.GEM;
    tiles[26][14] = Tile.GEM;
    tiles[18][16] = Tile.BLOCK;
    tiles[17][17] = Tile.BOUNCE;
    tiles[17][4] = Tile.HITBLOCK;
    
    // another vertical coloumn
    for(int j = 0; j < 14; j++){
      tiles[16][j] = Tile.BLOCK; 
      if(j > 0)
        tiles[6][j + 1] = Tile.BLOCK;
    }
    // another horizontal platform
    for(int i = 16; i > 3; i--){
      tiles[i][17] = Tile.ICE; 
    }
    // go for the golds!
    for(int i = 7; i < 11; i++){
      tiles[i][14] = Tile.BLOCK; 
      tiles[i][6] = Tile.BLOCK;
      if(i != 10)
        tiles[i][2] = Tile.BOMB;
    }
    for(int i = 11; i < 16; i++){
      tiles[i][10] = Tile.BLOCK; 
    }
    Monster m1 = new Monster(7, 10, 13, "low");
    Monster m2 = new Monster(7, 10, 5, "low");
    Monster m3 = new Monster(11, 15, 9, "low");
    monsters.add(m1);
    monsters.add(m2);
    monsters.add(m3);
    for(int i = 13; i < 16; i++){
      tiles[i][3] = Tile.BLOCK;
      for(int j = 0; j < 2; j++){
        tiles[i][j] = Tile.GEM; 
        tiles[i][j+4] = Tile.GEM;
      }
    }
    
    //make a wall
    for(int j = 2; j < 30; j++){
      tiles[0][j] = Tile.BLOCK; 
    }
    // the other side of colomn
    tiles[5][4] = Tile.BLOCK;
    tiles[5][8] = Tile.BLOCK;
    tiles[4][5] = Tile.GEM;
    tiles[3][6] = Tile.GEM;
    tiles[4][7] = Tile.GEM;
    tiles[5][12] = Tile.BLOCK;
    tiles[4][9] = Tile.GEM;
    tiles[3][10] = Tile.GEM;
    tiles[4][11] = Tile.GEM;
    
    tiles[1][17] = Tile.BLOCK;
    
    // a basement
    for(int i = 4; i < 18; i++){
      if(i % 3 == 0)
        tiles[i][18] = Tile.GEM;
      tiles[i][20] = Tile.BLOCK; 
    }
    tiles[18][19] = Tile.BLOCK;
    tiles[18][18] = Tile.BLOCK;
    
    // the extension of level1
    tiles[1][29] = Tile.BOUNCE;
    for(int i = 5; i < 16; i++){
      tiles[i][23] = Tile.BOMB; 
    }
    for(int i = 6; i < 15; i++){
      tiles[i][28] = Tile.WATER; 
      tiles[i][29] = Tile.BLOCK; 
    }
    tiles[5][29] = Tile.BLOCK;
    tiles[15][29] = Tile.BLOCK;
    tiles[5][28] = Tile.BLOCK;
    tiles[15][28] = Tile.BLOCK;
    tiles[5][22] = Tile.BOMB;
    tiles[5][21] = Tile.BOMB;
    tiles[15][22] = Tile.BOMB;
    tiles[15][21] = Tile.BOMB;
    Stone st1 = new Stone(7, 22);
    Stone st2 = new Stone(9, 22);
    Stone st3 = new Stone(11, 22);
    Stone st4 = new Stone(13, 22);
    stones.add(st1);
    stones.add(st2);
    stones.add(st3);
    stones.add(st4);
    
    // add a ice platform
    for(int i = 23; i < 30; i++){
      if(i % 3 == 0)
        tiles[i][22] = Tile.GEM;
      tiles[i][24] = Tile.ICE; 
    }
    
    Savepoint sp1 = new Savepoint(36, 7);
    Savepoint sp2 = new Savepoint(17, 15);
    Savepoint sp3 = new Savepoint(4, 28);
    savepoints.add(sp1);
    savepoints.add(sp2);
    savepoints.add(sp3);
  }
  


  public void changeMovingBlocks() {
    if(level == 2) {
      
      int move_j4 = 27;
      int l4 = 3;
      int leftLimit4 = 17, rightLimit4 = 25;
      int move_j5 = 21;
      int l5 = 4;
      int leftLimit5 = 32, rightLimit5 = 42;
      // if this is level 1
      // let the moving panel come back and forth, every 2 seconds
      // framerate = 80, so count has a limit of 80
      if(moveCount == 40){
        moveCount = 0;
        // 1/4 second had past, move by one block
        if(goLeft4) {
         if(pLeft4 > leftLimit4) {
           tiles[pLeft4 + l4][move_j4] = Tile.EMPTY;
           pLeft4--;
           tiles[pLeft4][move_j4] = Tile.MOVINGBLOCK;
         }
         else {
           tiles[pLeft4][move_j4] = Tile.EMPTY;
           pLeft4++;
           tiles[pLeft4 + l4][move_j4] = Tile.MOVINGBLOCK;
           goLeft4 = false;
         }
        }
        else{
          if(pLeft4 + l4 < rightLimit4) {
           tiles[pLeft4][move_j4] = Tile.EMPTY;
           pLeft4++;
           tiles[pLeft4 + l4][move_j4] = Tile.MOVINGBLOCK;
           }
         else {
           tiles[pLeft4 + l4][move_j4] = Tile.EMPTY;
           pLeft4--;
           tiles[pLeft4][move_j4] = Tile.MOVINGBLOCK;
           goLeft4 = true;
         }
        }
        
        if(goLeft5) {
         if(pLeft5 > leftLimit5) {
           tiles[pLeft5 + l5][move_j5] = Tile.EMPTY;
           pLeft5--;
           tiles[pLeft5][move_j5] = Tile.MOVINGBLOCK;
         }
         else {
           tiles[pLeft5][move_j5] = Tile.EMPTY;
           pLeft5++;
           tiles[pLeft5 + l5][move_j5] = Tile.MOVINGBLOCK;
           goLeft5 = false;
         }
        }
        else{
          if(pLeft5 + l5 < rightLimit5) {
           tiles[pLeft5][move_j5] = Tile.EMPTY;
           pLeft5++;
           tiles[pLeft5 + l5][move_j5] = Tile.MOVINGBLOCK;
           }
         else {
           tiles[pLeft5 + l5][move_j5] = Tile.EMPTY;
           pLeft5--;
           tiles[pLeft5][move_j5] = Tile.MOVINGBLOCK;
           goLeft5 = true;
         }
        }
        
      }
      else
        moveCount++;
    }
    if(level == 1) {
      int move_j1 = 11;
      int l1 = 6;
      int leftLimit1 = 6, rightLimit1 = 19;
      int move_j2 = 8;
      int l2 = 5;
      int leftLimit2 = 0, rightLimit2 = 10;
      int move_j3 = 13;
      int l3 = 3;
      int leftLimit3 = 34, rightLimit3 = 49;
      // if this is level 1
      // let the moving panel come back and forth, every 2 seconds
      // framerate = 80, so count has a limit of 80
      if(moveCount == 40){
        moveCount = 0;
        // 1/4 second had past, move by one block
        if(goLeft1) {
         if(pLeft1 > leftLimit1) {
           tiles[pLeft1 + l1][move_j1] = Tile.EMPTY;
           pLeft1--;
           tiles[pLeft1][move_j1] = Tile.MOVINGBLOCK;
         }
         else {
           tiles[pLeft1][move_j1] = Tile.EMPTY;
           pLeft1++;
           tiles[pLeft1 + l1][move_j1] = Tile.MOVINGBLOCK;
           goLeft1 = false;
         }
        }
        else{
          if(pLeft1 + l1 < rightLimit1) {
           tiles[pLeft1][move_j1] = Tile.EMPTY;
           pLeft1++;
           tiles[pLeft1 + l1][move_j1] = Tile.MOVINGBLOCK;
           }
         else {
           tiles[pLeft1 + l1][move_j1] = Tile.EMPTY;
           pLeft1--;
           tiles[pLeft1][move_j1] = Tile.MOVINGBLOCK;
           goLeft1 = true;
         }
        }
        
        if(goLeft2) {
         if(pLeft2 > leftLimit2) {
           tiles[pLeft2 + l2][move_j2] = Tile.EMPTY;
           pLeft2--;
           tiles[pLeft2][move_j2] = Tile.MOVINGBLOCK;
         }
         else {
           tiles[pLeft2][move_j2] = Tile.EMPTY;
           pLeft2++;
           tiles[pLeft2 + l2][move_j2] = Tile.MOVINGBLOCK;
           goLeft2 = false;
         }
        }
        else{
          if(pLeft2 + l2 < rightLimit2) {
           tiles[pLeft2][move_j2] = Tile.EMPTY;
           pLeft2++;
           tiles[pLeft2 + l2][move_j2] = Tile.MOVINGBLOCK;
           }
         else {
           tiles[pLeft2 + l2][move_j2] = Tile.EMPTY;
           pLeft2--;
           tiles[pLeft2][move_j2] = Tile.MOVINGBLOCK;
           goLeft2 = true;
         }
        }
        
        if(goLeft3) {
         if(pLeft3 > leftLimit3) {
           tiles[pLeft3 + l3][move_j3] = Tile.EMPTY;
           pLeft3--;
           tiles[pLeft3][move_j3] = Tile.MOVINGBLOCK;
         }
         else {
           tiles[pLeft3][move_j3] = Tile.EMPTY;
           pLeft3++;
           tiles[pLeft3 + l3][move_j3] = Tile.MOVINGBLOCK;
           goLeft3 = false;
         }
        }
        else{
          if(pLeft3 + l3 < rightLimit3) {
           tiles[pLeft3][move_j3] = Tile.EMPTY;
           pLeft3++;
           tiles[pLeft3 + l3][move_j3] = Tile.MOVINGBLOCK;
           }
         else {
           tiles[pLeft3 + l3][move_j3] = Tile.EMPTY;
           pLeft3--;
           tiles[pLeft3][move_j3] = Tile.MOVINGBLOCK;
           goLeft3 = true;
         }
        }
      }
      else
        moveCount++;
    }
  }
  
  public void drawMap() {
     changeMovingBlocks();
     for(int i = 0; i < MAP_WIDTH; i++) {
      for(int j = 0; j < MAP_HEIGHT; j++){
        PVector pos = getTilePosition(i, j);
        if(tiles[i][j] == Tile.BLOCK){
          stroke(0);
          strokeWeight(5);
          //stroke(255);
          fill(255, 10, 30, 90);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE);
        }
        else if(tiles[i][j] == Tile.HITBLOCK){
          noStroke();
          //stroke(255);
          fill(#008B00);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE);
        }
        else if(tiles[i][j] == Tile.MOVINGBLOCK) {
          strokeWeight(1);
          stroke(255);
          fill(#000fff);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE);
        }
        else if(tiles[i][j] == Tile.ICE) {
          strokeWeight(5);
          stroke(255);
          fill(#0000ff);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE);
        }
        else if(tiles[i][j] == Tile.WATER) {
          noStroke();
          fill(#00ccff);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE);
        }
        else if(tiles[i][j] == Tile.BOUNCE) {
          noStroke();
          //stroke(255);
          fill(0);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE, 10);
        }
        else if(tiles[i][j] == Tile.BOMB) {
          strokeWeight(1);
          stroke(0);
          fill(255, 0, 0);
          rect(pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE, 5);
        }
        else if(tiles[i][j] == Tile.GEM) {
          imageMode(CORNER);
          image(pinkGem, pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE); 
        }
        else if(tiles[i][j] == Tile.POWERGEM) {
          imageMode(CORNER);
          image(powerGem, pos.x, pos.y, Tile.TILE_SIZE, Tile.TILE_SIZE); 
        }
      }
    }
    
    for(Monster m: monsters)
      m.drawMonster();
      
    for(Stone st: stones)
      st.drawStone();
      
    for(Savepoint sp: savepoints)
      sp.drawSavepoint();
      
    exit.drawExit();
  }
  
  public void update() {
    checkBombs();
    hasGround(player.oldPosition, player.position, player.speed);
    hasCeiling(player.oldPosition, player.position, player.speed);
    pushesRightWall(player.oldPosition, player.position, player.speed);
    pushesLeftWall(player.oldPosition, player.position, player.speed);
  }
  
  public Exit getExit() {
    return exit; 
  }
}