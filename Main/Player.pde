class Player extends MovingObject{
  
  public int halfWidth = 5, halfHeight = 10;
  protected boolean[] inputs;
  protected boolean[] prevInputs;
  private PlayerState currentState;
  public float jump_speed = 3.0f;  //2.0
  public float walk_speed = 3.0f;  //2.0
  public float DOUBLE_JUMP_SPEED = 4.0f; // 3.2
  public float JUMP_HORIZONTAL_SPEED = 1.0f;
  public float gravity = .15f; // 0.1f
  public PShape playerShape;
  public final float ICE_INERTIA = .03f;
  public boolean doubleJumped = false;
  public int doubleJumpedCount = 0;
  public int score = 0;
  public final float BOUNCE_SPEED = 8.0f;
  public boolean powered = false;
  public int currentCount = -1;
  Savepoint birthPoint, birthPoint2;
  public int lives = 3;
  Player(){
    super();
    
    inputs = new boolean[4];
    prevInputs = new boolean[4];
    for(int i = 0; i < 4; i++){
      inputs[i] = false;
      prevInputs[i] = false;
    }
    currentState = PlayerState.STAND;
    
    birthPoint = new Savepoint(0, 23);
    birthPoint2 = new Savepoint(48, 6);
    position = birthPoint.getPosition();
    setCenter();
    //playerShape = createShape(RECT, position.x, position.y, position.x + 2 * halfWidth, position.y + 2 * halfHeight);
  }
  
  public void setCenter(){
    oldPosition = position.copy();
    AABBOffset = new PVector(halfWidth, halfHeight);
    PVector center = position.copy().add(AABBOffset);
    mAABB = new AABB(center, halfWidth, halfHeight);
  }
  
  public void integrate() {

    switch(currentState) {
      case STAND: {
        speed = new PVector(0, 0);
        if(!onGround){
          currentState = PlayerState.JUMP; 
          break;
        }
        
        if(onBounce) {
          currentState = PlayerState.JUMP; 
        }
        
        if(keyState(KeyInput.GOLEFT) != keyState(KeyInput.GORIGHT)){
          currentState = PlayerState.WALK;
          break;
        }
        else if(keyState(KeyInput.JUMPUP)){
          speed.y = - jump_speed;
          currentState = PlayerState.JUMP;
          break;
        }
      }
      break;
      case WALK: {
        if(!onGround){
          currentState = PlayerState.JUMP; 
          break;
        }
        
        if(onBounce) {
          currentState = PlayerState.JUMP; 
        }
        
        if(keyState(KeyInput.GOLEFT) == keyState(KeyInput.GORIGHT)){
          if(!onIce) {
            speed.x = 0;
            currentState = PlayerState.STAND;
            break;
          }
          else {
            println("I'm on ice now");
            // do nothing
            currentState = PlayerState.SLIDE;
            break;
          }
        }
        else if (keyState(KeyInput.GORIGHT))
        {
          //if(!pushesLeftWall)
            speed.x = walk_speed;
        }
        else if (keyState(KeyInput.GOLEFT))
        {
          //if(!pushesRightWall) 
            speed.x = - walk_speed;
          
        }
        
        if(keyState(KeyInput.JUMPUP)){
          speed.y = - jump_speed;
          currentState = PlayerState.JUMP;
          break;
        }
      }
      break;
      case JUMP: {
        if(onBounce) {
          speed.y = -BOUNCE_SPEED; 
          onBounce = false;
          break;
        }
        
        if(onGround){
          speed.y = 0;
          currentState = PlayerState.STAND;
          break;
        }
        
        speed.y += gravity;
        if(keyState(KeyInput.GOLEFT) == keyState(KeyInput.GORIGHT)){
          speed.x = 0;
        }
        else if (keyState(KeyInput.GORIGHT))
        {
            speed.x = JUMP_HORIZONTAL_SPEED;
        }
        else if (keyState(KeyInput.GOLEFT))
        {
            speed.x = - JUMP_HORIZONTAL_SPEED;
        }
        
        if(pressed(KeyInput.JUMPUP)){
          // enter DOUBLEJUMP
          speed.y = - DOUBLE_JUMP_SPEED;
          doubleJumped = true;
          currentState = PlayerState.DOUBLEJUMP;
          break;
        }
      }
      break;
      case DOUBLEJUMP: {
        if(onGround){
          speed.y = 0;
          currentState = PlayerState.STAND;
          break;
        }
        
        speed.y += gravity;
        if(keyState(KeyInput.GOLEFT) == keyState(KeyInput.GORIGHT)){
          speed.x = 0;
        }
        else if (keyState(KeyInput.GORIGHT))
        {
            speed.x = JUMP_HORIZONTAL_SPEED;
        }
        else if (keyState(KeyInput.GOLEFT))
        {
            speed.x = - JUMP_HORIZONTAL_SPEED;
        }
      }
      break;
      case SLIDE: {
        
        if(!onGround){
          currentState = PlayerState.JUMP; 
          break;
        }
        
        if(keyState(KeyInput.GOLEFT) != keyState(KeyInput.GORIGHT)){
          currentState = PlayerState.WALK;
          break;
        }
        else if(keyState(KeyInput.JUMPUP)){
          speed.y = - jump_speed;
          currentState = PlayerState.JUMP;
          break;
        }
        
        if(speed.x < 0) {
          if(speed.x + ICE_INERTIA <= 0)
            speed.x += ICE_INERTIA;
          else {
            speed.x = 0;
            currentState = PlayerState.STAND;
          }
        }
        else if (speed.x > 0) {
          if(speed.x - ICE_INERTIA >= 0)
            speed.x -= ICE_INERTIA;
          else {
            speed.x = 0;
            currentState = PlayerState.STAND;
          }
        }
        else {
          currentState =  PlayerState.STAND;
        }
          
      }
      break;
      case GRABLEDGE:
      break;
    }
    
    updatePhysics();
    updatePrevInputs();
    detectMonster();
    detectSavepoints();
    detectExit();
    drawPlayer();
  }
  
  public void updatePhysics() {
    super.integrate(); // update booleans and position
    if(currentState == PlayerState.JUMP)
      println("Position: " + position);
  }
  
  public void updatePrevInputs() {
    for(int i = 0; i < 4; i++){
      prevInputs[i] = inputs[i];
    }
  }
  
  public void detectMonster() {
    for(int i = 0; i < currentMap.getMonsters().size(); i++) {
      //detect whether the player had collided with it 
      PVector playerCenter = player.position.copy().add(new PVector(halfWidth, halfHeight));
      PVector monsterCenter = currentMap.getMonsters().get(i).getPosition().copy().add(0.5 * Tile.TILE_SIZE, 0.5 * Tile.TILE_SIZE);
      if(playerCenter.copy().sub(monsterCenter).mag() <= 0.5 * Tile.TILE_SIZE + 0.5 * (halfWidth + halfHeight))
      {
        if(playerCenter.y <= monsterCenter.y - 0.5 * Tile.TILE_SIZE - 0.2 * halfHeight && player.powered)
          {
            println("Player killed the monster!");
            println("playerCenter.y = " + playerCenter.y + 
            "monsterCneter");
            
            speed.y = -jump_speed;
            Stone newStone = new Stone((int)currentMap.getMonsters().get(i).getPosition().x / Tile.TILE_SIZE, 
            (int)currentMap.getMonsters().get(i).getPosition().y / Tile.TILE_SIZE);
            currentMap.stones.add(newStone);
            currentMap.monsters.remove(i);
          }
        else{
          lives--;
          position = lastSavepoint();
          println("Player is killed by a monster!"); 
        }
      }
      
    }
  }
  
  public void detectSavepoints() {
    for(int i = 0; i < currentMap.savepoints.size(); i++){
      Savepoint sp = currentMap.savepoints.get(i);
      if(position.x >= (sp.getXY().x - 0.5) * Tile.TILE_SIZE 
      && position.x <= (sp.getXY().x + 1) * Tile.TILE_SIZE 
      && position.y >= (sp.getXY().y - 0.5) * Tile.TILE_SIZE
      && position.y <= (sp.getXY().y + 2) * Tile.TILE_SIZE) {
        if(i > currentCount){
          currentCount++; 
          sp.saved = true;
          for(int j = 0; j < i; j++)
            currentMap.savepoints.get(j).saved = true;
        }
      }
    }
    
  }
  
  
  public void detectExit() {
    Exit e = currentMap.getExit();
    if(currentMap == maps[0] || currentMap.equals( maps[0] )){
      if(position.copy().sub(e.getPosition().copy()).mag() <= e.EXIT_SIZE + halfWidth){
        //if(powered)
        
          powered = false;
          halfWidth = 5;
          halfHeight = 10;
          player.setCenter();
        currentMap = maps[1];
        currentCount = -1;
        //player.position.set(birthPoint2.getPosition());
      }
    }
    else{
      if(position.copy().sub(e.getPosition().copy()).mag() <= e.EXIT_SIZE + halfWidth){

          passTime = (millis() - startTime) / 1000;
          win = true;
          
      }
    }
    if(lives == 0) {
      fail = true; 
    }
  }
  
  public PVector lastSavepoint() {
    if(currentCount == -1)
    {
      if(currentMap == maps[0] || currentMap.equals( maps[0] ))
      {
        
      return birthPoint.getPosition();
      }
      else
        
      return birthPoint2.getPosition();
    }
    
    return currentMap.savepoints.get(currentCount).getPosition();
  }
  
  protected boolean released(KeyInput key)
  {
      return (!inputs[key.index()] && prevInputs[key.index()]);
  }
   
  protected boolean keyState(KeyInput key)
  {
      return (inputs[key.index()]);
  }
   
  protected boolean pressed(KeyInput key)
  {
      return (inputs[key.index()] && !prevInputs[key.index()]);
  }
  
  public void setPosition(float x, float y) {
    position.set(x, y); 
  }
  
  public void setCurrentState(PlayerState s) {
    currentState = s;
  }
  
   public void drawPlayer() {
    //fill(0, 120, 60);
    //rect(position.x, position.y, 2 * halfWidth, 2 * halfHeight);
    switch(currentState) {
     case STAND:
     imageMode(CORNER);
     image(standMario, position.x, position.y, 2 * halfWidth, 2 * halfHeight);
     break;
     case WALK:  
     imageMode(CORNER);
     image(walkMario, position.x, position.y, 2 * halfWidth, 2 * halfHeight);
     break;
     case JUMP:  
     if(doubleJumped){
       doubleJumpedCount++;
       // draw a angle
       translate(position.x + halfWidth, position.y + halfHeight);
       rotate(doubleJumpedCount / 15.0 * PI);
       imageMode(CENTER);
       image(jumpMario, 0, 0, 2 * halfWidth, 2 * halfHeight);
       if(doubleJumpedCount == 15){
         doubleJumpedCount = 0;
         doubleJumped = false;
       }
     }
     else{
       imageMode(CORNER);
       image(jumpMario, position.x, position.y, 2 * halfWidth, 2 * halfHeight);
     }
     break;
     case DOUBLEJUMP:
     if(doubleJumped){
       doubleJumpedCount++;
       // draw a angle
       translate(position.x + halfWidth, position.y + halfHeight);
       if(speed.x > 0)
         rotate(doubleJumpedCount / 15.0* PI);
       else
         rotate(doubleJumpedCount / -15.0* PI);
       imageMode(CENTER);
       image(jumpMario, 0, 0, 2 * halfWidth, 2 * halfHeight);
       if(doubleJumpedCount == 15){
         doubleJumpedCount = 0;
         doubleJumped = false;
       }
     }
     else
     {
       imageMode(CORNER);
       image(jumpMario, position.x, position.y, 2 * halfWidth, 2 * halfHeight);
     }
     break;
     default:
     imageMode(CORNER);
     image(standMario, position.x, position.y, 2 * halfWidth, 2 * halfHeight);
     break;
    }
  }
}


public enum PlayerState
{
  STAND,
  WALK,
  JUMP,
  DOUBLEJUMP,
  GRABLEDGE,
  SLIDE;
  
  private PlayerState() {
  }
}



public enum KeyInput
{
  GOLEFT(0),
  GORIGHT(1),
  GODOWN(2),
  JUMPUP(3);
  
  private int index;
  private KeyInput(int i) {
    index = i;
  }
  
  public int index() {
    return index;
  }
}
