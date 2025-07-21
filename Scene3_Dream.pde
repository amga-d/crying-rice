// Scene3_Dream.pde
// Scene 3: Bad Dream - Joko's Room, Afternoon Nap (1:00 - 1:30)
// Duration: 30 seconds - Simple and clean implementation

class Scene3_Dream {
  // Characters
  Joko joko;
  Character farmer;
  
  // Environment
  boolean isInDream;
  float dreamTransition;
  
  // Rice system
  ArrayList<RiceGrain> riceGrains;
  
  // Visual effects
  float sunIntensity;
  PVector cameraShake;
  
  // Timing
  int scenePhase; // 0: sleeping, 1: dream_start, 2: field_struggle, 3: rice_crying
  int phaseStartFrame;
  
  // Audio
  String currentNarration;
  int narrationStartFrame;
  int narrationDuration;
  
  Scene3_Dream() {
    riceGrains = new ArrayList<RiceGrain>();
    cameraShake = new PVector(0, 0);
    isInDream = false;
    dreamTransition = 0;
    sunIntensity = 0;
    currentNarration = "";
    narrationStartFrame = 0;
    narrationDuration = 0;
  }
  
  void init() {
    println("Initializing Scene 3: Dream");
    
    // Create characters
    joko = new Joko(width/2 - 100, height - 150);
    joko.setAnimation("sleeping");
    
    farmer = new Character(width/2 + 100, height - 180, color(160, 120, 80), 35);
    farmer.setAnimation("struggling");
    
    // Create rice grains
    createRiceGrains();
    
    // Reset values
    scenePhase = 0;
    phaseStartFrame = 0;
    dreamTransition = 0;
    isInDream = false;
  }
  
  void createRiceGrains() {
    riceGrains.clear();
    for (int i = 0; i < 15; i++) {
      // Static positions based on index for stability
      float x = 100 + (i * 73) % (width - 200);
      float y = height - 200 + (i * 37) % 100;
      riceGrains.add(new RiceGrain(x, y));
    }
  }
  
  void update(int sceneFrame) {
    int phaseFrame = sceneFrame - phaseStartFrame;
    
    // Phase transitions (30 seconds = 900 frames at 30fps)
    switch(scenePhase) {
      case 0: // Sleeping (0-5 seconds)
        if (phaseFrame >= 150) {
          startPhase(1, sceneFrame);
          setNarration("Joko falls asleep and begins to dream...", 120); // 4 seconds
        }
        break;
        
      case 1: // Dream transition (5-10 seconds)
        if (phaseFrame >= 150) {
          startPhase(2, sceneFrame);
          setNarration("He sees a struggling farmer in a dry rice field...", 150); // 5 seconds
        }
        break;
        
      case 2: // Field struggle (10-20 seconds)
        if (phaseFrame >= 300) {
          startPhase(3, sceneFrame);
          setNarration("The rice grains begin to cry, asking why they are wasted...", 180); // 6 seconds
        }
        break;
        
      case 3: // Rice crying (20-30 seconds)
        // Continues until scene ends
        break;
    }
    
    updateVisualEffects(sceneFrame, phaseFrame);
    updateCharacters();
    updateRiceGrains();
  }
  
  void startPhase(int newPhase, int currentFrame) {
    scenePhase = newPhase;
    phaseStartFrame = currentFrame;
    
    if (newPhase >= 1) {
      isInDream = true;
    }
  }
  
  void updateVisualEffects(int sceneFrame, int phaseFrame) {
    // Dream transition
    if (scenePhase == 1) {
      dreamTransition = map(phaseFrame, 0, 150, 0, 1);
      dreamTransition = constrain(dreamTransition, 0, 1);
    } else if (scenePhase >= 2) {
      dreamTransition = 1;
    }
    
    // Sun intensity in dream
    if (isInDream) {
      sunIntensity = 0.7 + sin(frameCount * 0.05) * 0.3;
    }
    
    // No camera shake - removed for stability
  }
  
  void updateCharacters() {
    joko.update();
    
    if (isInDream) {
      // Update farmer animations
      if (scenePhase == 2) {
        farmer.setAnimation("struggling");
      } else if (scenePhase >= 3) {
        farmer.setAnimation("crying");
      }
      farmer.update();
    }
  }
  
