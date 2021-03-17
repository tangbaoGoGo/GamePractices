class Savepoint {
  private int pointi, pointj;
  public boolean saved;
  Savepoint(int i0, int j0) {
    pointi = i0;
    pointj = j0;
    saved =false;
  }
  
  public void drawSavepoint() {
    if(saved){
       stroke(255, 10, 30);
    fill(0);
    line(pointi * Tile.TILE_SIZE, pointj * Tile.TILE_SIZE, pointi * Tile.TILE_SIZE, (pointj + 2) * Tile.TILE_SIZE);
    line(pointi * Tile.TILE_SIZE, pointj * Tile.TILE_SIZE, (pointi + 1) * Tile.TILE_SIZE, (pointj + 0.5) * Tile.TILE_SIZE);
    line(pointi * Tile.TILE_SIZE, (pointj + 0.5)* Tile.TILE_SIZE, (pointi + 1) * Tile.TILE_SIZE, (pointj + 0.5) * Tile.TILE_SIZE);
    }
    else{
       stroke(0);
    fill(0);
    line(pointi * Tile.TILE_SIZE, pointj * Tile.TILE_SIZE, pointi * Tile.TILE_SIZE, (pointj + 2) * Tile.TILE_SIZE);
    line(pointi * Tile.TILE_SIZE, pointj * Tile.TILE_SIZE, (pointi + 1) * Tile.TILE_SIZE, (pointj + 0.5) * Tile.TILE_SIZE);
    line(pointi * Tile.TILE_SIZE, (pointj + 0.5)* Tile.TILE_SIZE, (pointi + 1) * Tile.TILE_SIZE, (pointj + 0.5) * Tile.TILE_SIZE);
    }
    //noStroke();
   
  }
  
  public PVector getXY(){
    return new PVector(pointi, pointj);
  }
  
  public PVector getPosition() {
    return new PVector(pointi * Tile.TILE_SIZE, pointj * Tile.TILE_SIZE); 
  }
}