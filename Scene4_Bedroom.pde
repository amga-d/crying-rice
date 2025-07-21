// Scene4_Bedroom.pde
// Scene 4: Awakening - Bedroom, Night to Morning (1:30 - 2:30)

class Scene4_Bedroom {
  // Characters
  Joko joko;
  Mom mom;
  
  // Bedroom environment
  PVector bed;
  PVector window;
  PVector door;
  PVector clock;
  ArrayList<PVector> furniture;
  
  // Lighting effects
  float roomBrightness;
  float moonlightIntensity;
  color moonlightColor;
  float morningLightIntensity;
  
  // Sleep animation
  float sleepCycle;
  boolean isAsleep;
  boolean isRestless;
  boolean hasAwakened;
  
  // Food waste elements
  PVector plateOnFloor;
  ArrayList<FoodScrap> foodScraps;
  boolean showFoodWaste;
  
  // Nightmare effects
  float nightmareIntensity;
  ArrayList<NightmareVisual> nightmareElements;
  boolean inNightmare;
  
  // Resolution elements
  boolean momEntered;
  boolean conversationStarted;
  boolean emotionalMoment;
  boolean peacefulEnding;
  
  // Animation timing
  int scenePhase; // 0: nightmare, 1: awakening, 2: mom enters, 3: conversation, 4: resolution, 5: morning peace
  int phaseStartFrame;
  
  // Caption system
  String currentCaption;
  int captionStartFrame;
  int captionDuration;
  
  // Sound effect timing for conversation endings
  int lastSpeakingEndFrame;
  boolean waitingForSoundEffect;
  String pendingSoundEffect;
  
  Scene4_Bedroom() {
    // Constructor - initialize basic properties
    furniture = new ArrayList<PVector>();
    foodScraps = new ArrayList<FoodScrap>();
    nightmareElements = new ArrayList<NightmareVisual>();
  }
  
  void init() {
    // Initialize scene
    println("Initializing Scene 4: Awakening - Bedroom");
    
    // Start horror background music for nightmare and awakening sequence
    if (audioManager != null) {
      audioManager.startHorrorMusic(4);
    }
    
    // Create Joko character - starting in deep sleep/nightmare
    joko = new Joko(width * 0.7 - 30, height - 150);
    joko.setAnimation("sleeping_restless");
    
    // Create Mom character (initially offscreen)
    mom = new Mom(-100, height - 200);
    mom.setAnimation("concerned");
    
    // Setup bedroom environment
    setupBedroom();
    
    // Initialize lighting - night time
    roomBrightness = 0.1; // Very dim night
    moonlightIntensity = 0.3;
    moonlightColor = color(150, 180, 255);
    morningLightIntensity = 0;
    
    // Initialize sleep state
    sleepCycle = 0;
    isAsleep = true;
    isRestless = true;
    hasAwakened = false;
    
    // Initialize resolution states
    momEntered = false;
    conversationStarted = false;
    emotionalMoment = false;
    peacefulEnding = false;
    
    // Initialize nightmare state (starting in nightmare)
    nightmareIntensity = 0.6;
    inNightmare = true;
    
    // Set initial phase - start with nightmare continuation
    scenePhase = 0;
    phaseStartFrame = 0;
    
    // Clear caption
    currentCaption = "";
    captionStartFrame = 0;
    captionDuration = 0;
    
    // Initialize sound effect timing
    lastSpeakingEndFrame = 0;
    waitingForSoundEffect = false;
    pendingSoundEffect = "";
  }
  
  void setupBedroom() {
    // Bed position
    bed = new PVector(width * 0.7, height - 150);
    
    // Window position
    window = new PVector(width * 0.2, height * 0.3);
    
    // Door position
    door = new PVector(50, height - 300);
    
    // Clock position
    clock = new PVector(width * 0.8, height * 0.25);
    
    // Furniture positions
    furniture.clear();
    furniture.add(new PVector(width * 0.1, height - 120)); // Desk
    furniture.add(new PVector(width * 0.9, height - 140)); // Dresser
    furniture.add(new PVector(width * 0.4, height - 90));  // Chair
    
    // Setup food scraps
    foodScraps.clear();
    // Will be added during the scene
  }
  