  void updateRiceGrains() {
    if (scenePhase >= 3) {
      for (RiceGrain grain : riceGrains) {
        grain.update();
      }
    }
  }
  
  void draw() {
    // Removed camera shake for stability
    
    if (!isInDream || dreamTransition < 1) {
      drawBedroom();
    }
    
    if (isInDream) {
      if (dreamTransition < 1) {
        // Blend between bedroom and dream
        pushMatrix();
        tint(255, dreamTransition * 255);
        drawDreamField();
        noTint();
        popMatrix();
      } else {
        drawDreamField();
      }
    }
    
    // Draw narration
    drawNarration();
  }
  
  void drawBedroom() {
    // Sky gradient through window (afternoon light)
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      color c = lerpColor(color(200, 220, 255), color(255, 240, 200), inter);
      stroke(c);
      line(0, i, width, i);
    }
    
    // Floor
    fill(101, 67, 33); // Brown wooden floor
    noStroke();
    rect(0, height - 100, width, 100);
    
    // Floor planks
    stroke(80, 50, 20);
    strokeWeight(1);
    for (int i = 0; i < width; i += 80) { // Increased spacing from 60 to 80 for better performance
      line(i, height - 100, i, height);
    }
    
    // Walls
    fill(240, 235, 220); // Warm wall color
    noStroke();
    rect(0, 0, width, height - 100);
    
    // Wall trim
    fill(200, 180, 160);
    rect(0, height - 120, width, 20);
    
    // Bed (using Scene 5's bed position variables translated to Scene 3)
    PVector bed = new PVector(width/2, height - 50); // Center bed position for Scene 3
    fill(120, 80, 40); // Wooden bed frame
    noStroke();
    rect(bed.x - 120, bed.y - 30, 240, 80, 8);
    
    // Mattress
    fill(250, 240, 230); // White/cream mattress
    rect(bed.x - 110, bed.y - 40, 220, 30, 5);
    
    // Pillow
    fill(255, 250, 240);
    ellipse(bed.x - 60, bed.y - 45, 80, 40);
    
    // Blanket
    fill(100, 150, 200); // Blue blanket
    noStroke();
    beginShape();
    vertex(bed.x - 100, bed.y - 20);
    vertex(bed.x + 100, bed.y - 15);
    vertex(bed.x + 90, bed.y + 30);
    vertex(bed.x - 80, bed.y + 25);
    endShape(CLOSE);
    
    // Door (using Scene 5's door design)
    PVector door = new PVector(100, 350); // Door position for Scene 3
    fill(139, 90, 43); // Wooden door
    noStroke();
    rect(door.x - 20, door.y, 40, 120, 5);
    
    // Door handle
    fill(180, 160, 120);
    ellipse(door.x + 15, door.y + 60, 6, 6);
    
    // Window (using Scene 5's window design but with afternoon light)
    PVector window = new PVector(950, 200); // Window position for Scene 3
    // Window frame
    fill(139, 90, 43); // Wooden window frame
    noStroke();
    rect(window.x - 60, window.y, 120, 150, 8);
    
    // Window glass with afternoon light (bright daylight at 1:00-1:30 PM)
    fill(255, 240, 180, 150); // Bright afternoon light
    rect(window.x - 50, window.y + 10, 100, 130);
    
    // Window cross frame
    fill(139, 90, 43);
    rect(window.x - 5, window.y + 10, 10, 130);
    rect(window.x - 50, window.y + 70, 100, 10);
    
    // Afternoon sun (bright midday sun)
    fill(255, 230, 120, 180);
    noStroke();
    ellipse(window.x + 25, window.y + 35, 50, 50);
    
    // Sun glow
    fill(255, 240, 150, 60);
    ellipse(window.x + 25, window.y + 35, 80, 80);
    
