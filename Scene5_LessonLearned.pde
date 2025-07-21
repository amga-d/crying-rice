// Scene5_LessonLearned.pde
// Final Scene: The Lesson Learned - Beautiful summary with polished design

class Scene5_LessonLearned {
  // Animation timing
  int scenePhase; // 0: fade in, 1: title reveal, 2: lesson text, 3: rice grains animation, 4: final message
  int phaseStartFrame;
  
  // Visual elements
  ArrayList<FloatingRiceGrain> floatingRice;
  ArrayList<WisdomParticle> wisdomParticles;
  PVector sun;
  
  // Text content
  String[] lessonLines;
  String finalMessage;
  
  // Animation states
  float titleAlpha;
  float textAlpha;
  float backgroundShift;
  int currentLineIndex;
  
  Scene5_LessonLearned() {
    // Constructor - initialize basic properties
  }
  
  void init() {
    println("Initializing Scene 5: The Lesson Learned");
    
    // Start happy ending background music for the lesson learned scene
    if (audioManager != null) {
      audioManager.startHappyEndingMusic(5);
    }
    
    // Initialize lesson content
    setupLessonContent();
    
    // Create floating rice grains
    floatingRice = new ArrayList<FloatingRiceGrain>();
    for (int i = 0; i < 20; i++) {
      floatingRice.add(new FloatingRiceGrain(
        random(width), 
        random(height), 
        random(0.5, 1.5)
      ));
    }
    
    // Create wisdom particles
    wisdomParticles = new ArrayList<WisdomParticle>();
    for (int i = 0; i < 30; i++) {
      wisdomParticles.add(new WisdomParticle(
        random(width),
        random(height),
        random(1, 3)
      ));
    }
    
    // Initialize animation states
    scenePhase = 0;
    phaseStartFrame = 0;
    titleAlpha = 0;
    textAlpha = 0;
    backgroundShift = 0;
    currentLineIndex = 0;
    
    // Sun position for warm lighting
    sun = new PVector(width * 0.8, height * 0.2);
  }
  
  void setupLessonContent() {
    // The lesson learned - in both Indonesian and English
    lessonLines = new String[] {
      "Pelajaran dari Nasi",
      "(The Lesson of the Rice)",
      "",
      "Setiap butir nasi adalah hasil kerja keras petani.",
      "Every grain of rice is the result of a farmer's hard work.",
      "",
      "Dengan menghargai makanan, kita menghargai kehidupan.",
      "By appreciating food, we appreciate life.",
      "",
      "Jangan sia-siakan apa yang telah diberikan alam.",
      "Don't waste what nature has given us.",
      "",
      "Karena di setiap butir nasi,",
      "Because in every grain of rice,",
      "",
      "Ada cinta, keringat, dan harapan.",
      "There is love, sweat, and hope."
    };
    
    finalMessage = "Mari kita selalu bersyukur dan menghargai makanan kita.\n(Let us always be grateful and appreciate our food.)";
  }
  
  void update(int sceneFrame) {
    int phaseFrame = sceneFrame - phaseStartFrame;
    
    // Phase transitions
    if (scenePhase == 0 && phaseFrame > 90) { // 3 seconds - fade in complete
      startPhase(1, sceneFrame);
    } else if (scenePhase == 1 && phaseFrame > 150) { // 5 seconds - title revealed
      startPhase(2, sceneFrame);
    } else if (scenePhase == 2 && phaseFrame > 600) { // 20 seconds - lesson text shown
      startPhase(3, sceneFrame);
    } else if (scenePhase == 3 && phaseFrame > 300) { // 10 seconds - rice animation
      startPhase(4, sceneFrame);
    }
    
    // Update based on current phase
    switch (scenePhase) {
      case 0: // Fade in
        updateFadeIn(phaseFrame);
        break;
      case 1: // Title reveal
        updateTitleReveal(phaseFrame);
        break;
      case 2: // Lesson text
        updateLessonText(phaseFrame);
        break;
      case 3: // Rice grains animation
        updateRiceAnimation(phaseFrame);
        break;
      case 4: // Final message
        updateFinalMessage(phaseFrame);
        break;
    }
    
    // Update floating elements
    for (FloatingRiceGrain grain : floatingRice) {
      grain.update();
    }
    
    for (WisdomParticle particle : wisdomParticles) {
      particle.update();
    }
    
    // Update background animation
    backgroundShift += 0.5;
  }
  
