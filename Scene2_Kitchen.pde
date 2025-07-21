// Scene2_Kitchen.pde
// Scene 2: Home - Kitchen, Late Afternoon (0:30 - 1:00)
// Refactored to match PROJECT_OUTLINE.md and improve movements.

class Scene2_Kitchen {
  // Characters
  Joko joko;
  Mom mom;

  // Kitchen environment
  ArrayList<KitchenItem> kitchenItems;
  PVector tableCenter;
  ArrayList<KitchenFoodItem> kitchenMeal;
  WallClock wallClock;

  // Scene elements
  boolean showFood;
  float lightingIntensity;
  float windowLightAngle;
  PVector trashCan;
  ArrayList<FoodWaste> wastedFood;

  // Animation timing
  int scenePhase; // 0: blank_stare, 1: mom_enters, 2: dialogue, 3: dismissal, 4: waste
  int phaseStartFrame;

  // Caption system
  String currentCaption;
  int captionStartFrame;
  int captionDuration;

  // Dialogue state
  int dialogueStep;
  
  // Sound effect timing for conversation endings
  int lastSpeakingEndFrame;
  boolean waitingForSoundEffect;
  String pendingSoundEffect;

  Scene2_Kitchen() {
    // Constructor
  }

  void init() {
    println("Initializing Scene 2: Kitchen (Refactored)");

    // Characters: Joko enters from left, Mom positioned behind table
    joko = new Joko(-100, height - 200); // Starts off-screen left
    mom = new Mom(width/2 + 100, height - 260); // Further behind table, higher for perspective

    // Environment
    setupKitchen();
    setupIndonesianMeal();
    
    // Lighting
    lightingIntensity = 0.95;
    windowLightAngle = PI/6;

    // Trash
    trashCan = new PVector(width - 100, height - 150);
    wastedFood = new ArrayList<FoodWaste>();

    // Initial state
    scenePhase = 0;
    phaseStartFrame = 0;
    dialogueStep = 0;
    showFood = true; // Food is already on table when scene starts
    currentCaption = "";
    
    // Initialize sound effect timing
    lastSpeakingEndFrame = 0;
    waitingForSoundEffect = false;
    pendingSoundEffect = "";
  }

  void setupKitchen() {
    kitchenItems = new ArrayList<KitchenItem>();
    tableCenter = new PVector(width/2, height - 180);

    kitchenItems.add(new KitchenItem("table", tableCenter.x, tableCenter.y, "dining table"));
    kitchenItems.add(new KitchenItem("window", width - 220, height - 480, "kitchen window"));
    kitchenItems.add(new KitchenItem("cabinet", 100, height - 320, "kitchen cabinet"));

    wallClock = new WallClock(120, height - 520);
  }

  void setupIndonesianMeal() {
    kitchenMeal = new ArrayList<KitchenFoodItem>();
    float centerX = tableCenter.x;
    float centerY = tableCenter.y - 30; // On the table

    kitchenMeal.add(new KitchenFoodItem("nasi", centerX, centerY, "steamed rice"));
    kitchenMeal.add(new KitchenFoodItem("sayur_bening", centerX + 50, centerY, "sayur bening"));
    kitchenMeal.add(new KitchenFoodItem("tempe", centerX - 50, centerY, "tempeh"));
  }

  void update(int sceneFrame) {
    int phaseFrame = sceneFrame - phaseStartFrame;

    // --- Phase Transitions (Total 30 seconds = 900 frames at 30fps) ---
    if (scenePhase == 0 && phaseFrame > 90) { // 3s for Joko to enter
      startPhase(1, sceneFrame);
    } else if (scenePhase == 1 && phaseFrame > 60) { // 2s for sitting down
      startPhase(2, sceneFrame);
    } else if (scenePhase == 2 && dialogueStep > 6) { // Dialogue finished
       startPhase(3, sceneFrame);
    } else if (scenePhase == 3 && phaseFrame > 300) { // Increased from 420 to give more dialogue time
       startPhase(4, sceneFrame);
    }

    // --- Update based on current phase ---
    switch (scenePhase) {
      case 0: updateJokoEnters(phaseFrame); break;
      case 1: updateJokoSits(phaseFrame); break;
      case 2: updateDialogue(phaseFrame, sceneFrame); break;
      case 3: updateDismissal(phaseFrame, sceneFrame); break;
      case 4: updateWasteAndExit(phaseFrame, sceneFrame); break;
    }

    // Update characters and environment
    joko.update();
    mom.update();
    wallClock.update();
    windowLightAngle += 0.002;
    
    // Check for scheduled conversation sound effects
    checkConversationSoundEffects(sceneFrame);

    // Update wasted food particles
    for (int i = wastedFood.size() - 1; i >= 0; i--) {
      FoodWaste waste = wastedFood.get(i);
      waste.update();
      if (waste.isFinished()) {
        wastedFood.remove(i);
      }
    }
  }

