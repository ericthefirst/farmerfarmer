Farmer farmer;
PImage farmerStationary;
PImage[] farmerWalking;
PImage farmerSquatting;
PImage[] farmerThrowing;

PImage ronaldStationary;
PImage[] ronaldWalking;
Walker[] ronalds;
int gonnaDelete = -1;
Vegetable[] veggies;
PImage tomato;
float playerX = 100;
PFont hfont = createFont("Helvetica", 48);
boolean waitingToThrow;

void setup() {
  size(1000,400);
  farmerStationary = loadImage("data/farmerStationary.png");
  farmerWalking = new PImage[4];
  farmerWalking[0] = loadImage("data/farmerWalking1.png");
  farmerWalking[1] = farmerStationary;
  farmerWalking[2] = loadImage("data/farmerWalking2.png");
  farmerWalking[3] = farmerStationary;
  farmer = new Farmer(100, height/2+28, farmerWalking, farmerStationary);
  farmer.farmerSquatting = loadImage("data/farmerSquatting.png");
  farmer.farmerThrowing = new PImage[2];
  farmer.farmerThrowing[0] = loadImage("data/farmerThrowing1.png");
  farmer.farmerThrowing[1] = loadImage("data/farmerThrowing2.png");
  
  textFont(hfont);
  fill(0);
  tomato = loadImage("data/tomato.png");
  ronaldStationary = loadImage("data/RonaldStationary.png");
  ronaldWalking = new PImage[4];
  ronaldWalking[0] = loadImage("data/RonaldWalking1.png");
  ronaldWalking[1] = ronaldStationary;
  ronaldWalking[2] = loadImage("data/RonaldWalking2.png");
  ronaldWalking[3] = ronaldStationary;
  ronalds = new Walker[3];
  for(int i = 0; i < 3; i++) {
    ronalds[i] = new Walker(width/4*(i+1),height/2,ronaldWalking, ronaldStationary);
    ronalds[i].walking = true;
    ronalds[i].dx = -3;
  }
  frameRate(20);
  veggies = new Vegetable[0];
}

void draw() {
  if(ronalds.length == 0) win();
  else {
    testForCollisions();
    background(255);
    farmer.update();
    farmer.display();
    for(int i = 0; i < ronalds.length; i++) {
      ronalds[i].update();
      ronalds[i].display();
      if(ronalds[i].x < -100) {
        gonnaDelete = i;
      }
      if(gonnaDelete != -1) {
        deleteRonald(gonnaDelete);
        gonnaDelete = -1;
        addRonald(width);
      }
    }
    for(int i = 0; i < veggies.length; i++) {
      veggies[i].update();
      veggies[i].display();
      if(veggies[i].y > height || veggies[i].x > width || veggies[i].x < 0)
        gonnaDelete = i;
    }
    if(gonnaDelete != -1) {
      deleteVegetable(gonnaDelete);
      gonnaDelete = -1;
    }
  }
}
 

void addRonald(float x) {
  if(ronalds.length < 8) {
   ronalds = (Walker[])expand(ronalds,ronalds.length+1);
   ronalds[ronalds.length-1] = new Walker(x,height/2,ronaldWalking, ronaldStationary);
   ronalds[ronalds.length-1].dx = -3;
   ronalds[ronalds.length-1].walking = true;
  } 
}

void deleteRonald(int i) {
  if(i >= ronalds.length) return;
  for(int j = i; j < ronalds.length-1; j++)
    ronalds[j] = ronalds[j+1];
  ronalds = (Walker[])expand(ronalds, ronalds.length-1);
}

void addVegetable() {
  veggies = (Vegetable[])expand(veggies, veggies.length+1);
  veggies[veggies.length-1] = new Vegetable(tomato, playerX+60, height/2+30, 10);
}

void deleteVegetable(int i) {
  if(i >= veggies.length) return;
  for(int j = i; j < veggies.length-1; j++)
    veggies[j] = veggies[j+1];
  veggies = (Vegetable[])expand(veggies, veggies.length-1);
}

