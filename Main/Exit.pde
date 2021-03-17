class Exit {
  PVector position;
  public final int EXIT_SIZE = 20;
  
  Exit(PVector pos){
    position = pos;
  }
  
  public PVector getPosition() {
    return position; 
  }

  public void drawExit() {
    fill(#88FF00);
    ellipse(position.x, position.y, EXIT_SIZE, EXIT_SIZE);
  }
}