  void startPhase(int newPhase, int currentFrame) {
    scenePhase = newPhase;
    phaseStartFrame = currentFrame;
    
    switch (newPhase) {
      case 1:
        println("Phase 1: Title Reveal");
        break;
      case 2:
        println("Phase 2: Lesson Text");
        break;
      case 3:
        println("Phase 3: Rice Animation");
        break;
      case 4:
        println("Phase 4: Final Message");
        break;
    }
  }
  
  void updateFadeIn(int phaseFrame) {
    titleAlpha = map(phaseFrame, 0, 90, 0, 255);
    titleAlpha = constrain(titleAlpha, 0, 255);
    
    // Gradually increase music volume during fade in
    if (audioManager != null) {
      float volume = map(phaseFrame, 0, 90, 0.1, 0.3);
      audioManager.setHappyEndingMusicVolume(volume);
    }
  }
  
  void updateTitleReveal(int phaseFrame) {
    titleAlpha = 255;
    // Add gentle title animation
    
    // Set music to moderate volume for title reveal
    if (audioManager != null && phaseFrame == 0) {
      audioManager.setHappyEndingMusicVolume(0.35);
    }
  }
  
  void updateLessonText(int phaseFrame) {
    textAlpha = map(phaseFrame, 0, 60, 0, 255);
    textAlpha = constrain(textAlpha, 0, 255);
    
    // Progressive text reveal
    int lineRevealInterval = 30; // Reveal new line every second
    currentLineIndex = min(phaseFrame / lineRevealInterval, lessonLines.length - 1);
    
    // Increase music volume as lesson text appears
    if (audioManager != null && phaseFrame == 0) {
      audioManager.setHappyEndingMusicVolume(0.4);
    }
  }
  
  void updateRiceAnimation(int phaseFrame) {
    // Enhance rice grain movement
    for (FloatingRiceGrain grain : floatingRice) {
      grain.setSpecialAnimation(true);
    }
    
    // Increase music volume for the inspiring rice animation
    if (audioManager != null && phaseFrame == 0) {
      audioManager.setHappyEndingMusicVolume(0.45);
    }
  }
  
  void updateFinalMessage(int phaseFrame) {
    // Keep everything visible and add final touches
    titleAlpha = 255;
    textAlpha = 255;
    
    // Peak music volume for the final uplifting message
    if (audioManager != null && phaseFrame == 0) {
      audioManager.setHappyEndingMusicVolume(0.5);
    }
  }
  
  void draw() {
    // Draw enchanted background
    drawEnchantedBackground();
    
    // Draw wisdom particles first (background layer)
    for (WisdomParticle particle : wisdomParticles) {
      particle.draw();
    }
    
    // Draw floating rice grains
    for (FloatingRiceGrain grain : floatingRice) {
      grain.draw();
    }
    
    // Draw main content based on phase
    if (scenePhase >= 0) {
      drawTitle();
    }
    
    if (scenePhase >= 2) {
      drawLessonText();
    }
    
    if (scenePhase >= 4) {
      drawFinalMessage();
    }
  }
  
  void drawEnchantedBackground() {
    // Beautiful gradient background with warm golden tones
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      color topColor = color(255, 215, 120); // Warm golden yellow
      color bottomColor = color(139, 180, 120); // Soft green
      color c = lerpColor(topColor, bottomColor, inter);
      stroke(c);
      line(0, i, width, i);
    }
    
    // Add mystical sun rays
    drawMysticalSunRays();
    
    // Add floating light particles
    drawLightParticles();
    
