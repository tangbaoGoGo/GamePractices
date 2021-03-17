class Monster {
  
  private int startIndex, endIndex, jIndex;
  private PVector position, speed;
  private float leftBoundary, rightBoundary;
  
  public final float MONSTER_LOW_SPEED = .5f;
  public final float MONSTER_HIGH_SPEED = 2.0f;
  
  Monster(int si, int ei, int ji, String s) {
    startIndex = si;
    endIndex = ei;
    jIndex = ji;
    leftBoundary = startIndex * Tile.TILE_SIZE;
    rightBoundary = (endIndex + 0.5) * Tile.TILE_SIZE;
    position = new PVector(leftBoundary, jIndex * Tile.TILE_SIZE);
    if(s == "low" || s.equals("low"))
      speed = new PVector(MONSTER_LOW_SPEED, 0);
    else
      speed = new PVector(MONSTER_HIGH_SPEED, 0);
  }
  
  public void integrate() {
    position.add(speed);
    
    if(position.x <= leftBoundary || position.x >= rightBoundary)
      speed.x = - speed.x;
  }
  
  //public void setSpeed(float s) {
  //  speed
  //}
  
  public PVector getPosition() {
    return position; 
  }
  
  public void drawMonster() {
    integrate();
    
    noStroke();
    //strokeWeight(5);
    fill(#4B0082);
    ellipse(position.x + Tile.TILE_SIZE / 2, position.y + Tile.TILE_SIZE / 2, Tile.TILE_SIZE, Tile.TILE_SIZE);
  }
}