  void update(int sceneFrame) {
    // Update phase timing
    int phaseFrame = sceneFrame - phaseStartFrame;
    
    // Phase transitions based on timing (60 seconds total = 1800 frames at 30fps)
    switch(scenePhase) {
      case 0: // Nightmare continuation (0-15 seconds)
        if (phaseFrame >= 450) { // 15 seconds
          scenePhase = 1;
          phaseStartFrame = sceneFrame;
          setCaption("Joko mulai terbangun dari mimpi buruk...", 120);
          scheduleConversationEndSound("alien-talking", sceneFrame + 120);
        }
        break;
        
      case 1: // Emotional awakening (15-25 seconds)
        if (phaseFrame >= 300) { // 10 seconds
          scenePhase = 2;
          phaseStartFrame = sceneFrame;
          momEntered = true;
          setCaption("Ibu masuk melihat anaknya menangis...", 120);
          scheduleConversationEndSound("alien-talking", sceneFrame + 120);
        }
        break;
        
      case 2: // Mom enters (25-35 seconds)
        if (phaseFrame >= 300) { // 10 seconds
          scenePhase = 3;
          phaseStartFrame = sceneFrame;
          conversationStarted = true;
          setCaption("\"Nak, kamu kenapa?\" tanya Ibu dengan lembut...", 150);
          scheduleConversationEndSound("alien-talking", sceneFrame + 150);
        }
        break;
        
      case 3: // Heart-to-heart conversation (35-50 seconds)
        if (phaseFrame >= 450) { // 15 seconds
          scenePhase = 4;
          phaseStartFrame = sceneFrame;
          emotionalMoment = true;
          setCaption("\"Maaf Bu... Joko sekarang mengerti...\"", 150);
          scheduleConversationEndSound("alien-talking", sceneFrame + 150);
        }
        break;
        
      case 4: // Emotional resolution (50-60 seconds)
        if (phaseFrame >= 300) { // 10 seconds
          scenePhase = 5;
          phaseStartFrame = sceneFrame;
          peacefulEnding = true;
          
          // Fade out horror music as scene becomes peaceful
          if (audioManager != null) {
            audioManager.fadeOutHorrorMusic();
          }
          
          setCaption("Pelukan hangat saat fajar menyingsing...", 180);
          scheduleConversationEndSound("alien-talking", sceneFrame + 180);
        }
        break;
        
      case 5: // Morning peace (continues until scene ends)
        // Final peaceful state
        break;
    }
    
    // Update based on current phase
    updatePhaseSpecific(sceneFrame, phaseFrame);
    
    // Update characters
    joko.update();
    if (momEntered) {
      mom.update();
    }
    
    // Update environmental effects
    updateLighting(sceneFrame);
    updateSleepAnimation();
    updateNightmareEffects(phaseFrame);
    
    // Check for scheduled conversation sound effects
    checkConversationSoundEffects(sceneFrame);
    
    // Update caption timing
    updateCaption();
  }
  