  void startPhase(int newPhase, int currentFrame) {
    scenePhase = newPhase;
    phaseStartFrame = currentFrame;
    println("Scene 2, Phase " + newPhase + " started at frame " + currentFrame);
  }

  void setCaption(String text, int durationFrames, int currentFrame) {
    currentCaption = text;
    captionDuration = durationFrames;
    captionStartFrame = currentFrame;
    
    // Debug logging to help track caption timing
    println("Scene2 Caption Set: \"" + text + "\" at frame " + currentFrame + " for " + durationFrames + " frames");
  }
  
  // Function to schedule sound effect after speaking ends
  void scheduleConversationEndSound(String soundName, int currentFrame) {
    lastSpeakingEndFrame = currentFrame;
    waitingForSoundEffect = true;
    pendingSoundEffect = soundName;
    println("Scheduled sound effect: " + soundName + " to play 1 second after frame " + currentFrame);
  }
  
  // Function to check and play scheduled sound effects
  void checkConversationSoundEffects(int currentFrame) {
    if (waitingForSoundEffect && (currentFrame - lastSpeakingEndFrame) >= 30) { // 30 frames = 1 second at 30fps
      if (audioManager != null) {
        audioManager.playSound(pendingSoundEffect);
        println("Playing conversation end sound: " + pendingSoundEffect);
      }
      waitingForSoundEffect = false;
      pendingSoundEffect = "";
    }
  }

  // --- Phase Logic ---

  void updateJokoEnters(int phaseFrame) {
    // Joko enters from left side, walking to the table
    if (joko.position.x < width/2 - 60) {
      joko.moveTo(width/2 - 60, height - 200, 2.0);
      joko.setAnimation("walking");
    } else {
      joko.stop();
      joko.setAnimation("idle");
    }
    
    // Mom is already positioned behind table, doing idle animation
    mom.setAnimation("idle");
    mom.stop();
  }

  void updateJokoSits(int phaseFrame) {
    // Joko sits down at the table
    joko.setAnimation("sitting");
    joko.stop();
    joko.position.y = height - 190; // Slightly higher when sitting
    
    // Mom starts to show concern
    mom.setAnimation("concerned");
    mom.stop();
  }

  void updateMomEnters(int phaseFrame) {
    // This method is no longer used - keeping for compatibility
    mom.setAnimation("serving");
    joko.setAnimation("blank_stare");
  }

