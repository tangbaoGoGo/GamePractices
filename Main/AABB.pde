class AABB {
  // AABB - Axis Aligned Bounding Box
 public PVector center;
 public int halfWidth, halfHeight;
 
 AABB() {
   
 }
 
 AABB(PVector center, int halfWidth, int halfHeight) {
   this.center = center;
   this.halfWidth = halfWidth;
   this.halfHeight = halfHeight;
 }
 
 // for horizontal or vertical aligned AABBs
 public boolean Overlaps(AABB other) {
   if(Math.abs(center.x - other.center.x) < halfWidth + other.halfWidth)
   return true;
   if(Math.abs(center.y - other.center.y) < halfHeight + other.halfHeight)
   return true;
   
   return false;
 }
 
 public void setCenter(PVector center) {
   this.center = center;
 }
 
}