  void updatePhaseSpecific(int sceneFrame, int phaseFrame) {
    switch(scenePhase) {
      case 0: // Nightmare continuation
        isRestless = true;
        inNightmare = true;
        joko.setAnimation("sleeping_nightmare");
        
        // Add nightmare elements periodically
        if (phaseFrame % 90 == 0 && nightmareElements.size() < 8) {
          addNightmareElement();
        }
        
        // Intensify nightmare towards the end
        nightmareIntensity = map(phaseFrame, 0, 450, 0.6, 1.0);
        
        // Dynamically adjust horror music volume based on nightmare intensity
        if (audioManager != null) {
          float horrorVolume = map(nightmareIntensity, 0.6, 1.0, 0.15, 0.35);
          audioManager.setHorrorMusicVolume(horrorVolume);
        }
        break;
        
      case 1: // Emotional awakening
        // Joko wakes up dramatically
        if (phaseFrame < 60) {
          joko.setAnimation("waking_startled");
          inNightmare = false;
          nightmareIntensity = max(0, nightmareIntensity - 0.05);
          
          // Reduce horror music volume as nightmare ends
          if (audioManager != null) {
            float horrorVolume = map(phaseFrame, 0, 60, 0.35, 0.15);
            audioManager.setHorrorMusicVolume(horrorVolume);
          }
        } else if (phaseFrame < 180) {
          joko.setAnimation("sitting_tears");
          hasAwakened = true;
          isAsleep = false;
          
          // Keep horror music low but present during emotional awakening
          if (audioManager != null && phaseFrame == 60) {
            audioManager.setHorrorMusicVolume(0.1);
          }
        } else {
          joko.setAnimation("reflecting");
        }
        break;
        
      case 2: // Mom enters
        // Mom walks in gently
        if (phaseFrame < 150) {
          mom.moveTo(width * 0.4, height - 200, 0.8);
          mom.setAnimation("walking_concerned");
        } else {
          mom.stop();
          mom.setAnimation("approaching_gently");
          if (phaseFrame > 200) {
            mom.moveTo(width * 0.5, height - 180, 0.5);
          }
        }
        break;
        
      case 3: // Heart-to-heart conversation
        joko.setAnimation("talking_emotional");
        mom.setAnimation("listening_caring");
        
        // Position them for conversation
        joko.moveTo(bed.x - 30, bed.y + 20, 0.3);
        mom.moveTo(bed.x - 80, bed.y + 30, 0.3);
        
        // Add emotional gestures periodically
        if (phaseFrame % 120 == 0) {
          joko.setAnimation("gesturing_sorry");
        } else if (phaseFrame % 120 == 60) {
          mom.setAnimation("comforting_gesture");
        }
        break;
        
      case 4: // Emotional resolution
        emotionalMoment = true;
        
        if (phaseFrame < 150) {
          joko.setAnimation("apologizing");
          mom.setAnimation("understanding");
        } else {
          joko.setAnimation("hugging");
          mom.setAnimation("hugging");
          // Move them closer for embrace
          joko.moveTo(bed.x - 50, bed.y + 10, 0.5);
          mom.moveTo(bed.x - 60, bed.y + 10, 0.5);
        }
        break;
        
      case 5: // Morning peace
        peacefulEnding = true;
        joko.setAnimation("peaceful");
        mom.setAnimation("smiling_proud");
        
        // They sit together peacefully
        joko.moveTo(bed.x - 40, bed.y + 15, 0.2);
        mom.moveTo(bed.x - 70, bed.y + 20, 0.2);
        break;
    }
  }
  
  void updateLighting(int sceneFrame) {
    // Lighting changes based on scene phase
    switch(scenePhase) {
      case 0: // Nightmare - very dark
        roomBrightness = 0.05 + sin(frameCount * 0.1) * 0.05; // Flickering darkness
        moonlightIntensity = 0.2;
        morningLightIntensity = 0;
        break;
        
      case 1: // Awakening - slightly brighter
        roomBrightness = 0.15;
        moonlightIntensity = 0.3;
        morningLightIntensity = 0;
        break;
        
      case 2: // Mom enters - gentle increase
        roomBrightness = 0.25;
        moonlightIntensity = 0.4;
        morningLightIntensity = 0.1;
        break;
        
      case 3: // Conversation - warmer lighting
        roomBrightness = 0.4;
        moonlightIntensity = 0.3;
        morningLightIntensity = 0.3;
        break;
        
      case 4: // Emotional moment - soft warm light
        roomBrightness = 0.6;
        moonlightIntensity = 0.2;
        morningLightIntensity = 0.5;
        break;
        
      case 5: // Morning peace - full morning light
        roomBrightness = 0.8;
        moonlightIntensity = 0.1;
        morningLightIntensity = 0.9;
        break;
    }
    
    // Subtle variations
    roomBrightness += sin(frameCount * 0.01) * 0.02;
    moonlightIntensity += cos(frameCount * 0.005) * 0.05;
  }
  
  void updateSleepAnimation() {
    if (isAsleep) {
      sleepCycle += 0.05;
      
      if (isRestless) {
        sleepCycle += 0.1; // Faster, more restless sleep
      }
    }
  }
  
  void updateNightmareEffects(int phaseFrame) {
    if (inNightmare) {
      nightmareIntensity = map(phaseFrame, 0, 240, 0, 0.8);
      nightmareIntensity = constrain(nightmareIntensity, 0, 0.8);
      
      // Update nightmare elements
      for (int i = nightmareElements.size() - 1; i >= 0; i--) {
        NightmareVisual element = nightmareElements.get(i);
        element.update();
        if (element.isDead()) {
          nightmareElements.remove(i);
        }
      }
    }
  }
  
  void updateFoodScraps() {
    for (int i = foodScraps.size() - 1; i >= 0; i--) {
      FoodScrap scrap = foodScraps.get(i);
      scrap.update();
      if (scrap.isDead()) {
        foodScraps.remove(i);
      }
    }
  }
  