    // Joko sleeping
    if (dreamTransition < 1) {
      joko.draw();
    }
  }
  
  void drawDreamField() {
    // Dream field background
    // Harsh sky
    for (int i = 0; i < height; i++) {
      float inter = map(i, 0, height, 0, 1);
      color c = lerpColor(color(120, 80, 60), color(200, 150, 100), inter);
      stroke(c);
      line(0, i, width, i);
    }
    
    // Harsh sun
    fill(255, 200, 100, 200);
    noStroke();
    ellipse(width * 0.8, 80, 60 + sin(frameCount * 0.1) * 10, 60 + sin(frameCount * 0.1) * 10);
    
    // Sun rays
    stroke(255, 180, 80, 150);
    strokeWeight(3);
    for (int i = 0; i < 8; i++) {
      float angle = i * PI / 4 + frameCount * 0.02;
      float x1 = width * 0.8 + cos(angle) * 40;
      float y1 = 80 + sin(angle) * 40;
      float x2 = width * 0.8 + cos(angle) * 80;
      float y2 = 80 + sin(angle) * 80;
      line(x1, y1, x2, y2);
    }
    
    // Dry ground - wider and more cracked
    fill(100, 60, 30); // Darker, more drought-affected soil
    noStroke();
    rect(-100, height - 180, width + 200, 180); // Wider ground area
    
    // More extensive cracked earth pattern (STATIC)
    stroke(60, 30, 15);
    strokeWeight(3);
    for (int i = 0; i < 25; i++) { // Static cracks
      float x = (i * 53) % (width + 100) - 50;
      float y = height - 50 - (i * 29) % 130;
      float length = 50 + (i % 4) * 15;
      float angle = (i * 0.7) % TWO_PI;
      line(x, y, x + cos(angle) * length, y + sin(angle) * length);
    }
    
    // Smaller secondary cracks (STATIC)
    strokeWeight(1);
    stroke(80, 40, 20);
    for (int i = 0; i < 40; i++) {
      float x = (i * 41) % (width + 100) - 50;
      float y = height - 30 - (i * 19) % 150;
      float offsetX = ((i * 13) % 40) - 20;
      float offsetY = ((i * 7) % 16) - 8;
      line(x, y, x + offsetX, y + offsetY);
    }
    
    // Draw farmer (improved appearance)
    if (dreamTransition >= 0.5) {
      drawImprovedFarmer();
    }
    
    // Draw withered rice plants (copied from Scene 1 but dried)
    drawWitheredRicePlants();
    
    // Add drought effects
    drawDroughtEffects();
    
    // Draw crying rice grains
    if (scenePhase >= 3) {
      for (RiceGrain grain : riceGrains) {
        grain.draw();
      }
    }
    
    // Dream overlay effect
    fill(100, 50, 150, 50);
    noStroke();
    rect(0, 0, width, height);
  }
  
  void drawNarration() {
    // Get current narration if within duration
    String narration = getCurrentNarration();
    if (narration.length() > 0) {
      pushMatrix();
      pushStyle();
      
      // Calculate fade-in/fade-out animation
      int currentFrame = frameCount - narrationStartFrame;
      float fadeAlpha = 255;
      int fadeInFrames = 15; // 0.5 seconds fade in
      int fadeOutFrames = 15; // 0.5 seconds fade out
      
      if (currentFrame < fadeInFrames) {
        fadeAlpha = map(currentFrame, 0, fadeInFrames, 0, 255);
      } else if (currentFrame > narrationDuration - fadeOutFrames) {
        fadeAlpha = map(currentFrame, narrationDuration - fadeOutFrames, narrationDuration, 255, 0);
      }
      
      // Calculate text dimensions with improved typography
      textSize(20);
      PFont currentFont = createFont("Arial", 20);
      textFont(currentFont);
      
      float textW = textWidth(narration);
      float maxWidth = width - 120;
      
      // Enhanced text wrapping for better readability
      ArrayList<String> lines = new ArrayList<String>();
      if (textW > maxWidth) {
        String[] words = split(narration, " ");
        String currentLine = "";
        
        for (String word : words) {
          String testLine = currentLine.length() > 0 ? currentLine + " " + word : word;
          float testWidth = textWidth(testLine);
          
          if (testWidth < maxWidth) {
            currentLine = testLine;
          } else {
            if (currentLine.length() > 0) {
              lines.add(currentLine);
            }
            currentLine = word;
          }
        }
        if (currentLine.length() > 0) {
          lines.add(currentLine);
        }
      } else {
        lines.add(narration);
      }
      
      // Calculate background dimensions
      float lineHeight = 28;
      float bgWidth = maxWidth + 60;
      float bgHeight = (lines.size() * lineHeight) + 40;
      float bgX = width/2;
      float bgY = 80 + (bgHeight/2); // Top position to avoid caption overlap
      
      // Draw elegant background with gradient effect (dream-themed colors)
      for (int i = 0; i < 8; i++) {
        float alpha = map(i, 0, 7, fadeAlpha * 0.4, 0);
        fill(100, 50, 150, alpha); // Purple dream colors
        noStroke();
        rectMode(CENTER);
        rect(bgX, bgY, bgWidth + (i * 2), bgHeight + (i * 2), 15 + i);
      }
      
      // Main background with dream theme
      fill(25, 15, 45, fadeAlpha * 0.9); // Dark purple for dream
      stroke(150, 100, 200, fadeAlpha * 0.8); // Purple accent
      strokeWeight(2);
      rect(bgX, bgY, bgWidth, bgHeight, 12);
      
      // Decorative border accent with dream theme
      stroke(200, 150, 255, fadeAlpha * 0.6); // Light purple accent
      strokeWeight(1);
      noFill();
      rect(bgX, bgY, bgWidth - 8, bgHeight - 8, 8);
      
      // Draw text with enhanced styling
      textAlign(CENTER, CENTER);
      
      // Text shadow for depth
      fill(0, 0, 0, fadeAlpha * 0.5);
      for (int i = 0; i < lines.size(); i++) {
        float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight) + 2;
        text(lines.get(i), bgX + 2, yPos + 2);
      }
      
      // Main text with dream-appropriate color (mystical lavender)
      fill(220, 200, 255, fadeAlpha);
      for (int i = 0; i < lines.size(); i++) {
        float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight);
        text(lines.get(i), bgX, yPos);
      }
      
      // Dream-themed indicator animation (mystical shimmer)
      if (currentFrame < narrationDuration - 30) {
        float shimmerAlpha = (sin(frameCount * 0.15) + 1) * 0.4 * fadeAlpha;
        fill(200, 150, 255, shimmerAlpha);
        noStroke();
        ellipse(bgX + (bgWidth/2) - 15, bgY + (bgHeight/2) - 8, 8, 8);
        ellipse(bgX + (bgWidth/2) - 20, bgY + (bgHeight/2) - 12, 4, 4);
        ellipse(bgX + (bgWidth/2) - 10, bgY + (bgHeight/2) - 4, 3, 3);
      }
      
      popStyle();
      popMatrix();
    }
  }
  
  // Helper method to set narration with timing
  void setNarration(String text, int duration) {
    currentNarration = text;
    narrationStartFrame = frameCount;
    narrationDuration = duration;
    println("Scene3 NARRATION: " + text);
  }
  
  // Helper method to get current narration if active
  String getCurrentNarration() {
    int currentFrame = frameCount - narrationStartFrame;
    if (currentFrame >= 0 && currentFrame < narrationDuration) {
      return currentNarration;
    }
    return "";
  }
  
  void drawImprovedFarmer() {
    // Enhanced farmer appearance for the dream sequence
    pushMatrix();
    translate(farmer.position.x, farmer.position.y);
    scale(1.5); // Scale farmer to 1.5x larger
    
    // Farmer body - weathered and tired looking
    fill(120, 80, 60); // Tanned, sun-weathered skin
    noStroke();
    
    // Body (torso)
    ellipse(0, -15, 30, 40);
    
    // Head
    fill(140, 100, 70);
    ellipse(0, -40, 25, 30);
    
    // Traditional farmer clothes
    // Worn shirt
    fill(80, 60, 40, 200); // Faded brown shirt
    rect(-12, -30, 24, 25, 3);
    
    // Pants
    fill(60, 40, 30); // Dark work pants
    rect(-10, -8, 20, 30, 2);
    
    // Arms showing effort/despair - ENHANCED EMOTIONAL POSTURE
    stroke(120, 80, 60);
    strokeWeight(5);
    
    if (scenePhase == 2) {
      // Struggling animation - working the dry soil
      float struggle = sin(frameCount * 0.1) * 10;
      line(-12, -25, -20 + struggle, -15);
      line(12, -25, 20 - struggle, -15);
      
      // Tool in hand (hoe/cangkul)
      stroke(80, 50, 30);
      strokeWeight(3);
      line(20 - struggle, -15, 25 - struggle, -25);
    } else {
      // ENHANCED CRYING/DESPAIR ANIMATION - much more dramatic
      float sobbing = sin(frameCount * 0.3) * 3; // Faster, more dramatic sobbing motion
      
      // Arms covering face in despair - more realistic positioning
      line(-12, -25, -8 + sobbing, -45); // Left arm to face
      line(12, -25, 8 - sobbing, -45);   // Right arm to face
      
      // Hands covering face (more detailed)
      fill(120, 80, 60);
      noStroke();
      ellipse(-8 + sobbing, -45, 6, 8);  // Left hand
      ellipse(8 - sobbing, -45, 6, 8);   // Right hand
      
      // Body shaking from crying - subtle torso movement
      pushMatrix();
      translate(sin(frameCount * 0.25) * 2, 0); // Body shaking motion
      
      // Show slumped, defeated posture
      // (Additional body adjustments would go here, but we'll handle this in the transform)
      popMatrix();
    }
    
    // Legs
    strokeWeight(6);
    stroke(60, 40, 30);
    line(-8, 15, -8, 35);
    line(8, 15, 8, 35);
    
    // Feet
    fill(40, 20, 10);
    noStroke();
    ellipse(-8, 35, 12, 6);
    ellipse(8, 35, 12, 6);
    
    // Facial expression - MORE SAD AND EMOTIONAL
    fill(0);
    noStroke();
    
    if (scenePhase >= 3) {
      // ENHANCED CRYING EYES - much more dramatic
      // Squinting, puffy eyes from crying
      fill(120, 80, 60); // Puffy eye area
      ellipse(-6, -45, 8, 6);
      ellipse(6, -45, 8, 6);
      
      // Closed crying eyes with visible eyelashes
      fill(0);
      ellipse(-6, -45, 6, 2); // Squinting left eye
      ellipse(6, -45, 6, 2);  // Squinting right eye
      
      // Multiple tear streams - much more dramatic
      fill(100, 150, 255, 200); // Brighter, more visible tears
      
      // Main tear streams
      ellipse(-6, -40, 3, 12); // Left main tear
      ellipse(6, -40, 3, 12);  // Right main tear
      
      // Secondary tear drops
      ellipse(-8, -38, 2, 8);  // Left secondary tear
      ellipse(4, -38, 2, 8);   // Right secondary tear
      
      // Tear drops falling
      ellipse(-6, -30, 2, 6);  // Left falling tear
      ellipse(6, -30, 2, 6);   // Right falling tear
      
      // Additional small tear drops
      ellipse(-4, -25, 1.5, 4);
      ellipse(8, -25, 1.5, 4);
      
      // MUCH SADDER MOUTH - open sobbing
      stroke(0);
      strokeWeight(2);
      fill(80, 40, 40); // Dark mouth interior
      ellipse(0, -32, 8, 12); // Open mouth shape
      
      // Visible tongue/inside mouth for more dramatic crying
      fill(120, 60, 60);
      ellipse(0, -30, 4, 6);
      
      // Downturned mouth corners
      noFill();
      stroke(0);
      strokeWeight(1.5);
      arc(-4, -32, 4, 4, 0, PI);
      arc(4, -32, 4, 4, 0, PI);
      
    } else {
      // Struggling expression - also more distressed
      // Squinting, worried eyes
      fill(0);
      ellipse(-5, -44, 3, 2); // Squinting left eye
      ellipse(5, -44, 3, 2);  // Squinting right eye
      
      // Worried eyebrows
      stroke(0);
      strokeWeight(2);
      line(-8, -48, -3, -47); // Left worried eyebrow
      line(3, -47, 8, -48);   // Right worried eyebrow
      
      // Grimacing mouth - more pronounced
      stroke(0);
      strokeWeight(2);
      noFill();
      arc(0, -35, 8, 6, PI, TWO_PI); // Deeper grimace
    }
    
    // Traditional farmer hat (caping/wide-brimmed hat)
    fill(100, 70, 50, 200);
    noStroke();
    ellipse(0, -52, 45, 12); // Wide brim
    ellipse(0, -55, 25, 15); // Crown
    
    // Sweat drops (from hard work in the heat)
    if (scenePhase == 2) {
      fill(200, 220, 255, 150);
      ellipse(-10, -35, 2, 3);
      ellipse(12, -38, 2, 3);
    }
    
    popMatrix();
  }
  
  void drawWitheredRicePlants() {
    // Draw withered rice field based on Scene 1 but dried and dying
    noStroke();
    
    // Create wider rice field rows - more extensive than before
    for (int row = 0; row < 12; row++) { // More rows
      for (int col = 0; col < 30; col++) { // More columns
        float x = -50 + col * (width + 100) / 29; // Wider field
        float y = height - 180 + row * 12;
        
        // Skip some plants to show sparse, failing field (STATIC)
        if ((row * 30 + col) % 10 < 7) { // 70% chance to show plant (deterministic based on position)
          drawWitheredRicePlant(x, y);
        }
      }
    }
  }
  
  void drawWitheredRicePlant(float x, float y) {
    // Individual withered rice plant (based on Scene 1 but dried) - STATIC
    pushMatrix();
    translate(x, y);
    
    // Withered plant base/roots
    fill(60, 40, 20); // Brown, dried roots
    noStroke();
    ellipse(0, 0, 4, 3);
    
    // Draw withered stalks - bent and broken (STATIC positions)
    stroke(80, 50, 30); // Brown, dried stalks
    strokeWeight(1.5);
    
    // Main stalk (shorter, bent) - fixed position based on x coordinate
    float bentOffset = (x * 0.1) % 10 - 5; // Static offset based on position
    line(0, 0, bentOffset, -20);
    
    // Broken side stalks (static positions)
    if ((int)(x + y) % 5 < 3) { // Deterministic based on position
      line(-2, 0, -4, -12);
    }
    if ((int)(x + y * 1.3) % 5 < 3) {
      line(2, 0, 3, -15);
    }
    
    // Few remaining grain clusters (mostly empty) - static
    if ((int)(x * 1.7 + y) % 5 < 2) { // 40% chance based on position
      fill(150, 100, 60, 150); // Dried, empty grain husks
      noStroke();
      
      // Static, sparse grains
      ellipse(bentOffset - 1, -17, 1, 2);
      ellipse(bentOffset, -19, 1, 1.5);
      if ((int)(x + y * 2) % 10 < 3) {
        ellipse(bentOffset + 1, -18, 1, 1.5);
      }
    }
    
    // Withered leaves (drooping, brown) - STATIC positions
    fill(100, 60, 30, 120); // Brown, dying leaves
    noStroke();
    
    // Static drooping leaves
    pushMatrix();
    rotate(-0.4); // Fixed angle
    ellipse(0, -8, 2, 15);
    popMatrix();
    
    pushMatrix();
    rotate(0.3); // Fixed angle
    ellipse(0, -10, 2, 12);
    popMatrix();
    
    // Some leaves completely fallen (static)
    if ((int)(x * 0.7 + y * 1.1) % 10 < 3) {
      fill(80, 40, 20, 100);
      float fallenX = ((int)(x * 1.3) % 10) - 5;
      float fallenY = ((int)(y * 0.8) % 4) - 2;
      ellipse(fallenX, fallenY, 8, 2);
    }
    
    popMatrix();
  }
  
  void drawDroughtEffects() {
    // Add environmental details showing severe drought - STATIC VERSION
    
    // Static dust particles (no animation)
    fill(160, 120, 80, 100);
    noStroke();
    for (int i = 0; i < 20; i++) {
      float x = (i * 67) % width; // Static positions
      float y = height - 50 - (i * 13) % 100;
      ellipse(x, y, 3, 2);
    }
    
    // Dead vegetation scattered around (static)
    fill(80, 50, 20, 150);
    for (int i = 0; i < 15; i++) {
      float x = (i * 47) % width;
      float y = height - 30 - (i * 11) % 70;
      // Static dead branches/twigs
      stroke(60, 30, 15);
      strokeWeight(2);
      float angle = (i * 0.3) % TWO_PI;
      line(x, y, x + cos(angle) * 8, y + sin(angle) * 4);
    }
    
    // Dried mud patches (static)
    fill(90, 50, 25);
    noStroke();
    for (int i = 0; i < 8; i++) {
      float x = (i * 83) % width;
      float y = height - 40 - (i * 17) % 80;
      ellipse(x, y, 20 + (i % 3) * 8, 10 + (i % 2) * 5);
    }
  }
}