    // Add subtle rice field silhouette in background
    drawBackgroundRiceField();
  }
  
  void drawMysticalSunRays() {
    pushMatrix();
    translate(sun.x, sun.y);
    
    // Soft golden sun
    fill(255, 235, 150, 180);
    noStroke();
    ellipse(0, 0, 120, 120);
    
    // Gentle sun rays
    stroke(255, 245, 180, 100);
    strokeWeight(2);
    for (int i = 0; i < 16; i++) {
      float angle = i * TWO_PI / 16 + backgroundShift * 0.01;
      float rayLength = 200 + sin(backgroundShift * 0.02 + i) * 50;
      float x1 = cos(angle) * 70;
      float y1 = sin(angle) * 70;
      float x2 = cos(angle) * rayLength;
      float y2 = sin(angle) * rayLength;
      line(x1, y1, x2, y2);
    }
    
    popMatrix();
  }
  
  void drawLightParticles() {
    // Gentle floating light particles for magical atmosphere
    fill(255, 255, 200, 150);
    noStroke();
    
    for (int i = 0; i < 15; i++) {
      float x = (backgroundShift * 2 + i * 80) % (width + 100) - 50;
      float y = height * 0.3 + sin(backgroundShift * 0.03 + i) * 100;
      float size = 3 + sin(backgroundShift * 0.04 + i * 2) * 2;
      ellipse(x, y, size, size);
    }
  }
  
  void drawBackgroundRiceField() {
    // Subtle rice field silhouette in the background
    fill(100, 150, 100, 60);
    noStroke();
    
    // Rolling hills with rice terraces
    beginShape();
    vertex(0, height * 0.7);
    for (int x = 0; x <= width; x += 50) {
      float y = height * 0.7 + sin(x * 0.01 + backgroundShift * 0.005) * 30;
      vertex(x, y);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    
    // Terrace lines
    stroke(120, 170, 120, 80);
    strokeWeight(1);
    for (int i = 0; i < 3; i++) {
      for (int x = 0; x <= width; x += 50) {
        float y = height * (0.75 + i * 0.05) + sin(x * 0.01 + backgroundShift * 0.005) * 20;
        point(x, y);
      }
    }
  }
  
  void drawTitle() {
    pushMatrix();
    pushStyle();
    
    // Title positioning and styling
    textAlign(CENTER, CENTER);
    
    // Main title with elegant styling
    textSize(48);
    PFont titleFont = createFont("Arial Bold", 48);
    textFont(titleFont);
    
    // Main title text with black stroke and golden color
    stroke(0);
    strokeWeight(5);
    fill(255, 200, 50, titleAlpha);
    text("The Lesson of the Rice", width/2, height * 0.15);
    
    // Indonesian subtitle
    textSize(24);
    stroke(0);
    strokeWeight(5);
    fill(255, 220, 100, titleAlpha * 0.9);
    text("Pelajaran dari Nasi", width/2, height * 0.22);
    
    // Decorative rice grain border around title
    if (titleAlpha > 200) {
      drawTitleDecorations();
    }
    
    popStyle();
    popMatrix();
  }
  
  void drawTitleDecorations() {
    // Elegant rice grain decorations around the title
    fill(255, 215, 120, titleAlpha * 0.8);
    noStroke();
    
    float centerX = width/2;
    float centerY = height * 0.185;
    float radius = 300;
    
    for (int i = 0; i < 12; i++) {
      float angle = i * TWO_PI / 12 + backgroundShift * 0.01;
      float x = centerX + cos(angle) * radius;
      float y = centerY + sin(angle) * (radius * 0.3);
      
      pushMatrix();
      translate(x, y);
      rotate(angle + PI/2);
      
      // Elegant rice grain shape
      ellipse(0, 0, 6, 12);
      fill(255, 235, 150, titleAlpha * 0.6);
      ellipse(0, -1, 4, 8);
      
      popMatrix();
    }
  }
  
  void drawLessonText() {
    pushMatrix();
    pushStyle();
    
    textAlign(CENTER, CENTER);
    
    // Main lesson text
    textSize(20);
    PFont textFont = createFont("Arial", 20);
    textFont(textFont);
    
    float startY = height * 0.35;
    float lineSpacing = 35;
    
    for (int i = 0; i <= currentLineIndex && i < lessonLines.length; i++) {
      String line = lessonLines[i];
      float yPos = startY + i * lineSpacing;
      
      // Calculate line-specific alpha
      float lineAlpha = textAlpha;
      if (i == currentLineIndex) {
        // Fade in current line
        int lineFrame = (frameCount - phaseStartFrame) % 30;
        lineAlpha = map(lineFrame, 0, 30, 0, textAlpha);
      }
      
      // Determine text color based on content
      color textColor;
      if (line.startsWith("Pelajaran") || line.startsWith("(The Lesson")) {
        textColor = color(255, 200, 50, lineAlpha); // Golden for headers
        textSize(24);
      } else if (line.contains("(") && line.contains(")")) {
        textColor = color(200, 220, 255, lineAlpha * 0.8); // Light blue for English
        textSize(16);
      } else if (line.length() > 0) {
        textColor = color(255, 255, 255, lineAlpha); // White for Indonesian
        textSize(18);
      } else {
        continue; // Skip empty lines
      }
      
      // Main text with black stroke
      stroke(0);
      strokeWeight(5);
      fill(textColor);
      text(line, width/2, yPos);
    }
    
    popStyle();
    popMatrix();
  }
  
  void drawFinalMessage() {
    pushMatrix();
    pushStyle();
    
    textAlign(CENTER, CENTER);
    textSize(22);
    PFont finalFont = createFont("Arial Bold", 22);
    textFont(finalFont);
    
    // Final message position
    float msgY = height * 0.85;
    
    // Message background with soft glow
    fill(255, 255, 255, 30);
    noStroke();
    rect(width/2 - 400, msgY - 40, 800, 80, 15);
    
    // Final message text with black stroke
    stroke(0);
    strokeWeight(5);
    fill(255, 220, 100, 255);
    text(finalMessage, width/2, msgY);
    
    popStyle();
    popMatrix();
  }
}