  void addFoodScrap() {
    float x = plateOnFloor.x + random(-30, 30);
    float y = plateOnFloor.y + random(-10, 10);
    foodScraps.add(new FoodScrap(x, y));
  }
  
  void addNightmareElement() {
    float x = random(width);
    float y = random(height);
    nightmareElements.add(new NightmareVisual(x, y));
  }
  
  void draw() {
    // Draw bedroom background
    drawRoomBackground();
    
    // Draw moonlight from window
    drawMoonlight();
    
    // Draw morning light if applicable
    if (morningLightIntensity > 0) {
      drawMorningLight();
    }
    
    // Draw furniture
    drawFurniture();
    
    // Draw characters
    joko.draw();
    
    // Draw Mom if she has entered
    if (momEntered) {
      mom.draw();
    }
    
    // Draw sleep effects
    if (isAsleep) {
      drawSleepEffects();
    }
    
    // Draw nightmare effects
    if (inNightmare) {
      drawNightmareEffects();
    }
    
    // Draw emotional effects for resolution phases
    if (emotionalMoment) {
      drawEmotionalEffects();
    }
    
    // Draw peaceful ending effects
    if (peacefulEnding) {
      drawPeacefulEffects();
    }
    
    // Draw lighting overlay
    drawLightingOverlay();
    
    // Draw UI elements
    drawClock();
    drawCaption();
  }
  
  void drawRoomBackground() {
    // Night sky gradient through window
    fill(20, 25, 50);
    noStroke();
    rect(0, 0, width, height);
    
    // Room walls
    fill(80, 70, 60, roomBrightness * 255);
    rect(0, height * 0.6, width, height * 0.4);
    
    // Floor
    fill(101, 67, 33, roomBrightness * 255);
    rect(0, height - 80, width, 80);
  }
  
  void drawMoonlight() {
    // Moonlight coming through window
    fill(red(moonlightColor), green(moonlightColor), blue(moonlightColor), moonlightIntensity * 100);
    noStroke();
    
    // Window light rectangle
    rect(window.x - 50, window.y, 100, 150);
    
    // Light beam effect
    beginShape();
    vertex(window.x - 50, window.y);
    vertex(window.x + 50, window.y);
    vertex(window.x + 150, height);
    vertex(window.x - 150, height);
    endShape(CLOSE);
  }
  
  void drawFurniture() {
    fill(60, 40, 30, roomBrightness * 255);
    noStroke();
    
    // Bed
    rect(bed.x - 60, bed.y - 30, 120, 60, 10);
    // Pillow
    fill(200, 200, 180, roomBrightness * 255);
    ellipse(bed.x - 30, bed.y - 20, 30, 20);
    
    // Desk
    fill(60, 40, 30, roomBrightness * 255);
    rect(furniture.get(0).x - 40, furniture.get(0).y - 20, 80, 40);
    
    // Dresser
    rect(furniture.get(1).x - 30, furniture.get(1).y - 40, 60, 80);
    
    // Chair
    rect(furniture.get(2).x - 15, furniture.get(2).y - 30, 30, 30);
    rect(furniture.get(2).x - 12, furniture.get(2).y - 60, 24, 30);
    
    // Window frame
    stroke(40, 30, 20);
    strokeWeight(3);
    noFill();
    rect(window.x - 50, window.y, 100, 150);
    line(window.x, window.y, window.x, window.y + 150);
    line(window.x - 50, window.y + 75, window.x + 50, window.y + 75);
  }
  
  void drawFoodWaste() {
    // Plate on floor
    fill(240, 230, 210, roomBrightness * 255);
    stroke(200, 190, 170);
    strokeWeight(1);
    ellipse(plateOnFloor.x, plateOnFloor.y, 25, 25);
    
    // Food scraps
    for (FoodScrap scrap : foodScraps) {
      scrap.draw();
    }
  }
  