  void updateDialogue(int phaseFrame, int sceneFrame) {
    // OPTIMIZED DIALOGUE - Avoiding narration conflicts
    // Narration happens at: 15 (0.5s), 360 (12s), 720 (24s)
    
    mom.setAnimation("concerned");

    if (dialogueStep == 0 && phaseFrame > 120) { // Start well after opening narration (4 seconds)
      mom.startSpeaking(3.0);
      setCaption("Ibu: \"Ayo makan, Nak. Ibu masak sayur bening, tempenya masih hangat.\"", 120, sceneFrame);
      dialogueStep = 1;
      joko.setAnimation("dismissive");
      // Schedule sound effect after mom stops speaking
      scheduleConversationEndSound("alien-talking", sceneFrame + 120);
    }
    if (dialogueStep == 1 && phaseFrame > 270) { // Give more space before next dialogue
      mom.startSpeaking(3.5);
      setCaption("Ibu: \"Kalau nggak dihabisin, makanannya bisa nangis, lho…\"", 135, sceneFrame);
      dialogueStep = 2;
      // Schedule sound effect after mom stops speaking
      scheduleConversationEndSound("alien-talking", sceneFrame + 135);
    }
    if (dialogueStep == 2 && phaseFrame > 420) { // Wait until after second narration (14 seconds)
      // Before Joko speaks, make him move to front of table
      if (joko.position.x < width/2 - 20) {
        joko.setAnimation("walking");
        joko.moveTo(width/2 - 20, height - 200, 2.0);
      } else {
        joko.stop();
        joko.setAnimation("dismissive");
        if (phaseFrame > 450) { // Quicker transition
          joko.startSpeaking(3.0);
          setCaption("Joko: \"Nggak lapar. Lagian, makanan nggak bisa nangis.\"", 120, sceneFrame);
          dialogueStep = 3;
          // Schedule sound effect after Joko stops speaking
          scheduleConversationEndSound("alien-talking", sceneFrame + 120);
        }
      }
    }
     if (dialogueStep == 3 && phaseFrame > 600) { // Give more time between dialogues
      mom.startSpeaking(5.5);
      setCaption("Ibu: \"Bukan karena punya mata, tapi karena ada yang capek nanem, masak, nyiapin.\"", 195, sceneFrame);
      dialogueStep = 4;
      // Schedule sound effect after mom stops speaking
      scheduleConversationEndSound("alien-talking", sceneFrame + 195);
    }
    if (dialogueStep == 4 && phaseFrame > 810) { // Wait for previous dialogue to finish
       mom.startSpeaking(2.5);
       setCaption("Ibu: \"Dibuang gitu aja... mereka sedih.\"", 105, sceneFrame);
       dialogueStep = 5;
       // Schedule sound effect after mom stops speaking
       scheduleConversationEndSound("alien-talking", sceneFrame + 105);
    }
    if (dialogueStep == 5 && phaseFrame > 930) { // Well after third narration (31 seconds)
      joko.startSpeaking(2.0);
      setCaption("Joko: \"Yaudah, nanti dimakan...\"", 90, sceneFrame);
      dialogueStep = 6;
      // Schedule sound effect after Joko stops speaking
      scheduleConversationEndSound("alien-talking", sceneFrame + 90);
    }
     if (dialogueStep == 6 && phaseFrame > 1050) {
      dialogueStep = 7; // End of dialogue
    }
  }

  void updateDismissal(int phaseFrame, int sceneFrame) {
    // STREAMLINED - Reduced dialogue for better pacing
    mom.setAnimation("very_disappointed");
    joko.setAnimation("dismissive");

    if (phaseFrame == 30) {
        mom.startSpeaking(4.0);
        setCaption("Ibu: \"Ibu nggak maksa... Tapi kalau tiap hari kayak gini, Ibu juga capek, Nak.\"", 120, sceneFrame);
        // Schedule sound effect after mom stops speaking
        scheduleConversationEndSound("alien-talking", sceneFrame + 120);
    }
    if (phaseFrame == 180) {
        mom.startSpeaking(2.5);
        setCaption("Ibu: \"Besok masak setengah aja... biar nggak kebuang lagi.\"", 75, sceneFrame);
        // Schedule sound effect after mom stops speaking
        scheduleConversationEndSound("alien-talking", sceneFrame + 75);
    }
  }

  void updateWasteAndExit(int phaseFrame, int sceneFrame) {
    // Mom exits sadly
    if (phaseFrame > 30 && mom.position.x > -150) {
        mom.moveTo(-150, height - 240, 2);
        mom.setAnimation("walking_sad");
    }

    // Joko's enhanced sequence to waste food with proper movement
    if (phaseFrame > 60) {
      // Phase 1: Pick up the bowl and stand
      if (phaseFrame >= 60 && phaseFrame < 120) {
        joko.setAnimation("picking_up");
        joko.position.y = height - 200; // Stand up
      }
      // Phase 2: Walk to trash can with bowl
      else if (phaseFrame >= 120 && phaseFrame < 240) {
        if (joko.position.x < trashCan.x - 50) {
          joko.setAnimation("carrying_plate");
          joko.moveTo(trashCan.x - 50, height - 200, 2.5);
        } else {
          joko.stop();
          joko.setAnimation("holding_plate");
        }
      }
      // Phase 3: Throw the rice
      else if (phaseFrame >= 240 && phaseFrame < 300) {
        joko.setAnimation("throwing");
        if (phaseFrame % 8 == 0) { // Create waste particles over duration
          createFoodWaste();
        }
      }
      // Phase 4: Look dismissive after throwing
      else if (phaseFrame >= 300 && phaseFrame < 450) { // Extended to allow caption to finish
        joko.setAnimation("dismissive");
        if (phaseFrame == 320) {
          joko.startSpeaking(2.0);
          setCaption("Joko: \"Tuh, nggak nangis kan.\"", 120, sceneFrame);
          // Schedule sound effect after Joko stops speaking
          scheduleConversationEndSound("alien-talking", sceneFrame + 120);
        }
      }
      // Phase 5: Walk back to table
      else if (phaseFrame >= 450 && phaseFrame < 570) { // Adjusted start time
        if (joko.position.x > width/2 - 60) {
          joko.setAnimation("walking");
          joko.moveTo(width/2 - 60, height - 200, 2.0);
        } else {
          joko.stop();
        }
      }
      // Phase 6: Put bowl back on table and sit
      else if (phaseFrame >= 570) { // Adjusted start time
        joko.setAnimation("putting_down");
        joko.position.y = height - 190; // Sit back down
      }
    }
  }