// Supporting classes for the lesson scene

class FloatingRiceGrain {
  PVector position;
  PVector velocity;
  float size;
  float rotation;
  float rotationSpeed;
  boolean specialAnimation;
  color grainColor;
  
  FloatingRiceGrain(float x, float y, float s) {
    position = new PVector(x, y);
    velocity = new PVector(random(-0.5, 0.5), random(-1, -0.2));
    size = s;
    rotation = random(TWO_PI);
    rotationSpeed = random(-0.02, 0.02);
    specialAnimation = false;
    grainColor = color(255, 245, 200, 180);
  }
  
  void update() {
    position.add(velocity);
    rotation += rotationSpeed;
    
    // Wrap around screen
    if (position.x < -20) position.x = width + 20;
    if (position.x > width + 20) position.x = -20;
    if (position.y < -20) position.y = height + 20;
    if (position.y > height + 20) position.y = -20;
    
    // Special animation effects
    if (specialAnimation) {
      velocity.mult(1.05); // Speed up
      grainColor = color(255, 215, 120, 200); // More golden
    }
  }
  
  void setSpecialAnimation(boolean special) {
    specialAnimation = special;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    fill(grainColor);
    noStroke();
    
    // Rice grain shape
    ellipse(0, 0, size * 4, size * 8);
    
    // Grain highlight
    fill(255, 255, 240, 100);
    ellipse(-0.5, -1, size * 2, size * 4);
    
    popMatrix();
  }
}

class WisdomParticle {
  PVector position;
  PVector velocity;
  float life;
  float maxLife;
  float size;
  color particleColor;
  
  WisdomParticle(float x, float y, float s) {
    position = new PVector(x, y);
    velocity = new PVector(random(-0.3, 0.3), random(-0.8, -0.2));
    maxLife = random(200, 400);
    life = random(maxLife);
    size = s;
    particleColor = color(255, 230, 150);
  }
  
  void update() {
    position.add(velocity);
    life--;
    
    if (life <= 0) {
      // Respawn particle
      position.set(random(width), height + 10);
      life = maxLife;
    }
    
    // Gentle floating motion
    velocity.x += random(-0.01, 0.01);
    velocity.y += random(-0.01, 0.01);
    velocity.mult(0.99);
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    
    float alpha = map(life, 0, maxLife, 0, 150);
    fill(red(particleColor), green(particleColor), blue(particleColor), alpha);
    noStroke();
    
    ellipse(0, 0, size, size);
    
    // Inner glow
    fill(255, 255, 255, alpha * 0.5);
    ellipse(0, 0, size * 0.5, size * 0.5);
    
    popMatrix();
  }
}