  void drawSleepEffects() {
    // Gentle breathing animation
    float breathOffset = sin(sleepCycle) * 2;
    
    // Sleep particles (dreams) - optimized
    if (!inNightmare) {
      fill(255, 255, 255, 100);
      noStroke();
      for (int i = 0; i < 2; i++) { // Reduced from 3 to 2
        float x = bed.x + sin(sleepCycle + i) * 20;
        float y = bed.y - 40 - i * 10 + breathOffset;
        ellipse(x, y, 5 - i, 5 - i);
      }
    }
    
    // Z's for sleeping
    if (!inNightmare && !isRestless) {
      fill(255, 255, 255, 150);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("Z", bed.x + 30, bed.y - 50 + sin(sleepCycle) * 5);
      text("z", bed.x + 25, bed.y - 70 + sin(sleepCycle + 1) * 3);
      text("z", bed.x + 35, bed.y - 85 + sin(sleepCycle + 2) * 2);
      textAlign(LEFT);
    }
  }
  
  void drawNightmareEffects() {
    // Dark nightmare overlay
    fill(50, 20, 80, nightmareIntensity * 150);
    noStroke();
    rect(0, 0, width, height);
    
    // Nightmare elements
    for (NightmareVisual element : nightmareElements) {
      element.draw();
    }
    
    // Restless sleep animation
    if (isRestless) {
      // Character tossing and turning
      pushMatrix();
      translate(bed.x, bed.y);
      rotate(sin(sleepCycle * 3) * 0.2);
      
      fill(255, 100, 100, 100);
      noStroke();
      ellipse(0, 0, 20, 40); // Restless body outline
      
      popMatrix();
    }
  }
  
  void drawLightingOverlay() {
    // Overall darkness overlay
    fill(0, 0, 0, (1 - roomBrightness) * 200);
    noStroke();
    rect(0, 0, width, height);
  }
  
  void drawClock() {
    // Digital clock showing late time
    fill(100, 255, 100, roomBrightness * 255);
    noStroke();
    rect(clock.x - 30, clock.y - 10, 60, 20, 5);
    
    // Clock display
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("22:30", clock.x, clock.y);
    textAlign(LEFT);
  }
  
  void setCaption(String text, int duration) {
    currentCaption = text;
    captionStartFrame = frameCount;
    captionDuration = duration;
  }
  
  // Function to schedule sound effect after speaking ends
  void scheduleConversationEndSound(String soundName, int currentFrame) {
    lastSpeakingEndFrame = currentFrame;
    waitingForSoundEffect = true;
    pendingSoundEffect = soundName;
    println("Scene4 - Scheduled sound effect: " + soundName + " to play 1 second after frame " + currentFrame);
  }
  
  // Function to check and play scheduled sound effects
  void checkConversationSoundEffects(int currentFrame) {
    if (waitingForSoundEffect && (currentFrame - lastSpeakingEndFrame) >= 30) { // 30 frames = 1 second at 30fps
      if (audioManager != null) {
        audioManager.playSound(pendingSoundEffect);
        println("Scene4 - Playing conversation end sound: " + pendingSoundEffect);
      }
      waitingForSoundEffect = false;
      pendingSoundEffect = "";
    }
  }
  
  void updateCaption() {
    if (frameCount - captionStartFrame > captionDuration) {
      currentCaption = "";
    }
  }
  