  void createFoodWaste() {
    for (int i = 0; i < 3; i++) {
      wastedFood.add(new FoodWaste(trashCan.x, trashCan.y - 40, "nasi"));
      wastedFood.add(new FoodWaste(trashCan.x, trashCan.y - 40, "sayur_bening"));
      wastedFood.add(new FoodWaste(trashCan.x, trashCan.y - 40, "tempe"));
    }
  }

  // --- Drawing Methods ---

  void draw() {
    drawKitchenBackground();
    
    // Draw mom first (behind table)
    mom.draw();
    
    // Then draw furniture and table (in front of mom)
    drawKitchenFurniture();
    wallClock.draw();
    
    if (showFood) {
      drawIndonesianMeal();
    }
    
    drawTrashCan();
    for (FoodWaste waste : wastedFood) {
      waste.draw();
    }

    // Draw joko last (in front of everything)
    joko.draw();
    drawCaption();
  }

  void drawKitchenBackground() {
    color topColor = color(255, 235, 210);
    color bottomColor = color(210, 190, 170);
    for (int i = 0; i < height; i++) {
      stroke(lerpColor(topColor, bottomColor, (float)i / height));
      line(0, i, width, i);
    }
    drawWindowAndLight();
  }

  void drawWindowAndLight() {
    PVector windowPos = new PVector(width - 220, height - 480);
    // Frame
    fill(160, 130, 100);
    noStroke();
    rect(windowPos.x - 10, windowPos.y - 10, 170, 170, 5);
    // Pane
    fill(150, 190, 230);
    rect(windowPos.x, windowPos.y, 150, 150);
    // Crossbars
    fill(160, 130, 100);
    rect(windowPos.x, windowPos.y + 70, 150, 10);
    rect(windowPos.x + 70, windowPos.y, 10, 150);

    // Light shaft
    pushMatrix();
    translate(windowPos.x + 75, windowPos.y + 75);
    rotate(windowLightAngle);
    noStroke();
    for (int i = 250; i > 0; i -= 10) {
      fill(255, 245, 200, 8);
      triangle(0, 0, -i, height, i, height);
    }
    popMatrix();
  }

  void drawKitchenFurniture() {
    for (KitchenItem item : kitchenItems) {
      item.draw();
    }
  }

  void drawIndonesianMeal() {
    for (KitchenFoodItem food : kitchenMeal) {
      food.draw(); // Now uses the enhanced KitchenFoodItem class
    }
  }

  void drawTrashCan() {
    fill(110, 110, 110);
    noStroke();
    rect(trashCan.x - 50, trashCan.y - 60, 100, 120, 8);
    fill(90, 90, 90);
    rect(trashCan.x - 55, trashCan.y - 75, 110, 20, 5);
    fill(40, 40, 40);
    ellipse(trashCan.x, trashCan.y - 60, 80, 25);
  }

