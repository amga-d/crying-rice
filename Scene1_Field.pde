// Scene1_Field.pde
// Scene 1: Meeting Friend - Field, Afternoon (0:00 - 0:30)

class Scene1_Field {
  // Characters
  Joko joko;
  Friend friend;
  
  // Scene elements
  ArrayList<Cloud> clouds;
  PVector sun;
  ArrayList<PVector> waterReflections; // Static water reflection positions
  
  // Eating scene elements
  ArrayList<FoodItem> traditionalMeal;
  boolean showMeal;
  PVector eatingMatCenter;
  
  // Animation timing
  int scenePhase; // 0: arrival, 1: meeting, 2: eating, 3: departure
  int phaseStartFrame;
  
  // Caption system
  String currentCaption;
  int captionStartFrame;
  int captionDuration;
  
  Scene1_Field() {
    // Constructor - initialize basic properties
  }
  
  void init() {
    // Initialize scene
    println("Initializing Scene 1: Field");
    
    // Create characters
    joko = new Joko(200, height - 200); // Start from left
    friend = new Friend(width - 200, height - 200); // Start from right
    
    // Initialize environment
    setupEnvironment();
    
    // Setup eating elements
    setupTraditionalMeal();
    showMeal = false;
    eatingMatCenter = new PVector(width/2, height - 140);
    
    // Set initial phase
    scenePhase = 0;
    phaseStartFrame = 0;
    
    // Initialize caption system
    currentCaption = "";
    captionStartFrame = 0;
    captionDuration = 0;
  }
  
  void setupEnvironment() {
    // Create Indonesian-style clouds - reduced count
    clouds = new ArrayList<Cloud>();
    for (int i = 0; i < 3; i++) { // Reduced from 6
      clouds.add(new Cloud(random(width), random(80, 200)));
    }
    
    // Indonesian sun position (afternoon setting - lower in sky)
    sun = new PVector(width * 0.7, height * 0.25); // Lower position for afternoon
    
    // Create static water reflection positions
    waterReflections = new ArrayList<PVector>();
    for (int i = 0; i < 15; i++) {
      float x = random(width);
      float y = height - random(40, 120);
      float w = random(20, 40);
      float h = random(5, 15);
      // Store position with width in z component
      waterReflections.add(new PVector(x, y, w));
      // Store height info in a second vector 
      waterReflections.add(new PVector(0, 0, h));
    }
    
    // Note: Rice plants are now drawn statically in drawRicePlants() function
  }
  
  void setupTraditionalMeal() {
    // Create traditional Indonesian meal items
    traditionalMeal = new ArrayList<FoodItem>();
    
    // Center the meal around the eating mat
    float centerX = width/2;
    float centerY = height - 140;
    
    // Main dishes arranged in a circle
    traditionalMeal.add(new FoodItem("nasi", centerX, centerY - 20, "white rice"));
    traditionalMeal.add(new FoodItem("rendang", centerX - 40, centerY - 10, "beef rendang"));
    traditionalMeal.add(new FoodItem("sayur", centerX + 40, centerY - 10, "vegetables"));
    traditionalMeal.add(new FoodItem("sambal", centerX - 20, centerY + 15, "chili sauce"));
    traditionalMeal.add(new FoodItem("kerupuk", centerX + 20, centerY + 15, "crackers"));
    traditionalMeal.add(new FoodItem("buah", centerX, centerY + 30, "tropical fruits"));
  }
  
  void drawEatingMat() {
    // Traditional Indonesian eating mat (tikar pandan)
    pushMatrix();
    translate(eatingMatCenter.x, eatingMatCenter.y);
    scale(2.0); // Make eating mat bigger
    
    // Mat base - woven pandan pattern
    fill(139, 115, 85); // Natural brown
    noStroke();
    ellipse(0, 0, 160, 120);
    
    // Woven pattern texture
    stroke(120, 100, 70);
    strokeWeight(1);
    for (int i = -6; i <= 6; i++) {
      // Horizontal weave lines
      line(-75 + abs(i) * 3, i * 8, 75 - abs(i) * 3, i * 8);
    }
    for (int i = -8; i <= 8; i++) {
      // Vertical weave lines
      line(i * 6, -55 + abs(i) * 2, i * 6, 55 - abs(i) * 2);
    }
    
    // Mat border with traditional pattern
    stroke(101, 67, 33);
    strokeWeight(3);
    noFill();
    ellipse(0, 0, 160, 120);
    
    // Decorative border elements
    fill(160, 130, 90);
    noStroke();
    for (int i = 0; i < 12; i++) {
      float angle = i * TWO_PI / 12;
      float x = cos(angle) * 70;
      float y = sin(angle) * 50;
      ellipse(x, y, 4, 6);
    }
    
    popMatrix();
  }
  
  void drawTraditionalMeal() {
    // Draw all food items
    for (FoodItem food : traditionalMeal) {
      food.draw();
    }
  }
  
  void updateEatingSetup(int subPhaseFrame) {
    // Characters sit down and prepare food
    if (subPhaseFrame < 60) {
      // Sitting down animation
      joko.setAnimation("sitting");
      friend.setAnimation("sitting");
      
      // Caption is now handled in handleSpeaking() for synchronization
    } else if (subPhaseFrame < 120) {
      // Preparing food animation
      joko.setAnimation("preparing");
      friend.setAnimation("preparing");
      
      // Caption is now handled in handleSpeaking() for synchronization
    } else {
      // Ready to eat
      joko.setAnimation("idle");
      friend.setAnimation("idle");
      
      // Caption is now handled in handleSpeaking() for synchronization
    }
  }
  