  void drawCaption() {
    if (!currentCaption.equals("")) {
      pushMatrix();
      pushStyle();
      
      // Calculate fade animation
      int currentFrame = frameCount - captionStartFrame;
      float fadeAlpha = 255;
      int fadeInFrames = 12;
      int fadeOutFrames = 12;
      
      if (currentFrame < fadeInFrames) {
        fadeAlpha = map(currentFrame, 0, fadeInFrames, 0, 255);
      } else if (currentFrame > captionDuration - fadeOutFrames) {
        fadeAlpha = map(currentFrame, captionDuration - fadeOutFrames, captionDuration, 255, 0);
      }
      
      // Determine speaker and set colors
      boolean isJoko = currentCaption.toLowerCase().contains("joko") || currentCaption.contains("\"Maaf Bu");
      boolean isMother = currentCaption.toLowerCase().contains("ibu") || currentCaption.toLowerCase().contains("mother") || currentCaption.contains("\"Nak");
      boolean isNarration = !isJoko && !isMother;
      
      // Enhanced typography with larger text
      textSize(20); // Increased from 17 to 20 for better visibility
      PFont captionFont = createFont("Arial", 20);
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
      
      // Calculate positioning with better visibility
      float lineHeight = 28; // Increased from 24 to 28 for larger text
      float bgWidth = maxWidth + 40;
      float bgHeight = (lines.size() * lineHeight) + 20;
      float bgX = width/2;
      float bgY = height - 80 - (bgHeight/2); // Moved higher from height - 40 for better visibility
      
      // Character-specific colors with emotional context
      color speakerColor = color(180, 220, 255); // Default soft blue
      color borderColor = color(100, 150, 200);
      
      if (isJoko) {
        speakerColor = color(255, 200, 160); // Warm, vulnerable orange for Joko
        borderColor = color(200, 140, 80);
      } else if (isMother) {
        speakerColor = color(255, 180, 220); // Nurturing pink for mother
        borderColor = color(200, 100, 150);
      } else if (isNarration) {
        speakerColor = color(220, 220, 255); // Soft lavender for narration
        borderColor = color(150, 150, 200);
      }
      
      // Enhanced glow effect for emotional scene
      for (int i = 0; i < 6; i++) {
        float alpha = map(i, 0, 5, fadeAlpha * 0.4, 0);
        fill(red(borderColor), green(borderColor), blue(borderColor), alpha);
        noStroke();
        rectMode(CENTER);
        rect(bgX, bgY, bgWidth + (i * 4), bgHeight + (i * 4), 12 + i);
      }
      
      // Main background with enhanced opacity for emotional weight
      fill(15, 20, 30, fadeAlpha * 0.96);
      stroke(red(borderColor), green(borderColor), blue(borderColor), fadeAlpha * 0.9);
      strokeWeight(2);
      rect(bgX, bgY, bgWidth, bgHeight, 10);
      
      // Double inner accent for this emotional scene
      stroke(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha * 0.6);
      strokeWeight(1);
      noFill();
      rect(bgX, bgY, bgWidth - 4, bgHeight - 4, 8);
      
      stroke(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha * 0.3);
      rect(bgX, bgY, bgWidth - 10, bgHeight - 10, 6);
      
      // Text with enhanced shadow for this emotional scene
      textAlign(CENTER, CENTER);
      
      // Stronger text shadow for emotional impact
      fill(0, 0, 0, fadeAlpha * 0.8);
      for (int i = 0; i < lines.size(); i++) {
        float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight) + 2;
        text(lines.get(i), bgX + 2, yPos + 2);
      }
      
      // Main text with emotional warmth
      fill(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha);
      for (int i = 0; i < lines.size(); i++) {
        float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight);
        text(lines.get(i), bgX, yPos);
      }
      
      // Emotional heartbeat indicator for this tender scene
      if (currentFrame < captionDuration - 20) {
        float heartbeat = (sin(frameCount * 0.4) + 1) * 0.4 * fadeAlpha;
        fill(red(speakerColor), green(speakerColor), blue(speakerColor), heartbeat);
        noStroke();
        ellipse(bgX - (bgWidth/2) + 15, bgY - (bgHeight/2) + 10, 5, 5);
        ellipse(bgX - (bgWidth/2) + 10, bgY - (bgHeight/2) + 6, 3, 3);
      }
      
      popStyle();
      popMatrix();
    }
  }
  
  void drawMorningLight() {
    // Warm morning sunlight coming through window
    color morningColor = color(255, 240, 180);
    fill(red(morningColor), green(morningColor), blue(morningColor), morningLightIntensity * 80);
    noStroke();
    
    // Morning light rectangle through window
    rect(window.x - 50, window.y, 100, 150);
    
    // Expanding morning light beam
    beginShape();
    vertex(window.x - 50, window.y);
    vertex(window.x + 50, window.y);
    vertex(window.x + 200, height);
    vertex(window.x - 200, height);
    endShape(CLOSE);
    
    // Soft morning glow around window
    fill(red(morningColor), green(morningColor), blue(morningColor), morningLightIntensity * 40);
    ellipse(window.x, window.y + 75, 200, 200);
  }
  
  void drawEmotionalEffects() {
    // Soft emotional particles around characters during heartfelt moments
    fill(255, 220, 180, 120);
    noStroke();
    
    for (int i = 0; i < 5; i++) {
      float x = bed.x + sin(frameCount * 0.02 + i) * 50;
      float y = bed.y - 60 + cos(frameCount * 0.03 + i) * 30;
      ellipse(x, y, 4, 4);
    }
    
    // Heart symbol during emotional breakthrough
    if (emotionalMoment) {
      fill(255, 150, 150, 100);
      drawHeart(bed.x, bed.y - 80, 15);
    }
  }
  
  void drawPeacefulEffects() {
    // Gentle sparkles and warm atmosphere for peaceful ending
    fill(255, 255, 200, 100);
    noStroke();
    
    for (int i = 0; i < 8; i++) {
      float x = random(width * 0.3, width * 0.8);
      float y = random(height * 0.3, height * 0.7);
      float sparkle = sin(frameCount * 0.1 + i) * 3;
      ellipse(x, y, sparkle, sparkle);
    }
    
    // Soft warm overlay
    fill(255, 240, 200, 30);
    rect(0, 0, width, height);
  }
  
  void drawHeart(float x, float y, float size) {
    beginShape();
    vertex(x, y + size * 0.3);
    bezierVertex(x - size * 0.7, y - size * 0.2, x - size * 0.7, y + size * 0.3, x, y + size * 0.8);
    bezierVertex(x + size * 0.7, y + size * 0.3, x + size * 0.7, y - size * 0.2, x, y + size * 0.3);
    endShape(CLOSE);
  }
}