  void drawCaption() {
    if (currentCaption != null && currentCaption.length() > 0) {
      int currentFrame = frameCount - captionStartFrame;
      if (currentFrame >= 0 && currentFrame < captionDuration) {
        // Check if AudioManager narration is active to avoid overlap
        // Using global audioManager reference from main sketch
        boolean narrationActive = false;
        if (audioManager != null) {
          narrationActive = audioManager.isNarrationActive();
        }
        
        // Debug logging - always show when caption should be visible
        println("Scene2 Caption ACTIVE: frame=" + currentFrame + "/" + captionDuration + 
                ", narrationActive=" + narrationActive + ", text=\"" + currentCaption + "\"");
        
        // Dynamic positioning system for maximum visibility
        float captionY = height - 120; // Higher base position for better visibility
        if (narrationActive) {
          // Move caption to top area when narration is active
          captionY = 120; // Top area instead of bottom
        }
        
        pushMatrix();
        pushStyle();
        
        // Calculate fade-in/fade-out animation for captions
        float fadeAlpha = 255;
        int fadeInFrames = 8; // Faster fade in for immediate visibility
        int fadeOutFrames = 15; // Longer fade out to ensure visibility
        
        if (currentFrame < fadeInFrames) {
          fadeAlpha = map(currentFrame, 0, fadeInFrames, 100, 255); // Start with some opacity
        } else if (currentFrame > captionDuration - fadeOutFrames) {
          fadeAlpha = map(currentFrame, captionDuration - fadeOutFrames, captionDuration, 255, 100); // End with some opacity
        }
        
        // Determine speaker for character-specific styling
        boolean isJoko = currentCaption.toLowerCase().contains("joko:");
        boolean isMother = currentCaption.toLowerCase().contains("mother:") || 
                          currentCaption.toLowerCase().contains("mom:") || 
                          currentCaption.toLowerCase().contains("ibu:");
        
        // Enhanced typography with larger text for maximum visibility
        textSize(24); // Increased from 20 to 24 for even better visibility
        PFont captionFont = createFont("Arial Bold", 24); // Bold font for better readability
        textFont(captionFont);
        
        // Smart text wrapping
        float maxWidth = width - 160;
        float textW = textWidth(currentCaption);
        
        ArrayList<String> lines = new ArrayList<String>();
        if (textW > maxWidth) {
          String[] words = split(currentCaption, " ");
          String currentLine = "";
          
          for (String word : words) {
            String testLine = currentLine.length() > 0 ? currentLine + " " + word : word;
            if (textWidth(testLine) < maxWidth) {
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
          lines.add(currentCaption);
        }
        
        // Calculate positioning with larger line height
        float lineHeight = 28; // Increased from 24 to 28 for larger text
        float bgWidth = maxWidth + 40;
        float bgHeight = (lines.size() * lineHeight) + 20;
        float bgX = width/2;
        float bgY = captionY - (bgHeight/2);
        
        // Character-specific colors
        color speakerColor = color(180, 220, 255); // Default
        color borderColor = color(100, 150, 200);
        
        if (isJoko) {
          speakerColor = color(255, 220, 180); // Warm orange for Joko
          borderColor = color(200, 150, 100);
        } else if (isMother) {
          speakerColor = color(255, 180, 220); // Pink for mother
          borderColor = color(200, 100, 150);
        }
        
        // Draw background with enhanced glow for better visibility
        for (int i = 0; i < 8; i++) { // Increased glow layers from 5 to 8
          float alpha = map(i, 0, 7, fadeAlpha * 0.4, 0); // Enhanced glow intensity
          fill(red(borderColor), green(borderColor), blue(borderColor), alpha);
          noStroke();
          rectMode(CENTER);
          rect(bgX, bgY, bgWidth + (i * 4), bgHeight + (i * 4), 12 + i); // Increased glow spread
        }
        
        // Main background with stronger opacity for better visibility
        fill(20, 25, 35, fadeAlpha * 0.98); // Increased opacity from 0.95 to 0.98
        stroke(red(borderColor), green(borderColor), blue(borderColor), fadeAlpha * 0.9); // Increased border opacity
        strokeWeight(2); // Increased stroke weight from 1.5 to 2
        rect(bgX, bgY, bgWidth, bgHeight, 8);
        
        // Inner accent
        stroke(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha * 0.4);
        strokeWeight(1);
        noFill();
        rect(bgX, bgY, bgWidth - 6, bgHeight - 6, 6);
        
        // Text with shadow
        textAlign(CENTER, CENTER);
        fill(0, 0, 0, fadeAlpha * 0.6);
        for (int i = 0; i < lines.size(); i++) {
          float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight) + 1;
          text(lines.get(i), bgX + 1, yPos + 1);
        }
        
        // Main text
        fill(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha);
        for (int i = 0; i < lines.size(); i++) {
          float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight);
          text(lines.get(i), bgX, yPos);
        }
        
        // Speaking indicator
        if (currentFrame < captionDuration - 20) {
          float pulseAlpha = (sin(frameCount * 0.3) + 1) * 0.3 * fadeAlpha;
          fill(red(speakerColor), green(speakerColor), blue(speakerColor), pulseAlpha);
          noStroke();
          ellipse(bgX - (bgWidth/2) + 12, bgY - (bgHeight/2) + 8, 4, 4);
        }
        
        popStyle();
        popMatrix();
      }
    }
  }
}