  void update(int sceneFrame) {
    int phaseFrame = sceneFrame - phaseStartFrame;
    
    // Phase transitions based on timing
    if (scenePhase == 0 && phaseFrame > 300) { // 5 seconds - arrival
      startPhase(1, sceneFrame);
    } else if (scenePhase == 1 && phaseFrame > 480) { // 8 seconds - meeting
      startPhase(2, sceneFrame);
    } else if (scenePhase == 2 && phaseFrame > 900) { // 15 seconds - eating
      startPhase(3, sceneFrame);
    }
    
    // Update based on current phase
    switch (scenePhase) {
      case 0: // Arrival - characters walk toward center
        updateArrival(phaseFrame);
        break;
      case 1: // Meeting - characters greet each other
        updateMeeting(phaseFrame);
        break;
      case 2: // Eating - characters share meal
        updateEating(phaseFrame);
        // Show meal during eating phase
        showMeal = true;
        break;
      case 3: // Departure - Joko leaves
        updateDeparture(phaseFrame);
        break;
    }
    
    // Update characters
    joko.update();
    friend.update();
    
    // Update clouds (slow movement)
    for (Cloud cloud : clouds) {
      cloud.update();
    }
  }
  
  // Method to handle character speaking animations
  void handleSpeaking(int sceneFrame) {
    // OPTIMIZED CHARACTER DIALOGUE - Avoiding narration conflicts
    // Narration happens at: 15 (0.5s), 600 (20s)
    
    if (sceneFrame == 90) { // 3 seconds - Friend greets (after opening narration)
      friend.startSpeaking(1.8);
      setCaption("Friend: \"Halo Joko! Ayo ke sini!\" (Hello Joko! Come here!)", 54, sceneFrame);
    }
    
    if (sceneFrame == 180) { // 6 seconds - Joko responds
      joko.startSpeaking(1.5);
      setCaption("Joko: \"Halo teman!\" (Hello friend!)", 45, sceneFrame);
    }
    
    if (sceneFrame == 270) { // 9 seconds - Friend suggests eating
      friend.startSpeaking(2.2);
      setCaption("Friend: \"Mari duduk dan makan bersama!\" (Let's sit and eat together!)", 66, sceneFrame);
    }
    
    if (sceneFrame == 360) { // 12 seconds - Joko admires scenery
      joko.startSpeaking(2.5);
      setCaption("Joko: \"Lihat sawah yang indah ini!\" (Look at this beautiful rice field!)", 75, sceneFrame);
    }
    
    if (sceneFrame == 450) { // 15 seconds - Friend enjoys food
      friend.startSpeaking(1.8);
      setCaption("Friend: \"Makanannya enak sekali!\" (The food is so delicious!)", 54, sceneFrame);
    }
    
    if (sceneFrame == 540) { // 18 seconds - Joko excited
      joko.startSpeaking(2.0);
      setCaption("Joko: \"Enak sekali! Ayo makan dan bermain!\" (So delicious! Let's eat and play!)", 60, sceneFrame);
    }
    
    if (sceneFrame == 690) { // 23 seconds - After narration transition
      friend.startSpeaking(1.5);
      setCaption("Friend: \"Sampai jumpa Joko!\" (See you later Joko!)", 45, sceneFrame);
    }
    
    if (sceneFrame == 750) { // 25 seconds - Joko's goodbye
      joko.startSpeaking(1.2);
      setCaption("Joko: \"Dadah! Aku pulang dulu!\" (Bye! I'm going home!)", 36, sceneFrame);
    }
  }
  
  void startPhase(int newPhase, int currentFrame) {
    scenePhase = newPhase;
    phaseStartFrame = currentFrame;
    
    switch (newPhase) {
      case 1:
        println("Phase 1: Meeting");
        break;
      case 2:
        println("Phase 2: Eating");
        break;
      case 3:
        println("Phase 3: Departure");
        break;
    }
  }
  
  void setCaption(String text, int duration, int currentFrame) {
    currentCaption = text;
    captionDuration = duration;
    captionStartFrame = currentFrame;
  }
  
  void updateArrival(int phaseFrame) {
    // Joko walks from left to center with realistic walking animation
    if (joko.position.x < width/2 - 100) {
      joko.moveTo(width/2 - 100, height - 200, 4); // Increased speed from 3 to 4
      joko.setAnimation("walking");
    } else {
      joko.stop();
      joko.setAnimation("idle");
    }
    
    // Friend walks from right to center with realistic walking animation
    if (friend.position.x > width/2 + 100) {
      friend.moveTo(width/2 + 100, height - 200, 4); // Increased speed from 3 to 4
      friend.setAnimation("walking");
    } else {
      friend.stop();
      friend.setAnimation("idle");
    }
  }
  
  void updateMeeting(int phaseFrame) {
  }
  
  void updateEating(int phaseFrame) {
    // Enhanced eating sequence with multiple sub-phases
    // Phase breakdown: 0-180 (setup), 180-360 (eating), 360-540 (sharing), 540-720 (finishing)
    
    // Make characters sit (lower position)
    joko.position.y = height - 160;
    friend.position.y = height - 160;
    
    // Sub-phase management
    if (phaseFrame < 180) {
      // Setup phase: characters sit down and prepare to eat
      updateEatingSetup(phaseFrame);
    } else if (phaseFrame < 360) {
      // Active eating phase: characters eat with animations
      updateActiveEating(phaseFrame - 180);
    } else if (phaseFrame < 540) {
      // Sharing phase: characters share food and interact
      updateFoodSharing(phaseFrame - 360);
    } else {
      // Finishing phase: characters finish meal and chat
      updateEatingFinish(phaseFrame - 540);
    }
  }
  
  void updateActiveEating(int subPhaseFrame) {
    // Active eating with realistic eating cycles
    int eatCycle = subPhaseFrame % 90; // 1.5 second eating cycles
    
    if (eatCycle < 30) {
      // Reaching for food
      joko.setAnimation("reaching");
      friend.setAnimation("reaching");
    } else if (eatCycle < 60) {
      // Bringing food to mouth
      joko.setAnimation("eating");
      friend.setAnimation("eating");
    } else {
      // Chewing and swallowing
      joko.setAnimation("chewing");
      friend.setAnimation("chewing");
    }
    
    // Add periodic dialogue during eating
    if (subPhaseFrame == 60) {
      setCaption("Joko: \"Nasi ini sangat enak!\" (This rice is very delicious!)", 120, subPhaseFrame + phaseStartFrame + 180);
    }
    
    if (subPhaseFrame == 150) {
      setCaption("Friend: \"Iya! Ayam rendangnya juga lezat!\" (Yes! The rendang chicken is also tasty!)", 120, subPhaseFrame + phaseStartFrame + 180);
    }
  }
  
