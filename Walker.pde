public class Walker {
  float x, y;
  float dx, dy;
  PImage[] walkingSprites;
  PImage stationarySprite;
  boolean walking;
  int walkingCounter;
  
  public Walker() { }
  
  public Walker(float x, float y, PImage[] walkingSprites, PImage stationarySprite) {
    this.x = x;
    this.y = y;
    this.walkingSprites = walkingSprites;
    this.stationarySprite = stationarySprite;
  }
  
  void update() {
    if(walking) {
      walkingCounter = (walkingCounter + 1) % walkingSprites.length;
      x += dx;
    }
  }
  
  void display() {
    if(walking) image(walkingSprites[walkingCounter],x,y,walkingSprites[walkingCounter].width, walkingSprites[walkingCounter].height);
    else image(stationarySprite, x, y);
  }
}