// Enhanced Crying Rice Grain class - MUCH MORE EMOTIONAL
class RiceGrain {
  PVector position;
  boolean isCrying;
  float tearTimer;
  float bobOffset;
  float emotionalIntensity;
  
  RiceGrain(float x, float y) {
    position = new PVector(x, y);
    isCrying = false;
    tearTimer = (x + y) % 60; // Static timer based on position for stability
    bobOffset = 0;
    emotionalIntensity = random(0.8, 1.2); // Individual emotional variation
  }
  
  void update() {
    isCrying = true;
    tearTimer++;
    // More dramatic bobbing motion when crying
    bobOffset = sin(frameCount * 0.08 + position.x * 0.01) * 3 * emotionalIntensity;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y + bobOffset);
    
    // ENHANCED Rice grain body - slightly larger and more expressive
    fill(255, 250, 240);
    stroke(200, 190, 180);
    strokeWeight(1);
    ellipse(0, 0, 10, 14); // Slightly larger for more presence
    
    // MUCH MORE EXPRESSIVE FACE
    fill(0);
    noStroke();
    
    if (isCrying) {
      // Squinting, crying eyes - more dramatic
      fill(0);
      ellipse(-2.5, -3, 3, 1.5); // Squinting left eye
      ellipse(2.5, -3, 3, 1.5);  // Squinting right eye
      
      // Worried eyebrows
      stroke(0);
      strokeWeight(0.5);
      line(-4, -5, -1, -4.5); // Left worried eyebrow
      line(1, -4.5, 4, -5);   // Right worried eyebrow
      
      // MUCH SADDER MOUTH - open crying
      stroke(0);
      strokeWeight(1);
      fill(100, 50, 50); // Dark mouth interior
      ellipse(0, 2, 4, 6); // Open crying mouth
      
      // Downturned mouth corners for extreme sadness
      noFill();
      stroke(0);
      strokeWeight(0.8);
      arc(-1.5, 2, 2, 2, 0, PI);
      arc(1.5, 2, 2, 2, 0, PI);
      
    } else {
      // Neutral expression when not crying
      ellipse(-2, -2, 1.5, 1.5); // Left eye
      ellipse(2, -2, 1.5, 1.5);  // Right eye
      
      // Neutral mouth
      stroke(0);
      strokeWeight(1);
      noFill();
      arc(0, 1, 4, 3, 0, PI);
    }
    
