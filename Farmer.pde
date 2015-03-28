class Farmer extends Walker {
  PImage farmerSquatting;
  PImage[] farmerThrowing;
  boolean throwing;
  int throwingCounter;
  boolean squatting;
  

  public Farmer(float x, float y, PImage[] walkingSprites, PImage stationarySprite) {
    this.x = x;
    this.y = y;
    this.walkingSprites = walkingSprites;
    this.stationarySprite = stationarySprite;
    farmerSquatting = null;
    farmerThrowing = new PImage[0];
  }

  void update() {
    if(walking) {
      walkingCounter = (walkingCounter + 1) % walkingSprites.length;
      x += dx;
    } else if(throwing) {
      throwingCounter++;
      if(throwingCounter > 9)
      throwing = false;
    }
  }
  
  void throwVegetable() {
    throwing = true;
    throwingCounter = 0;
  }

  void display() {
    if(walking) image(walkingSprites[walkingCounter],x,y);
    else if (squatting) image(farmerSquatting,x,y+25);
    else if (throwing) image(farmerThrowing[throwingCounter / 5], x, y);
    else image(stationarySprite, x, y);
  }
}
