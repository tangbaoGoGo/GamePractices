abstract class MovingObject {
  
  public PVector position;
  public PVector speed;
  
  public PVector oldPosition;
  public PVector oldSpeed;
  public PVector scale;
  
  public AABB mAABB;
  public PVector AABBOffset;
  
  public boolean pushedRightWall;
  public boolean pushesRightWall;
  public boolean pushedLeftWall;
  public boolean pushesLeftWall;
  
  public boolean wasOnGround;
  public boolean onGround;
  public boolean wasAtCeiling;
  public boolean atCeiling;
  public boolean onIce;
  public boolean onBounce;
  public boolean onBomb;
  public final float ICE_INERTIA = .2f;
  
  
  MovingObject() {
    // subclass only need to define mAABB
    position = new PVector(0, 0);
    speed = new PVector(0, 0);
    mAABB = new AABB();
    AABBOffset = new PVector(0, 0);
    
    pushedRightWall = false;
    pushesRightWall = false;
    pushedLeftWall = false;
    pushesLeftWall = false;
    
    wasOnGround = false;
    onGround = true;
    wasAtCeiling = false;
    atCeiling = false;
    onIce = false;
    onBounce = false;
    onBomb = false;
  }
  
  MovingObject(PVector init_pos, int halfWidth, int halfHeight) {
    position = init_pos;
    speed = new PVector(0, 0);
  }
  
  public void integrate() {
    oldPosition = position.copy();
    oldSpeed = speed.copy();
    pushedRightWall = pushesRightWall;
    pushedLeftWall = pushesLeftWall;
    wasOnGround = onGround;
    wasAtCeiling = atCeiling;
    
    position.add(speed);
    
    // move mAABB 
    mAABB.center = position.copy().add(AABBOffset);
  }
  
  
}