// ===================================
// Helper classes for Scene 2
// ===================================

class KitchenItem {
  String type;
  PVector position;
  String description;

  KitchenItem(String itemType, float x, float y, String desc) {
    type = itemType;
    position = new PVector(x, y);
    description = desc;
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    if (type.equals("table")) drawTable();
    else if (type.equals("cabinet")) drawCabinet();
    popMatrix();
  }

  void drawTable() {
    // Enhanced table with perspective
    fill(139, 69, 19);
    noStroke();
    rectMode(CENTER);
    
    // Table top with perspective (closer edge appears lower)
    fill(160, 90, 40);
    quad(-175, -20, 175, -20, 150, 5, -150, 5); // Perspective tabletop
    
    // Table edge
    fill(139, 69, 19);
    rect(0, 5, 325, 8, 2); // Table edge/thickness
    
    rectMode(CORNER);
    
    // Table legs with perspective
    fill(101, 50, 0);
    // Front legs (closer, appear bigger)
    rect(-140, 12.5, 18, 90, 3);
    rect(125, 12.5, 18, 90, 3);
    // Back legs (farther, appear smaller and higher)
    rect(-120, 5, 15, 80, 3);
    rect(105, 5, 15, 80, 3);
    
    // Table shadow on floor
    fill(0, 0, 0, 30);
    ellipse(0, 110, 320, 40);
  }

  void drawCabinet() {
    fill(200, 180, 160);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, 160, 220, 5); // Main frame
    fill(180, 160, 140);
    rect(-40, 0, 70, 200, 3); // Left door
    rect(40, 0, 70, 200, 3); // Right door
    fill(100);
    ellipse(-40, 0, 10, 10); // Left handle
    ellipse(40, 0, 10, 10); // Right handle
    rectMode(CORNER);
  }
}

class WallClock {
  PVector position;

  WallClock(float x, float y) {
    position = new PVector(x, y);
  }

  void update() {
    // Hand positions are calculated in draw()
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    // Face
    fill(245, 235, 220);
    stroke(80, 60, 40);
    strokeWeight(5);
    ellipse(0, 0, 90, 90);
    // Center pin
    fill(0);
    noStroke();
    ellipse(0, 0, 5, 5);

    // Hands
    float s = second();
    float m = minute() + s/60.0;
    float h = hour() + m/60.0;

    // Hour hand
    stroke(0);
    strokeWeight(4);
    line(0, 0, cos(radians(h * 30 - 90)) * 25, sin(radians(h * 30 - 90)) * 25);
    // Minute hand
    strokeWeight(3);
    line(0, 0, cos(radians(m * 6 - 90)) * 35, sin(radians(m * 6 - 90)) * 35);
    // Second hand
    stroke(255, 0, 0);
    strokeWeight(1);
    line(0, 0, cos(radians(s * 6 - 90)) * 40, sin(radians(s * 6 - 90)) * 40);
    popMatrix();
  }
}

class FoodWaste {
  PVector position;
  PVector velocity;
  float gravity;
  String type;
  int lifespan;
  color c;
  float size;

  FoodWaste(float x, float y, String wasteType) {
    position = new PVector(x, y);
    velocity = new PVector(random(-2.5, 2.5), random(-6, -2));
    gravity = 0.25;
    type = wasteType;
    lifespan = 150;
    size = random(4, 8);

    if (type.equals("nasi")) c = color(255, 255, 250);
    else if (type.equals("sayur_bening")) c = color(60, 140, 60);
    else if (type.equals("tempe")) c = color(170, 130, 70);
  }

