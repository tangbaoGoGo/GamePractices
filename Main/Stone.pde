class Stone {
  private PVector position;
  private PVector speed;
  public final float STONE_VERTICAL_SPEED = 5.0f;
 // private int init_i, init_j;
  public boolean onGround = true;
  
  
  Stone(int ii, int ij) {

    position = new PVector(ii * Tile.TILE_SIZE, ij * Tile.TILE_SIZE);
    speed = new PVector(0, STONE_VERTICAL_SPEED);
  }
  
  Stone(PVector pos) {
    position = pos;
    speed = new PVector(0, STONE_VERTICAL_SPEED);
  }
  
  public PVector getPosition() {
    return position; 
  }
  
  public void integrate() {
    PVector bottomPos = position.copy().add(new PVector(0.5 * Tile.TILE_SIZE, Tile.TILE_SIZE));
    int gi, gj;
    gi = (int)currentMap.tileAtPoint(bottomPos).x;
    gj = (int)currentMap.tileAtPoint(bottomPos).y;
    //println("(gi, gj) = " + "(" + gi + "," + gj + ")");
    //println(currentMap.tileAtPoint(bottomPos));
    if(currentMap.isObstacle(gi, gj)){
      onGround = true;
    }
    else
      onGround = false;
      
    if(onGround){
      // detect whether ground is still there
      position.y = (gj - 1) * Tile.TILE_SIZE;
    }
    else{
      position.add(speed);
    } 
  }
  
  public void drawStone() {
    // if onGround, do nothing
    integrate();
    stroke(0);
    strokeWeight(5);
    fill(#8C8C8C);
    rect(position.x, position.y, Tile.TILE_SIZE, Tile.TILE_SIZE);
    // if not, find the nearest ground and move to it by speed
  }
}