// Helper classes for Scene 4

class FoodScrap {
  PVector position;
  PVector velocity;
  color scrapColor;
  float size;
  float life;
  float maxLife;
  
  FoodScrap(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-2, 2), random(-1, -3));
    
    // Random food colors
    int foodType = int(random(3));
    switch(foodType) {
      case 0: scrapColor = color(255, 255, 240); break; // Rice
      case 1: scrapColor = color(120, 60, 30); break;   // Rendang
      case 2: scrapColor = color(80, 120, 60); break;   // Vegetables
    }
    
    size = random(3, 8);
    maxLife = random(300, 600);
    life = maxLife;
  }
  
  void update() {
    position.add(velocity);
    velocity.mult(0.95);
    velocity.y += 0.2; // Gravity
    
    // Bounce off floor
    if (position.y > height - 80) {
      position.y = height - 80;
      velocity.y *= -0.3;
    }
    
    life--;
  }
  
  void draw() {
    float alpha = map(life, 0, maxLife, 0, 255);
    fill(red(scrapColor), green(scrapColor), blue(scrapColor), alpha);
    noStroke();
    ellipse(position.x, position.y, size, size);
  }
  
  boolean isDead() {
    return life <= 0;
  }
}

class NightmareVisual {
  PVector position;
  float size;
  float rotation;
  float rotationSpeed;
  color nightmareColor;
  float life;
  float maxLife;
  int type;
  
  NightmareVisual(float x, float y) {
    position = new PVector(x, y);
    size = random(20, 50);
    rotation = 0;
    rotationSpeed = random(-0.1, 0.1);
    
    // Nightmare colors
    nightmareColor = color(random(100, 255), random(0, 50), random(50, 150));
    
    maxLife = random(180, 360);
    life = maxLife;
    type = int(random(3));
  }
  
  void update() {
    rotation += rotationSpeed;
    
    // Floating motion
    position.x += sin(frameCount * 0.02 + position.y * 0.01) * 2;
    position.y += cos(frameCount * 0.03 + position.x * 0.01) * 1;
    
    life--;
  }
  
  void draw() {
    float alpha = map(life, 0, maxLife, 0, 100);
    fill(red(nightmareColor), green(nightmareColor), blue(nightmareColor), alpha);
    noStroke();
    
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    switch(type) {
      case 0: // Scary eye
        ellipse(0, 0, size, size * 0.6);
        fill(255, 0, 0, alpha);
        ellipse(0, 0, size * 0.5, size * 0.3);
        break;
        
      case 1: // Jagged shape
        beginShape();
        for (int i = 0; i < 4; i++) { // Reduced from 6 to 4
          float angle = i * PI / 3;
          float r = (i % 2 == 0) ? size : size * 0.5;
          vertex(cos(angle) * r, sin(angle) * r);
        }
        endShape(CLOSE);
        break;
        
      case 2: // Distorted face
        ellipse(0, 0, size, size);
        fill(0, alpha);
        ellipse(-size * 0.2, -size * 0.1, size * 0.2, size * 0.2);
        ellipse(size * 0.2, -size * 0.1, size * 0.2, size * 0.2);
        arc(0, size * 0.2, size * 0.4, size * 0.2, 0, PI);
        break;
    }
    
    popMatrix();
  }
  
  boolean isDead() {
    return life <= 0;
  }
}