  void updateFoodSharing(int subPhaseFrame) {
    // Characters share food and interact more
    int shareCycle = subPhaseFrame % 120; // 2 second sharing cycles
    
    if (shareCycle < 40) {
      // Friend offers food to Joko
      joko.setAnimation("receiving");
      friend.setAnimation("offering");
    } else if (shareCycle < 80) {
      // Joko offers food to Friend
      joko.setAnimation("offering");
      friend.setAnimation("receiving");
    } else {
      // Both eating together
      joko.setAnimation("eating");
      friend.setAnimation("eating");
    }
    
    // Sharing dialogue
    if (subPhaseFrame == 30) {
      setCaption("Friend: \"Coba sayur lodehnya, Joko!\" (Try the vegetables, Joko!)", 120, subPhaseFrame + phaseStartFrame + 360);
    }
    
    if (subPhaseFrame == 90) {
      setCaption("Joko: \"Terima kasih! Ini sambal pedas?\" (Thank you! Is this spicy chili?)", 120, subPhaseFrame + phaseStartFrame + 360);
    }
    
    if (subPhaseFrame == 150) {
      setCaption("Friend: \"Sedikit saja! Buatan ibu saya.\" (Just a little! Made by my mother.)", 120, subPhaseFrame + phaseStartFrame + 360);
    }
  }
  
  void updateEatingFinish(int subPhaseFrame) {
    // Characters finish eating and clean up
    if (subPhaseFrame < 60) {
      // Finishing last bites
      joko.setAnimation("eating");
      friend.setAnimation("eating");
      
      if (subPhaseFrame == 30) {
        setCaption("Joko: \"Kenyang sekali!\" (I'm so full!)", 90, subPhaseFrame + phaseStartFrame + 540);
      }
    } else if (subPhaseFrame < 120) {
      // Cleaning up
      joko.setAnimation("cleaning");
      friend.setAnimation("cleaning");
      
      if (subPhaseFrame == 90) {
        setCaption("Friend: \"Ayo bersih-bersih dulu!\" (Let's clean up first!)", 90, subPhaseFrame + phaseStartFrame + 540);
      }
    } else {
      // Satisfied and ready to move on
      joko.setAnimation("satisfied");
      friend.setAnimation("satisfied");
      
      if (subPhaseFrame == 150) {
        setCaption("Joko: \"Makasih ya! Sekarang ayo main!\" (Thanks! Now let's play!)", 120, subPhaseFrame + phaseStartFrame + 540);
      }
    }
  }
  
  void updateDeparture(int phaseFrame) {
    // Add departure captions
    if (phaseFrame == 60) { // 1 second into departure phase
      setCaption("Friend: \"Sampai jumpa Joko!\" (See you later Joko!)", 180, phaseFrame + phaseStartFrame);
    }
    
    if (phaseFrame == 180) { // 3 seconds into departure phase
      setCaption("Joko: \"Dadah! Aku pulang dulu!\" (Bye! I'm going home!)", 120, phaseFrame + phaseStartFrame);
    }
    
    // Joko starts walking toward home (right side) with walking animation
    joko.moveTo(width + 100, height - 200, 5); // Increased speed to 5
    joko.position.y = height - 200; // Stand up
    joko.setAnimation("walking");
    
    // Friend waves goodbye
    friend.position.y = height - 200; // Stand up
    friend.setAnimation("wave");
    friend.stop(); // Make sure friend stays in place
  }
  
  void draw() {
    // Draw sky gradient
    drawSky();
    
    // Draw traditional Indonesian buildings in background
    drawIndonesianBuildings();
    
    // Draw sun
    drawSun();
    
    // Draw clouds
    for (Cloud cloud : clouds) {
      cloud.draw();
    }
    
    // Draw background elements
    drawField();
    
    // Draw eating mat and food during eating phase
    if (showMeal) {
      drawEatingMat();
      drawTraditionalMeal();
    }
    
    // Draw characters
    joko.draw();
    friend.draw();
    
    // Draw captions
    drawCaption();
  }
  
