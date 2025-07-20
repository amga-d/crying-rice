// Character.pde
// Base class for all animated characters

class Character {
  PVector position;
  PVector velocity;
  color fillColor;
  float size;
  
  // Animation properties
  float animationTime;
  int currentFrame;
  String currentAnimation;
  
  Character(float x, float y, color col, float s) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    fillColor = col;
    size = s;
    animationTime = 0;
    currentFrame = 0;
    currentAnimation = "idle";
  }
  
  void update() {
    // Update position
    position.add(velocity);
    
    // Update animation
    animationTime += 1.0/60.0; // Assuming 60fps
    currentFrame = (int)(animationTime * 8) % 8; // 8fps animation cycle
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    
    // Draw basic character shape (to be overridden)
    fill(fillColor);
    noStroke();
    ellipse(0, 0, size, size);
    
    popMatrix();
  }
  
  void setAnimation(String animName) {
    if (!currentAnimation.equals(animName)) {
      currentAnimation = animName;
      animationTime = 0;
      currentFrame = 0;
    }
  }
  
  void moveTo(float x, float y, float speed) {
    PVector target = new PVector(x, y);
    PVector direction = PVector.sub(target, position);
    direction.normalize();
    direction.mult(speed);
    velocity = direction;
  }
  
  void stop() {
    velocity.mult(0);
  }
}

// Joko character class - Indonesian village boy
class Joko extends Character {
  String currentSpeech;
  int speechTimer;
  
  Joko(float x, float y) {
    super(x, y, color(205, 164, 125), 120); // Indonesian skin tone, increased size
    currentSpeech = "";
    speechTimer = 0;
  }
  
  void setSpeech(String speech, int duration) {
    currentSpeech = speech;
    speechTimer = duration;
  }
  
  void update() {
    super.update();
    if (speechTimer > 0) speechTimer--;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    scale(1.5); // Make character 50% larger
    
    // Draw Joko - Indonesian village boy
    // Head
    fill(205, 164, 125); // Indonesian skin tone
    noStroke();
    ellipse(0, -30, 50, 50);
    
    // Traditional Indonesian hair (slightly tousled)
    fill(51, 25, 0); // Dark black hair
    ellipse(0, -45, 45, 25);
    // Hair details
    ellipse(-8, -48, 15, 12);
    ellipse(8, -48, 15, 12);
    
    // Eyes (slightly almond-shaped)
    fill(0);
    ellipse(-8, -35, 8, 6);
    ellipse(8, -35, 8, 6);
    fill(255);
    ellipse(-8, -36, 3, 2);
    ellipse(8, -36, 3, 2);
    
    // Nose
    fill(180, 140, 100);
    ellipse(0, -30, 4, 6);
    
    // Smile
    noFill();
    stroke(139, 69, 19);
    strokeWeight(2);
    arc(0, -25, 20, 15, 0, PI);
    
    // Traditional Indonesian shirt (baju)
    fill(220, 180, 50); // Golden yellow traditional color
    noStroke();
    rect(-22, -10, 44, 65, 8);
    
    // Traditional pattern on shirt
    fill(180, 140, 20);
    for (int i = 0; i < 3; i++) {
      rect(-18 + i * 12, 5, 8, 3);
      rect(-18 + i * 12, 15, 8, 3);
    }
    
    // Arms
    fill(205, 164, 125); // Skin
    ellipse(-28, 15, 18, 45);
    ellipse(28, 15, 18, 45);
    
    // Traditional sarung/pants
    fill(139, 69, 19); // Brown traditional cloth
    rect(-18, 55, 15, 45, 5);
    rect(3, 55, 15, 45, 5);
    
    // Traditional pattern on sarung
    fill(101, 50, 0);
    for (int i = 0; i < 2; i++) {
      rect(-15 + i * 15, 70, 2, 15);
      rect(-15 + i * 15, 85, 2, 10);
    }
    
    // Bare feet (traditional village style)
    fill(180, 140, 100);
    ellipse(-9, 105, 18, 10);
    ellipse(9, 105, 18, 10);
    
    popMatrix();
    
    // Draw speech bubble if there's text
    if (speechTimer > 0 && !currentSpeech.equals("")) {
      drawSpeechBubble(currentSpeech, position.x + 80, position.y - 100);
    }
  }
  