  void update() {
    velocity.y += gravity;
    position.add(velocity);
    lifespan--;
  }

  void draw() {
    noStroke();
    fill(c, map(lifespan, 0, 150, 0, 255));
    ellipse(position.x, position.y, size, size);
  }

  boolean isFinished() {
    return lifespan <= 0;
  }
}

// Enhanced KitchenFoodItem class for Scene 2 with better rice bowl appearance
class KitchenFoodItem {
  String type;
  PVector position;
  String description;
  boolean isBeingEaten;
  float eatAmount;
  
  KitchenFoodItem(String foodType, float x, float y, String desc) {
    type = foodType;
    position = new PVector(x, y);
    description = desc;
    isBeingEaten = false;
    eatAmount = 1.0; // 1.0 = full, 0.0 = empty
  }
  
  void draw() {
    // Enhanced drawing method with better perspective and appearance
    pushMatrix();
    translate(position.x, position.y);
    
    if (type.equals("nasi")) {
      drawEnhancedRiceBowl();
    } else if (type.equals("sayur_bening")) {
      drawEnhancedVegetables();
    } else if (type.equals("tempe")) {
      drawEnhancedTempeh();
    }
    
    popMatrix();
  }
  
  void drawEnhancedRiceBowl() {
    // Much more realistic and appetizing rice bowl
    
    // Bowl shadow on table
    fill(0, 0, 0, 40);
    noStroke();
    ellipse(2, 8, 45, 25);
    
    // Bowl base with perspective
    fill(240, 240, 245); // Light ceramic bowl
    stroke(200, 200, 210);
    strokeWeight(2);
    
    // Bowl bottom (perspective ellipse)
    ellipse(0, 4, 40 * eatAmount, 25 * eatAmount);
    
    // Bowl sides
    fill(250, 250, 255);
    ellipse(0, -2, 42 * eatAmount, 12 * eatAmount); // Bowl rim
    
    // Bowl interior shadow
    fill(230, 230, 240);
    ellipse(0, 2, 36 * eatAmount, 20 * eatAmount);
    
    // Rice with individual grains and texture
    noStroke();
    
    // Main rice mound - fluffy and realistic
    fill(255, 255, 252);
    ellipse(0, -3, 32 * eatAmount, 18 * eatAmount);
    
    // Individual rice grains for texture
    fill(252, 252, 248);
    for (int i = 0; i < 15 * eatAmount; i++) {
      float angle = random(TWO_PI);
      float radius = random(12 * eatAmount);
      float x = cos(angle) * radius;
      float y = sin(angle) * radius * 0.6 - 3;
      ellipse(x, y, 1.5, 1);
    }
    
    // Highlight on rice (makes it look fluffy and fresh)
    fill(255, 255, 255, 180);
    ellipse(-4, -8, 8 * eatAmount, 5 * eatAmount);
    
    // Steam effect (if rice is hot)
    stroke(255, 255, 255, 100);
    strokeWeight(1);
    for (int i = 0; i < 3; i++) {
      float steamX = random(-8, 8);
      line(steamX, -12, steamX + random(-2, 2), -20);
    }
  }
  
  void drawEnhancedVegetables() {
    // Sayur bening in a small side bowl
    fill(245, 245, 250); // Small bowl
    stroke(200, 200, 210);
    strokeWeight(1);
    ellipse(0, 2, 25, 15);
    
    // Green vegetables
    fill(60, 140, 60);
    noStroke();
    ellipse(-3, -1, 6, 4);
    ellipse(3, -2, 5, 4);
    ellipse(0, 1, 4, 3);
    
    // Broth
    fill(180, 200, 160, 150);
    ellipse(0, 1, 20, 12);
  }
  
  void drawEnhancedTempeh() {
    // Golden fried tempeh pieces
    fill(200, 150, 80); // Golden brown
    stroke(170, 120, 50);
    strokeWeight(1);
    
    // Multiple tempeh pieces
    rect(-8, -2, 6, 4, 1);
    rect(2, -3, 7, 5, 1);
    rect(-2, 2, 5, 3, 1);
    
    // Texture lines on tempeh
    stroke(150, 100, 40);
    strokeWeight(0.5);
    line(-6, -1, -4, 1);
    line(4, -1, 7, 1);
    line(0, 3, 2, 4);
  }
}