  void drawSky() {
    // Afternoon Indonesian tropical sky gradient (warm afternoon colors)
    for (int i = 0; i < height/2; i++) {
      float inter = map(i, 0, height/2, 0, 1);
      color c = lerpColor(color(255, 200, 120), color(135, 180, 220), inter); // Warm orange to blue (afternoon)
      stroke(c);
      line(0, i, width, i);
    }
    
    // Add afternoon clouds with warm tints
    fill(255, 245, 230, 220); // Warm white clouds
    noStroke();
    // Cloud formations
    ellipse(width * 0.3, height * 0.15, 80, 40);
    ellipse(width * 0.32, height * 0.13, 60, 30);
    ellipse(width * 0.28, height * 0.14, 50, 25);
    
    ellipse(width * 0.7, height * 0.18, 100, 50);
    ellipse(width * 0.72, height * 0.16, 80, 40);
    ellipse(width * 0.68, height * 0.17, 60, 30);
    
    // Distant mountains/hills with afternoon haze
    fill(120, 160, 120, 180); // Slightly warmer green for afternoon
    beginShape();
    vertex(0, height * 0.4);
    vertex(width * 0.2, height * 0.35);
    vertex(width * 0.4, height * 0.38);
    vertex(width * 0.6, height * 0.33);
    vertex(width * 0.8, height * 0.36);
    vertex(width, height * 0.38);
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  
  void drawSun() {
    // Afternoon Indonesian tropical sun - positioned for afternoon (lower in sky)
    fill(255, 180, 60, 240); // Warmer afternoon sun color
    noStroke();
    ellipse(sun.x, sun.y, 80, 80); // Slightly larger afternoon sun
    
    // Warm afternoon sun rays
    stroke(255, 200, 100, 150);
    strokeWeight(3);
    for (int i = 0; i < 12; i++) {
      float angle = i * TWO_PI / 12;
      float x1 = sun.x + cos(angle) * 50;
      float y1 = sun.y + sin(angle) * 50;
      float x2 = sun.x + cos(angle) * 75;
      float y2 = sun.y + sin(angle) * 75;
      line(x1, y1, x2, y2);
    }
    
    // Warm inner glow for afternoon
    fill(255, 220, 120, 120);
    noStroke();
    ellipse(sun.x, sun.y, 100, 100);
  }
  
  void drawField() {
    // Indonesian rice field (sawah) ground - redesigned
    // Rich brown soil/mud base
    fill(101, 67, 33);
    noStroke();
    rect(0, height - 180, width, 180);
    
    // Water-logged rice field areas (darker soil)
    fill(80, 50, 25);
    rect(0, height - 150, width, 120);
    
    // Rice field water reflections - removed
    
    // Draw rice plants in organized rows (like real rice fields)
    drawRicePlants();
    
    // Add chickens wandering around (like in reference image)
    drawChickens();
  }
  
  void drawRicePlants() {
    // Draw organized rice field with completely static rice plants
    noStroke();
    
    // Create rice field rows - static positions
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 20; col++) {
        float x = 30 + col * (width - 60) / 19;
        float y = height - 140 + row * 15;
        
        // No random variation - completely static positions
        drawRicePlant(x, y);
      }
    }
  }
  
  void drawRicePlant(float x, float y) {
    // Individual rice plant with completely static leaves
    pushMatrix();
    translate(x, y);
    
    // Rice plant base/roots
    fill(40, 80, 40);
    noStroke();
    ellipse(0, 0, 6, 4);
    
    // Draw multiple tall rice stalks from each plant - static positions
    stroke(50, 120, 50);
    strokeWeight(2);
    
    // Main central stalk (tallest) - fixed position
    line(0, 0, 1, -42);
    
    // Side stalks (slightly shorter) - fixed positions
    line(-2, 0, -2, -32);
    line(2, 0, 2, -32);
    
    // Additional smaller stalks - fixed positions
    stroke(60, 140, 60);
    strokeWeight(1);
    line(-1, 0, -2, -27);
    line(1, 0, 1, -27);
    
    // Rice grain clusters on tall stalks (golden when mature) - static
    fill(255, 220, 120, 200); // Golden rice grains
    noStroke();
    
    // Grain cluster on main stalk - fixed positions
    ellipse(-1, -35, 1.5, 3);
    ellipse(0, -38, 1.5, 3);
    ellipse(1, -36, 1.5, 3);
    ellipse(-1, -40, 1.5, 3);
    ellipse(2, -34, 1.5, 3);
    ellipse(0, -42, 1.5, 3);
    ellipse(-2, -37, 1.5, 3);
    ellipse(1, -39, 1.5, 3);
    
    // Smaller grain clusters on side stalks - fixed positions
    ellipse(-3, -25, 1, 2);
    ellipse(-1, -30, 1, 2);
    ellipse(3, -28, 1, 2);
    ellipse(2, -31, 1, 2);
    
    // Rice leaves (longer and more realistic) - completely static
    fill(70, 150, 70, 180);
    noStroke();
    
    // Long rice leaves extending from base - fixed positions
    pushMatrix();
    rotate(-0.3);
    ellipse(0, -15, 3, 25);
    popMatrix();
    
    pushMatrix();
    rotate(0.3);
    ellipse(0, -15, 3, 25);
    popMatrix();
    
    pushMatrix();
    rotate(-0.1);
    ellipse(0, -20, 2.5, 30);
    popMatrix();
    
    pushMatrix();
    rotate(0.1);
    ellipse(0, -20, 2.5, 30);
    popMatrix();
    
    // Additional smaller leaves - fixed positions
    fill(80, 160, 80, 150);
    pushMatrix();
    rotate(-0.2);
    ellipse(0, -12, 2, 20);
    popMatrix();
    
    pushMatrix();
    rotate(0.2);
    ellipse(0, -12, 2, 20);
    popMatrix();
    
    popMatrix();
  }
  
  void drawChickens() {
    // Add BIGGER chickens like in the reference image
    // Chicken 1 (Brown) - MUCH BIGGER
    fill(200, 100, 50); // Brown chicken
    noStroke();
    ellipse(width * 0.3, height - 65, 35, 25); // Body - much bigger
    ellipse(width * 0.3 - 12, height - 75, 20, 20); // Head - bigger
    
    // Chicken 1 details - bigger
    fill(255, 200, 0); // Yellow beak
    triangle(width * 0.3 - 22, height - 75, width * 0.3 - 28, height - 75, width * 0.3 - 25, height - 70);
    
    fill(255, 0, 0); // Red comb - bigger
    ellipse(width * 0.3 - 12, height - 82, 10, 6);
    // Additional comb details
    ellipse(width * 0.3 - 8, height - 85, 6, 4);
    ellipse(width * 0.3 - 16, height - 85, 6, 4);
    
    // Black eyes
    fill(0);
    ellipse(width * 0.3 - 15, height - 75, 3, 3);
    
    // Wing detail
    fill(180, 80, 40);
    ellipse(width * 0.3 - 5, height - 70, 15, 10);
    
    // Bigger legs
    stroke(255, 200, 0);
    strokeWeight(3);
    line(width * 0.3 - 8, height - 52, width * 0.3 - 8, height - 40);
    line(width * 0.3 + 8, height - 52, width * 0.3 + 8, height - 40);
    
    // Chicken feet
    strokeWeight(2);
    line(width * 0.3 - 8, height - 40, width * 0.3 - 12, height - 37); // Left foot
    line(width * 0.3 - 8, height - 40, width * 0.3 - 4, height - 37);
    line(width * 0.3 + 8, height - 40, width * 0.3 + 4, height - 37); // Right foot
    line(width * 0.3 + 8, height - 40, width * 0.3 + 12, height - 37);
    
    // Chicken 2 (White) - MUCH BIGGER
    fill(255, 255, 255);
    noStroke();
    ellipse(width * 0.7, height - 60, 32, 22); // Body - bigger
    ellipse(width * 0.7 + 12, height - 70, 18, 18); // Head - bigger
    
    // Chicken 2 details - bigger
    fill(255, 200, 0); // Yellow beak
    triangle(width * 0.7 + 21, height - 70, width * 0.7 + 27, height - 70, width * 0.7 + 24, height - 65);
    
    fill(255, 0, 0); // Red comb - bigger
    ellipse(width * 0.7 + 12, height - 77, 9, 5);
    // Additional comb details
    ellipse(width * 0.7 + 8, height - 80, 5, 3);
    ellipse(width * 0.7 + 16, height - 80, 5, 3);
    
    // Black eyes
    fill(0);
    ellipse(width * 0.7 + 15, height - 70, 3, 3);
    
    // Wing detail
    fill(240, 240, 240);
    ellipse(width * 0.7 + 5, height - 65, 14, 9);
    
    // Bigger legs
    stroke(255, 200, 0);
    strokeWeight(3);
    line(width * 0.7 + 4, height - 49, width * 0.7 + 4, height - 37);
    line(width * 0.7 -8, height - 49, width * 0.7 -8, height - 37); // Adjusted right leg x-position
    
    // Chicken feet
    strokeWeight(2);
    line(width * 0.7 + 4, height - 37, width * 0.7, height - 34); // Left foot
    line(width * 0.7 + 4, height - 37, width * 0.7 + 8, height - 34);
    line(width * 0.7  - 8, height - 37, width * 0.7  - 10, height - 34); // Right foot
    line(width * 0.7  - 8, height - 37, width * 0.7 - 2, height - 34);
    
    // Add a third smaller chick for more life
    fill(255, 255, 100); // Yellow chick
    noStroke();
    ellipse(width * 0.5, height - 45, 18, 15); // Small chick body
    ellipse(width * 0.5 + 6, height - 50, 12, 12); // Small chick head
    
    // Chick legs and feet
    stroke(255, 200, 0);
    strokeWeight(2);
    line(width * 0.5 - 3, height - 37.5, width * 0.5 - 3, height - 30); // Left leg
    line(width * 0.5 + 3, height - 37.5, width * 0.5 + 3, height - 30); // Right leg
    
    strokeWeight(1);
    line(width * 0.5 - 3, height - 30, width * 0.5 - 5, height - 28); // Left foot
    line(width * 0.5 - 3, height - 30, width * 0.5 - 1, height - 28);
    line(width * 0.5 + 3, height - 30, width * 0.5 + 1, height - 28); // Right foot
    line(width * 0.5 + 3, height - 30, width * 0.5 + 5, height - 28);
    
    // Chick details
    fill(255, 180, 0); // Orange beak
    triangle(width * 0.5 + 12, height - 50, width * 0.5 + 15, height - 50, width * 0.5 + 13.5, height - 47);
    
    // Chick eyes
    fill(0);
    ellipse(width * 0.5 + 8, height - 50, 2, 2);
    
  
  }
  
  void drawIndonesianBuildings() {
    // Traditional Indonesian village buildings (matching reference image style) - BIGGER HOUSES
    
    // Main traditional house (left side, like in reference) - MUCH BIGGER
    drawTraditionalHouse(width * 0.25, height - 400, 220, 140);
    
    // Rice storage building (right background, golden like in reference) - BIGGER
    drawRiceStorage(width * 0.75, height - 350, 140, 110);
    
    // Small traditional hut (center background) - BIGGER
    drawSmallHut(width * 0.5, height - 320, 120, 90);
  }
  
  void drawTraditionalHouse(float x, float y, float w, float h) {
    pushMatrix();
    translate(x, y);
    
    // Traditional Indonesian house base (like in reference - brown wood)
    fill(139, 69, 19);
    noStroke();
    rect(-w/2, 0, w, h);
    
    // Wooden support posts (stilts)
    fill(101, 50, 0);
    rect(-w/2 + 15, h, 12, 40);
    rect(-w/2 + w/3, h, 12, 40);
    rect(-w/2 + 2*w/3, h, 12, 40);
    rect(-w/2 + w - 27, h, 12, 40);
    
    // Traditional thatched roof (like in reference)
    fill(184, 134, 11); // Golden brown thatch
    // Main roof shape
    quad(-w/2 - 25, 0, w/2 + 25, 0, w/2 + 5, -h*0.6, -w/2 - 5, -h*0.6);
    
    // Roof texture (thatch lines)
    stroke(160, 120, 0);
    strokeWeight(1);
    for (int i = 0; i < 12; i++) {
      line(-w/2 - 20 + i * 8, -h*0.5, -w/2 - 20 + i * 8, -h*0.1);
    }
    
    // Traditional windows with wooden shutters - enhanced
    fill(80, 40, 0);
    noStroke();
    rect(-w/3, h/4, w/5, h/3);
    rect(w/6, h/4, w/5, h/3);
    
    // Window frames - more prominent
    fill(139, 69, 19);
    strokeWeight(2);
    stroke(101, 50, 0);
    rect(-w/3 - 2, h/4 - 2, w/5 + 4, h/3 + 4);
    rect(w/6 - 2, h/4 - 2, w/5 + 4, h/3 + 4);
    
    // Window shutters
    fill(60, 30, 0);
    noStroke();
    rect(-w/3 + 2, h/4 + 2, (w/5 - 4)/2, h/3 - 4); // Left window left shutter
    rect(-w/3 + w/10, h/4 + 2, (w/5 - 4)/2, h/3 - 4); // Left window right shutter
    rect(w/6 + 2, h/4 + 2, (w/5 - 4)/2, h/3 - 4); // Right window left shutter
    rect(w/6 + w/10, h/4 + 2, (w/5 - 4)/2, h/3 - 4); // Right window right shutter
    
    // Traditional door - enhanced
    fill(101, 50, 0);
    noStroke();
    rect(-w/8, h/2, w/4, h/2);
    
    // Door frame and details - more prominent
    fill(139, 69, 19);
    stroke(80, 40, 0);
    strokeWeight(3);
    rect(-w/8 - 3, h/2 - 3, w/4 + 6, h/2 + 6);
    
    // Door panels
    fill(80, 40, 0);
    noStroke();
    rect(-w/8 + 4, h/2 + 4, w/4 - 8, h/4 - 4); // Upper panel
    rect(-w/8 + 4, h/2 + h/4 + 4, w/4 - 8, h/4 - 8); // Lower panel
    
    // Door handle - larger
    fill(180, 140, 20);
    noStroke();
    ellipse(w/8 - 8, h*0.75, 6, 6);
    
    // Door hinges
    fill(120, 120, 120);
    rect(-w/8 - 1, h/2 + 8, 3, 6);
    rect(-w/8 - 1, h/2 + h/3, 3, 6);
    
    // Traditional decorative elements
    fill(180, 140, 20);
    // Roof decoration
    triangle(-w/2 - 15, 0, -w/2 + 5, 0, -w/2 - 5, -15);
    triangle(w/2 - 5, 0, w/2 + 15, 0, w/2 + 5, -15);
    
    popMatrix();
  }
  
  void drawRiceStorage(float x, float y, float w, float h) {
    pushMatrix();
    translate(x, y);
    
    // Golden rice storage building (like the golden building in reference)
    fill(218, 165, 32); // Golden color
    noStroke();
    rect(-w/2, 0, w, h);
    
    // Support posts
    fill(139, 69, 19);
    rect(-w/2 + 8, h, 8, 30);
    rect(w/2 - 16, h, 8, 30);
    rect(-8, h, 8, 30);
    rect(0, h, 8, 30);
    
    // Conical thatched roof (like in reference)
    fill(184, 134, 11);
    triangle(-w/2 - 10, 0, w/2 + 10, 0, 0, -h*0.8);
    
    // Roof texture
    stroke(160, 120, 0);
    strokeWeight(1);
    for (int i = 0; i < 8; i++) {
      line(-w/2 + i * 8, -h*0.3 + i, -w/2 + i * 8, 0);
    }
    
    // Enhanced windows with frames
    fill(80, 40, 0);
    stroke(60, 30, 0);
    strokeWeight(2);
    ellipse(-w/4, h/3, 16, 16);
    ellipse(w/4, h/3, 16, 16);
    
    // Window frames
    fill(139, 69, 19);
    noStroke();
    ellipse(-w/4, h/3, 20, 20);
    ellipse(w/4, h/3, 20, 20);
    
    // Inner window openings
    fill(40, 20, 0);
    ellipse(-w/4, h/3, 12, 12);
    ellipse(w/4, h/3, 12, 12);
    
    // Small door for rice storage
    fill(101, 50, 0);
    rect(-w/12, h*0.6, w/6, h*0.4);
    
    // Door frame
    fill(139, 69, 19);
    rect(-w/12 - 2, h*0.6 - 2, w/6 + 4, h*0.4 + 4);
    
    // Door handle
    fill(180, 140, 20);
    ellipse(w/12 - 3, h*0.8, 4, 4);
    
    popMatrix();
  }
  
  void drawSmallHut(float x, float y, float w, float h) {
    pushMatrix();
    translate(x, y);
    
    // Small traditional hut
    fill(160, 120, 80);
    noStroke();
    rect(-w/2, 0, w, h);
    
    // Simple triangular roof
    fill(184, 134, 11);
    triangle(-w/2 - 5, 0, w/2 + 5, 0, 0, -h/2);
    
    // Enhanced door
    fill(101, 50, 0);
    noStroke();
    rect(-w/8, h/2, w/4, h/2);
    
    // Door frame
    fill(139, 69, 19);
    stroke(80, 40, 0);
    strokeWeight(2);
    rect(-w/8 - 2, h/2 - 2, w/4 + 4, h/2 + 4);
    
    // Door handle
    fill(180, 140, 20);
    noStroke();
    ellipse(w/8 - 4, h*0.75, 3, 3);
    
    // Small window
    fill(80, 40, 0);
    rect(-w/6, h/4, w/8, h/6);
    
    // Window frame
    fill(139, 69, 19);
    rect(-w/6 - 1, h/4 - 1, w/8 + 2, h/6 + 2);
    
    popMatrix();
  }
  
  void drawCaption() {
    // Check if there's an active caption to display
    if (currentCaption.length() > 0) {
      int currentFrame = frameCount - captionStartFrame;
      
      // Only display if within duration
      if (currentFrame >= 0 && currentFrame < captionDuration) {
        pushMatrix();
        pushStyle();
        
        // Calculate fade-in/fade-out animation for captions
        float fadeAlpha = 255;
        int fadeInFrames = 12; // 0.4 seconds fade in (faster than narration)
        int fadeOutFrames = 12; // 0.4 seconds fade out
        
        if (currentFrame < fadeInFrames) {
          fadeAlpha = map(currentFrame, 0, fadeInFrames, 0, 255);
        } else if (currentFrame > captionDuration - fadeOutFrames) {
          fadeAlpha = map(currentFrame, captionDuration - fadeOutFrames, captionDuration, 255, 0);
        }
        
        // Determine speaker and style caption accordingly
        boolean isJoko = currentCaption.toLowerCase().contains("joko:");
        boolean isFriend = currentCaption.toLowerCase().contains("friend:");
        boolean isMother = currentCaption.toLowerCase().contains("mother:") || currentCaption.toLowerCase().contains("mom:");
        
        // Enhanced typography for captions
        textSize(17);
        PFont captionFont = createFont("Arial", 17);
        textFont(captionFont);
        
        // Smart text wrapping for captions
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
        
        // Calculate caption positioning and dimensions
        float lineHeight = 24;
        float bgWidth = maxWidth + 40;
        float bgHeight = (lines.size() * lineHeight) + 20;
        float bgX = width/2;
        float bgY = height - 40 - (bgHeight/2);
        
        // Character-specific styling
        color speakerColor = color(180, 220, 255); // Default blue
        color borderColor = color(100, 150, 200);
        
        if (isJoko) {
          speakerColor = color(255, 220, 180); // Warm orange for Joko
          borderColor = color(200, 150, 100);
        } else if (isFriend) {
          speakerColor = color(180, 255, 180); // Green for friend
          borderColor = color(100, 200, 100);
        } else if (isMother) {
          speakerColor = color(255, 180, 220); // Pink for mother
          borderColor = color(200, 100, 150);
        }
        
        // Draw caption background with subtle glow
        for (int i = 0; i < 5; i++) {
          float alpha = map(i, 0, 4, fadeAlpha * 0.3, 0);
          fill(red(borderColor), green(borderColor), blue(borderColor), alpha);
          noStroke();
          rectMode(CENTER);
          rect(bgX, bgY, bgWidth + (i * 3), bgHeight + (i * 3), 10 + i);
        }
        
        // Main caption background
        fill(20, 25, 35, fadeAlpha * 0.95);
        stroke(red(borderColor), green(borderColor), blue(borderColor), fadeAlpha * 0.8);
        strokeWeight(1.5);
        rect(bgX, bgY, bgWidth, bgHeight, 8);
        
        // Inner accent border
        stroke(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha * 0.4);
        strokeWeight(1);
        noFill();
        rect(bgX, bgY, bgWidth - 6, bgHeight - 6, 6);
        
        // Draw caption text with character-specific color
        textAlign(CENTER, CENTER);
        
        // Text shadow for better readability
        fill(0, 0, 0, fadeAlpha * 0.6);
        for (int i = 0; i < lines.size(); i++) {
          float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight) + 1;
          text(lines.get(i), bgX + 1, yPos + 1);
        }
        
        // Main caption text
        fill(red(speakerColor), green(speakerColor), blue(speakerColor), fadeAlpha);
        for (int i = 0; i < lines.size(); i++) {
          float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight);
          text(lines.get(i), bgX, yPos);
        }
        
        // Speaking indicator animation (subtle pulse)
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

// Helper classes
class Cloud {
  PVector position;
  float size;
  float speed;
  float opacity;
  
  Cloud(float x, float y) {
    position = new PVector(x, y);
    size = random(80, 160);
    speed = random(0.3, 0.8);
    opacity = random(120, 200);
  }
  
  void update() {
    position.x += speed;
    if (position.x > width + size) {
      position.x = -size;
    }
  }
  
  void draw() {
    // More detailed Indonesian tropical clouds
    fill(255, 255, 255, opacity);
    noStroke();
    
    // Main cloud body
    ellipse(position.x, position.y, size, size * 0.7);
    ellipse(position.x - size * 0.25, position.y + size * 0.1, size * 0.8, size * 0.6);
    ellipse(position.x + size * 0.25, position.y + size * 0.1, size * 0.8, size * 0.6);
    ellipse(position.x - size * 0.4, position.y, size * 0.6, size * 0.5);
    ellipse(position.x + size * 0.4, position.y, size * 0.6, size * 0.5);
    
    // Cloud highlights
    fill(255, 255, 255, opacity * 0.6);
    ellipse(position.x - size * 0.1, position.y - size * 0.1, size * 0.4, size * 0.3);
  }
}

// Traditional Indonesian Food Item class
class FoodItem {
  String type;
  PVector position;
  String description;
  boolean isBeingEaten;
  float eatAmount;
  
  FoodItem(String foodType, float x, float y, String desc) {
    type = foodType;
    position = new PVector(x, y);
    description = desc;
    isBeingEaten = false;
    eatAmount = 1.0; // 1.0 = full, 0.0 = empty
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    scale(2.0); // Make food items bigger
    
    // Draw plate/banana leaf base
    fill(34, 139, 34, 150); // Green banana leaf
    noStroke();
    ellipse(0, 0, 35, 25);
    
    // Leaf texture
    stroke(20, 100, 20);
    strokeWeight(1);
    line(-12, -3, 12, 3);
    line(-10, 0, 10, 0);
    line(-8, 3, 8, -3);
    
    // Draw specific food based on type
    if (type.equals("nasi")) {
      drawRice();
    } else if (type.equals("rendang")) {
      drawRendang();
    } else if (type.equals("sayur")) {
      drawVegetables();
    } else if (type.equals("sayur_bening")) {
      drawSayurBening();
    } else if (type.equals("tempe")) {
      drawTempeh();
    } else if (type.equals("sambal")) {
      drawSambal();
    } else if (type.equals("kerupuk")) {
      drawKrupuk();
    } else if (type.equals("buah")) {
      drawFruits();
    }
    
    popMatrix();
  }
  
  void drawRice() {
    // Enhanced white steamed rice in pink bowl (like the photo)
    
    // Pink bowl base (matching the photo)
    fill(255, 160, 190); // Pink bowl color
    stroke(240, 140, 170); // Darker pink for bowl rim
    strokeWeight(2);
    ellipse(0, 2, 32 * eatAmount, 20 * eatAmount); // Bowl shape
    
    // Bowl rim detail
    fill(245, 150, 180);
    ellipse(0, -2, 34 * eatAmount, 8 * eatAmount); // Bowl rim
    
    // Bowl shadow/depth
    fill(230, 130, 160);
    arc(0, 2, 32 * eatAmount, 20 * eatAmount, 0, PI); // Bowl bottom shadow
    
    // White steamed rice mound (fluffy and realistic)
    fill(255, 255, 252); // Pure white rice
    noStroke();
    ellipse(0, -4, 26 * eatAmount, 16 * eatAmount); // Main rice mound
    
    // Rice texture - individual grains visible on surface
    fill(250, 250, 248);
    for (int i = 0; i < 15 * eatAmount; i++) {
      float rx = random(-11, 11) * eatAmount;
      float ry = random(-10, 2) * eatAmount;
      ellipse(rx, ry - 4, 1.8, 1); // Rice grain shapes
    }
    
    // More detailed rice grains for realism
    fill(248, 248, 245);
    for (int i = 0; i < 10 * eatAmount; i++) {
      float rx = random(-9, 9) * eatAmount;
      float ry = random(-8, 0) * eatAmount;
      rect(rx, ry - 4, 1.2, 2.5, 0.3); // Individual rice grains
    }
    
    // Rice highlights (making it look fluffy and fresh)
    fill(255, 255, 255, 180);
    for (int i = 0; i < 6 * eatAmount; i++) {
      float rx = random(-8, 8) * eatAmount;
      float ry = random(-9, -2) * eatAmount;
      ellipse(rx, ry - 4, 1, 0.8);
    }
    
    // Subtle steam effect (hot rice)
    if (eatAmount > 0.8) {
      fill(255, 255, 255, 30);
      for (int i = 0; i < 4; i++) {
        float x = random(-6, 6);
        float y = random(-15, -10);
        float steamHeight = random(3, 6);
        ellipse(x, y, 1.5, steamHeight);
      }
    }
  }
  
  void drawRendang() {
    // Dark brown beef rendang
    fill(101, 67, 33);
    noStroke();
    
    // Rendang pieces
    for (int i = 0; i < 3 * eatAmount; i++) {
      float angle = i * TWO_PI / 3;
      float x = cos(angle) * 6 * eatAmount;
      float y = sin(angle) * 4 * eatAmount;
      ellipse(x, y - 2, 8 * eatAmount, 6 * eatAmount);
    }
    
    // Sauce/gravy
    fill(139, 69, 19, 150);
    ellipse(0, -1, 20 * eatAmount, 12 * eatAmount);
  }
  
  void drawVegetables() {
    // Mixed vegetables (sayur lodeh)
    
    // Green vegetables (kangkung/spinach)
    fill(50, 150, 50);
    noStroke();
    for (int i = 0; i < 4 * eatAmount; i++) {
      float x = random(-8, 8) * eatAmount;
      float y = random(-4, 2) * eatAmount;
      ellipse(x, y - 2, 3, 6);
    }
    
    // Tofu pieces (white)
    fill(255, 255, 240);
    rect(-6 * eatAmount, -4 * eatAmount, 4 * eatAmount, 4 * eatAmount);
    rect(2 * eatAmount, -3 * eatAmount, 4 * eatAmount, 4 * eatAmount);
    
    // Coconut milk sauce
    fill(255, 255, 240, 100);
    ellipse(0, -1, 18 * eatAmount, 10 * eatAmount);
  }
  
  void drawSambal() {
    // Spicy chili sauce
    fill(180, 50, 50);
    noStroke();
    ellipse(0, -1, 12 * eatAmount, 8 * eatAmount);
    
    // Chili pieces
    fill(200, 30, 30);
    for (int i = 0; i < 3 * eatAmount; i++) {
      float x = random(-4, 4) * eatAmount;
      float y = random(-2, 1) * eatAmount;
      ellipse(x, y - 1, 2, 1);
    }
  }
  
  void drawKrupuk() {
    // Fried crackers
    fill(255, 200, 150);
    noStroke();
    
    // Irregular cracker shapes
    for (int i = 0; i < 2 * eatAmount; i++) {
      float x = (i - 0.5) * 8 * eatAmount;
      ellipse(x, -2, 6 * eatAmount, 8 * eatAmount);
    }
    
    // Cracker texture
    fill(240, 180, 120);
    ellipse(-4 * eatAmount, -2, 3 * eatAmount, 4 * eatAmount);
    ellipse(4 * eatAmount, -2, 3 * eatAmount, 4 * eatAmount);
  }
  
  void drawFruits() {
    // Tropical fruit slices
    
    // Mango slices (yellow)
    fill(255, 200, 50);
    noStroke();
    ellipse(-6 * eatAmount, -2, 8 * eatAmount, 6 * eatAmount);
    
    // Papaya slices (orange)
    fill(255, 150, 100);
    ellipse(6 * eatAmount, -2, 8 * eatAmount, 6 * eatAmount);
    
    // Banana slices (pale yellow)
    fill(255, 255, 150);
    ellipse(0, 1, 10 * eatAmount, 4 * eatAmount);
    
    // Fruit seeds/details
    fill(0);
    ellipse(6 * eatAmount, -2, 1, 1); // Papaya seeds
    ellipse(5 * eatAmount, -1, 1, 1);
  }
  
  void drawSayurBening() {
    // Clear vegetable soup (sayur bening)
    
    // Clear broth base
    fill(200, 220, 200, 120);
    noStroke();
    ellipse(0, -1, 22 * eatAmount, 12 * eatAmount);
    
    // Green leafy vegetables (kangkung or bayam)
    fill(40, 120, 40);
    for (int i = 0; i < 5 * eatAmount; i++) {
      float x = random(-8, 8) * eatAmount;
      float y = random(-4, 2) * eatAmount;
      // Leaf shapes
      ellipse(x, y - 1, 2, 5);
      ellipse(x + 1, y - 1, 1.5, 4);
    }
    
    // Corn kernels
    fill(255, 255, 100);
    for (int i = 0; i < 3 * eatAmount; i++) {
      float x = random(-6, 6) * eatAmount;
      float y = random(-2, 1) * eatAmount;
      ellipse(x, y, 2, 2);
    }
    
    // Bean sprouts (tauge)
    stroke(255, 255, 230);
    strokeWeight(1);
    for (int i = 0; i < 4 * eatAmount; i++) {
      float x = random(-7, 7) * eatAmount;
      float y = random(-3, 2) * eatAmount;
      line(x, y, x + 2, y - 1);
    }
    noStroke();
  }
  
  void drawTempeh() {
    // Fried tempeh (fermented soybean cake)
    
    // Tempeh base - rectangular golden brown pieces
    fill(160, 120, 60);
    noStroke();
    
    // Multiple tempeh pieces
    rect(-8 * eatAmount, -4 * eatAmount, 6 * eatAmount, 4 * eatAmount);
    rect(2 * eatAmount, -3 * eatAmount, 6 * eatAmount, 4 * eatAmount);
    
    // Fried crispy texture
    fill(180, 140, 80);
    rect(-7 * eatAmount, -3.5 * eatAmount, 4 * eatAmount, 3 * eatAmount);
    rect(3 * eatAmount, -2.5 * eatAmount, 4 * eatAmount, 3 * eatAmount);
    
    // Soybean texture dots
    fill(140, 100, 40);
    for (int i = 0; i < 8 * eatAmount; i++) {
      float x = random(-8, 8) * eatAmount;
      float y = random(-4, 0) * eatAmount;
      ellipse(x, y, 1, 1);
    }
    
    // Crispy edges
    fill(200, 160, 100);
    stroke(220, 180, 120);
    strokeWeight(0.5);
    rect(-8.5 * eatAmount, -4.5 * eatAmount, 6 * eatAmount, 4 * eatAmount);
    rect(1.5 * eatAmount, -3.5 * eatAmount, 6 * eatAmount, 4 * eatAmount);
    noStroke();
  }
  
  void takeABite() {
    eatAmount = max(0, eatAmount - 0.1);
  }
}