  void drawSpeechBubble(String text, float x, float y) {
    // Speech bubble background
    fill(255, 255, 255, 240);
    stroke(0);
    strokeWeight(2);
    
    // Calculate bubble size based on text
    textSize(14);
    float textW = textWidth(text) + 20;
    float textH = 40;
    
    // Bubble shape
    rect(x - textW/2, y - textH/2, textW, textH, 10);
    
    // Bubble tail pointing to character
    triangle(x - 10, y + textH/2, x - 20, y + textH/2 + 15, x, y + textH/2);
    
    // Text
    fill(0);
    noStroke();
    textAlign(CENTER, CENTER);
    text(text, x, y);
    textAlign(LEFT); // Reset alignment
  }
}

// Friend character class - Indonesian village boy
class Friend extends Character {
  String currentSpeech;
  int speechTimer;
  
  Friend(float x, float y) {
    super(x, y, color(210, 170, 130), 120); // Slightly different Indonesian skin tone, increased size
    currentSpeech = "";
    speechTimer = 0;
  }
  
  void setSpeech(String speech, int duration) {
    currentSpeech = speech;
    speechTimer = duration;
  }
  
  void update() {
    super.update();
    if (speechTimer > 0) speechTimer--;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    scale(1.5); // Make character 50% larger
    
    // Draw Friend - Indonesian village boy
    // Head
    fill(210, 170, 130); // Indonesian skin tone
    noStroke();
    ellipse(0, -30, 50, 50);
    
    // Traditional Indonesian hair
    fill(25, 12, 0); // Very dark hair
    ellipse(0, -45, 45, 25);
    // Hair texture
    ellipse(-10, -50, 12, 8);
    ellipse(10, -50, 12, 8);
    ellipse(0, -52, 18, 10);
    
    // Eyes
    fill(0);
    ellipse(-8, -35, 8, 6);
    ellipse(8, -35, 8, 6);
    fill(255);
    ellipse(-8, -36, 3, 2);
    ellipse(8, -36, 3, 2);
    
    // Nose
    fill(185, 145, 105);
    ellipse(0, -30, 4, 6);
    
    // Smile
    noFill();
    stroke(139, 69, 19);
    strokeWeight(2);
    arc(0, -25, 20, 15, 0, PI);
    
    // Traditional Indonesian shirt (different color)
    fill(200, 50, 50); // Traditional red
    noStroke();
    rect(-22, -10, 44, 65, 8);
    
    // Batik-inspired pattern
    fill(160, 30, 30);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        ellipse(-15 + i * 8, 5 + j * 20, 4, 4);
      }
    }
    
    // Arms
    fill(210, 170, 130); // Skin
    ellipse(-28, 15, 18, 45);
    ellipse(28, 15, 18, 45);
    
    // Traditional sarung (different pattern)
    fill(0, 80, 40); // Dark green traditional
    rect(-18, 55, 15, 45, 5);
    rect(3, 55, 15, 45, 5);
    
    // Traditional weaving pattern
    fill(0, 60, 20);
    for (int i = 0; i < 3; i++) {
      rect(-16 + i * 8, 65, 1, 30);
      rect(-14 + i * 8, 70, 3, 2);
      rect(-14 + i * 8, 80, 3, 2);
      rect(-14 + i * 8, 90, 3, 2);
    }
    
    // Bare feet
    fill(185, 145, 105);
    ellipse(-9, 105, 18, 10);
    ellipse(9, 105, 18, 10);
    
    popMatrix();
    
    // Draw speech bubble if there's text
    if (speechTimer > 0 && !currentSpeech.equals("")) {
      drawSpeechBubble(currentSpeech, position.x - 80, position.y - 100);
    }
  }
  
  void drawSpeechBubble(String text, float x, float y) {
    // Speech bubble background
    fill(255, 255, 255, 240);
    stroke(0);
    strokeWeight(2);
    
    // Calculate bubble size based on text
    textSize(14);
    float textW = textWidth(text) + 20;
    float textH = 40;
    
    // Bubble shape
    rect(x - textW/2, y - textH/2, textW, textH, 10);
    
    // Bubble tail pointing to character
    triangle(x + 10, y + textH/2, x + 20, y + textH/2 + 15, x, y + textH/2);
    
    // Text
    fill(0);
    noStroke();
    textAlign(CENTER, CENTER);
    text(text, x, y);
    textAlign(LEFT); // Reset alignment
  }
}
