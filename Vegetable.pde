public class Vegetable {
  float x;
  float y;
  float dx=5;
  float dy;
  float g = 0.02;
  float attack;
  PImage image;
  
  public Vegetable(PImage image, float x, float y, float attack) {
    this.x = x;
    this.y = y;
    this.image = image;
    this.attack = attack;
  }
  
  public void update() {
    dy = dy+g;
    x = x+dx;
    y = y+dy;
  }
  
  public void display() {
    image(image, x,y);
  }

}
  
  