void testForCollisions() {
  int veggieToDelete = -1;
  int ronaldToDelete = -1;
  for(int i = 0; i < veggies.length; i++) {
    for(int j = 0; j < ronalds.length; j++) {
      if(rectanglesIntersect(
        veggies[i].x, veggies[i].y, veggies[i].x+veggies[i].image.width, veggies[i].y+veggies[i].image.height,
        ronalds[j].x, ronalds[j].y, ronalds[j].x+ronalds[j].stationarySprite.width, ronalds[j].y+ronalds[j].stationarySprite.height)) {
        veggieToDelete = i;
        ronaldToDelete = j;
      }
    }
  }
  if(veggieToDelete != -1) {
    deleteVegetable(veggieToDelete);
    deleteRonald(ronaldToDelete);
  }
}
        
      
      
      
boolean withinRectangle(float x, float y, float x1, float y1, float x2, float y2) {
  if(x1 > x2)
    return withinRectangle(x,y,x2,y1,x1,y2);
  if(y1 < y2)
    return withinRectangle(x,y,x1,y2,x2,y1);
  return (x <= x2 && x >= x1 && y >= y1 && y <= y2);
}

boolean vEdgeThrough(float x, float y1, float y2, float a1, float b1, float a2, float b2) {
  if(y1 > y2) return vEdgeThrough(x, y2, y1, a1, b1, a2, b2);
  if(a1 > a2) return vEdgeThrough(x, y1, y2, a2, b1, a1, b2);
  if(b1 > b2) return vEdgeThrough(x, y1, y2, a1, b2, a2, b1);
  
  if(x <= a2 && x >= a1)
   return (y1 <= b1 && y2 >= b2);
  
  return false;
} 

boolean hEdgeThrough(float x1, float x2, float y, float a1, float b1, float a2, float b2) {
  if(x1 < x2) return vEdgeThrough(x2, x1, y, a1, b1, a2, b2);
  if(a1 > a2) return vEdgeThrough(x1, x2, y, a2, b1, a1, b2);
  if(b1 > b2) return vEdgeThrough(x1, x2, y, a1, b2, a2, b1);
  
  if(y <= b2 && y >= b1)
   return (x1 <= a1 && x2 >= a2);
  
  return false;
} 


boolean rectanglesIntersect(float x1, float y1, float x2, float y2, float a1, float b1, float a2, float b2) {
  if(withinRectangle(x1,y1,a1,b1,a2,b2) ||
    withinRectangle(x2,y1,a1,b1,a2,b2) ||
    withinRectangle(x1,y2,a1,b1,a2,b2) ||
    withinRectangle(x2,y2,a1,b1,a2,b2)) return true;
  if(withinRectangle(a1,b1,x1,y1,x2,y2) ||
    withinRectangle(a2,b1,x1,y1,x2,y2) ||
    withinRectangle(a1,b2,x1,y1,x2,y2) ||
    withinRectangle(a2,b2,x1,y1,x2,y2)) return true;
  if(vEdgeThrough(x1, y1, y2, a1, b1, a2, b2) ||
     vEdgeThrough(x2, y1, y2, a1, b1, a2, b2) ||
     vEdgeThrough(x1, x2, y1, a1, b1, a2, b2) ||
     vEdgeThrough(x1, x2, y2, a1, b1, a2, b2)) return true;
  if(vEdgeThrough(a1, b1, b2, x1, y1, x2, y2) ||
     vEdgeThrough(a2, b1, b2, x1, y1, x2, y2) ||
     vEdgeThrough(a1, a2, b1, x1, y1, x2, y2) ||
     vEdgeThrough(a1, a2, b2, x1, y1, x2, y2)) return true;
  return false;
}

void win() {
  text("YOU WIN", width/2, height/2);
}  

void keyPressed() {
  if(key == ' ')
    farmer.squatting = true;
  else if(key == CODED && keyCode == DOWN) {
    farmer.squatting = true;
  } else if(key==CODED && keyCode == RIGHT) {
    farmer.walking = true;
    farmer.dx = 3;
  } else if(key == CODED && keyCode == LEFT) {
    farmer.walking = true;
    farmer.dx = -3;
  }
}

void keyReleased() {
  farmer.squatting = false;
  farmer.walking = false;
  if(key == ' ') {
    farmer.throwVegetable();
     addVegetable();
  }
}