    // ENHANCED TEARS - much more dramatic and visible
    if (isCrying && tearTimer > 30) { // Start crying sooner
      fill(120, 180, 255, 220); // Brighter, more visible tears
      noStroke();
      
      // Main tear streams
      ellipse(-3, 0, 2.5, 8);  // Left main tear
      ellipse(3, 0, 2.5, 8);   // Right main tear
      
      // Secondary tears
      ellipse(-4, 2, 1.5, 6);  // Left secondary tear
      ellipse(4, 2, 1.5, 6);   // Right secondary tear
      
      // Falling tear drops
      if (tearTimer > 50) {
        ellipse(-3, 8, 2, 5);  // Left falling tear
        ellipse(3, 8, 2, 5);   // Right falling tear
      }
      
      // Additional small tear drops for more drama
      if (tearTimer > 70) {
        ellipse(-1, 6, 1.5, 3);
        ellipse(1, 6, 1.5, 3);
      }
      
      // Reset tear cycle
      if (tearTimer > 100) {
        tearTimer = 20; // Keep crying continuously
      }
    }
    
    // Add subtle glow effect when crying (emotional aura)
    if (isCrying) {
      fill(150, 200, 255, 30);
      noStroke();
      ellipse(0, 0, 20, 24); // Soft emotional glow
    }
    
    popMatrix();
  }
}
