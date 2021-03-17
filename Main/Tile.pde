public enum Tile
{
  EMPTY,
  BLOCK,
  BOUNCE,
  ICE,
  WATER,
  BOMB,
  MOVINGBLOCK,
  GEM,
  POWERGEM,
  HITBLOCK;
  
  public static final int TILE_SIZE = 20;
  public int b1, b2; // left, right, top, bottom boundary
  //private int triggeredTime;
  //private int bi, bj;
  private Tile() {
     
  }
  
  /*public void setTriggeredTime(int t) {
  }
  
  public int getTriggeredTime() {
  }
  
  public void setPosition(int i, int j) {

  }
  
  public PVector getPosition() {
  }*/
}

class Bomb {
  
  private int bi, bj;
  private int t0;
  public static final int EXPLOSION_WAIT = 500; // 500 milliseconds
  public static final int REGENERATION_WAIT = 3000; 
  boolean exploded;
  boolean regenerated;
  
  Bomb(int i, int j, int t) {
    bi = i;
    bj = j;
    t0 = t;
    exploded = false;
    regenerated = false;
  }
  
  public boolean timeToExplode(int t) {
    if(t - t0 >= 500 && !exploded)
    {
      exploded = true;
      return true;
    }
    
    return false;
  }
  
  public boolean timeToRegenerate(int t) {
    if(t - t0 >= 3500 && exploded)
    {
      regenerated = true; 
      return true;
    }
    
    return false;
  }
  
  public boolean formation(int t) {
    if(t - t0 >= 1500 && exploded && !regenerated) {
        return true;
    }
    
    return false;
  }
  
  public PVector getIndex() {
    return new PVector(bi, bj); 
  }
  
  public void setExploded() {
    exploded = true; 
  }
  
  public PVector getPosition() {
    return new PVector(bi * Tile.TILE_SIZE, bj * Tile.TILE_SIZE);
  }
  
  public int transparency(int t) {
    return int((t - t0 - 1500) / 2000.0 * 100); 
  }
}