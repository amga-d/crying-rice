// Scene1_Field.pde
// Scene 1: Meeting Friend - Field, Afternoon (0:00 - 0:30)

class Scene1_Field {
  // Characters
  Joko joko;
  Friend friend;
  
  // Scene elements
  ArrayList<PVector> grassBlades;
  ArrayList<Cloud> clouds;
  PVector sun;
  
  // Animation timing
  int scenePhase; // 0: arrival, 1: meeting, 2: eating, 3: departure
  int phaseStartFrame;
  
  // Food items
  ArrayList<FoodItem> foodItems;
  boolean showFood;
  
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
    
    // Initialize food
    setupFood();
    
    // Set initial phase
    scenePhase = 0;
    phaseStartFrame = 0;
    showFood = false;
  }
  
  void setupEnvironment() {
    // Create rice field grass (padi field style) - reduced for smaller screen
    grassBlades = new ArrayList<PVector>();
    for (int i = 0; i < 150; i++) { // Reduced from 300
      grassBlades.add(new PVector(random(width), height - random(30, 120)));
    }
    
    // Create Indonesian-style clouds - reduced count
    clouds = new ArrayList<Cloud>();
    for (int i = 0; i < 3; i++) { // Reduced from 6
      clouds.add(new Cloud(random(width), random(80, 200)));
    }
    
    // Indonesian sun position (tropical setting)
    sun = new PVector(width * 0.75, height * 0.15);
  }
  
  void setupFood() {
    foodItems = new ArrayList<FoodItem>();
    // Traditional Indonesian meal items
    foodItems.add(new FoodItem(width/2 - 40, height - 180, "nasi", color(255, 255, 240))); // Rice (nasi)
    foodItems.add(new FoodItem(width/2 - 10, height - 180, "sayur", color(90, 180, 90))); // Vegetables (sayur)
    foodItems.add(new FoodItem(width/2 + 20, height - 180, "lauk", color(160, 82, 45))); // Side dish (lauk)
    foodItems.add(new FoodItem(width/2 + 50, height - 180, "buah", color(255, 140, 0))); // Tropical fruit
    // Traditional banana leaf as plate
    foodItems.add(new FoodItem(width/2, height - 175, "leaf", color(34, 139, 34))); // Banana leaf
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
  
  void startPhase(int newPhase, int currentFrame) {
    scenePhase = newPhase;
    phaseStartFrame = currentFrame;
    
    switch (newPhase) {
      case 1:
        println("Phase 1: Meeting");
        break;
      case 2:
        println("Phase 2: Eating");
        showFood = true;
        break;
      case 3:
        println("Phase 3: Departure");
        break;
    }
  }
  
  void updateArrival(int phaseFrame) {
    // Joko walks from left to center
    if (joko.position.x < width/2 - 100) {
      joko.moveTo(width/2 - 100, height - 200, 3);
    } else {
      joko.stop();
    }
    
    // Friend walks from right to center
    if (friend.position.x > width/2 + 100) {
      friend.moveTo(width/2 + 100, height - 200, 3);
    } else {
      friend.stop();
    }
  }
  
  void updateMeeting(int phaseFrame) {
    // Characters are stationary, showing greeting animations
    joko.stop();
    friend.stop();
    
    // Add speech dialogue during meeting
    if (phaseFrame == 60) { // 1 second into meeting phase
      joko.setSpeech("Halo teman!", 180); // "Hello friend!"
    }
    
    if (phaseFrame == 180) { // 3 seconds into meeting phase
      friend.setSpeech("Hai Joko! Ayo makan!", 180); // "Hi Joko! Let's eat!"
    }
    
    // Simple wave animation (could be enhanced)
    if (phaseFrame % 120 < 60) {
      joko.setAnimation("wave");
      friend.setAnimation("wave");
    }
  }
  
  void updateEating(int phaseFrame) {
    // Characters sit and eat
    joko.setAnimation("eating");
    friend.setAnimation("eating");
    
    // Add eating dialogue
    if (phaseFrame == 120) { // 2 seconds into eating phase
      joko.setSpeech("Enak sekali!", 240); // "This is delicious!"
    }
    
    if (phaseFrame == 300) { // 5 seconds into eating phase
      friend.setSpeech("Iya! Nasi nya segar!", 240); // "Yes! The rice is fresh!"
    }
    
    if (phaseFrame == 480) { // 8 seconds into eating phase
      joko.setSpeech("Ayo main setelah makan!", 240); // "Let's play after eating!"
    }
    
    // Make characters "sit" by lowering their position slightly
    joko.position.y = height - 180;
    friend.position.y = height - 180;
  }
  
  void updateDeparture(int phaseFrame) {
    // Add departure dialogue
    if (phaseFrame == 60) { // 1 second into departure phase
      friend.setSpeech("Sampai jumpa Joko!", 180); // "See you later Joko!"
    }
    
    if (phaseFrame == 180) { // 3 seconds into departure phase
      joko.setSpeech("Dadah! Aku pulang dulu!", 120); // "Bye! I'm going home!"
    }
    
    // Joko starts walking toward home (right side)
    joko.moveTo(width + 100, height - 200, 4);
    joko.position.y = height - 200; // Stand up
    
    // Friend waves goodbye
    friend.position.y = height - 200; // Stand up
    friend.setAnimation("wave");
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
    
    // Draw food if visible
    if (showFood) {
      for (FoodItem food : foodItems) {
        food.draw();
      }
    }
    
    // Draw characters
    joko.draw();
    friend.draw();
    
    // Draw scene info
    drawSceneInfo();
  }
  
  void drawSky() {
    // Indonesian tropical sky gradient
    for (int i = 0; i < height/2; i++) {
      float inter = map(i, 0, height/2, 0, 1);
      color c = lerpColor(color(255, 165, 0), color(135, 206, 250), inter); // Orange to sky blue
      stroke(c);
      line(0, i, width, i);
    }
    
    // Add some atmospheric haze for tropical feel
    fill(255, 255, 255, 30);
    noStroke();
    rect(0, height/3, width, height/6);
  }
  
  void drawSun() {
    // Indonesian tropical sun - adjusted for smaller screen
    fill(255, 204, 0, 220);
    noStroke();
    ellipse(sun.x, sun.y, 70, 70); // Reduced from 100
    
    // Warm sun rays
    stroke(255, 215, 0, 120);
    strokeWeight(3);
    for (int i = 0; i < 12; i++) { // Reduced from 16
      float angle = i * TWO_PI / 12;
      float x1 = sun.x + cos(angle) * 45; // Reduced from 60
      float y1 = sun.y + sin(angle) * 45;
      float x2 = sun.x + cos(angle) * 65; // Reduced from 85
      float y2 = sun.y + sin(angle) * 65;
      line(x1, y1, x2, y2);
    }
    
    // Inner glow
    fill(255, 255, 0, 100);
    noStroke();
    ellipse(sun.x, sun.y, 85, 85); // Reduced from 120
  }
  
  void drawField() {
    // Indonesian rice field (sawah) ground
    // Rich brown soil
    fill(101, 67, 33);
    noStroke();
    rect(0, height - 180, width, 180);
    
    // Green rice field area
    fill(60, 120, 60);
    rect(0, height - 150, width, 120);
    
    // Rice stalks and grass (more detailed)
    stroke(34, 100, 34);
    strokeWeight(3);
    for (PVector grass : grassBlades) {
      // Main stalk
      line(grass.x, grass.y, grass.x + random(-3, 3), grass.y - random(15, 35));
      
      // Rice grain clusters
      if (random(1) > 0.7) {
        fill(255, 255, 200, 180);
        noStroke();
        for (int i = 0; i < 5; i++) {
          ellipse(grass.x + random(-5, 5), grass.y - random(20, 30), 2, 4);
        }
      }
    }
    
    // Traditional Indonesian flowers (kembang) - reduced count
    for (int i = 0; i < 12; i++) { // Reduced from 25
      float x = random(width);
      float y = height - random(30, 120);
      
      // Frangipani-like flowers
      fill(255, 255, 255, 200);
      noStroke();
      for (int j = 0; j < 5; j++) {
        float angle = j * TWO_PI / 5;
        ellipse(x + cos(angle) * 4, y + sin(angle) * 4, 6, 10);
      }
      
      // Center
      fill(255, 255, 0, 150);
      ellipse(x, y, 4, 4);
    }
    
    // Add some palm fronds in background
    drawPalmFronds();
    
    // Traditional Indonesian pathway stones - fewer stones
    fill(120, 120, 120);
    noStroke();
    for (int i = 0; i < width; i += 120) { // Increased spacing from 80 to 120
      ellipse(i + 60, height - 40, random(15, 25), random(10, 15));
    }
  }
  
  void drawPalmFronds() {
    // Background palm trees/fronds for Indonesian atmosphere - simplified for smaller screen
    stroke(0, 100, 0);
    strokeWeight(6);
    
    // Left side palm
    line(80, height - 150, 100, height - 250);
    
    // Right side palm  
    line(width - 80, height - 150, width - 100, height - 250);
    
    // Palm fronds - simplified
    stroke(0, 120, 0);
    strokeWeight(3);
    
    // Left fronds
    for (int i = 0; i < 4; i++) { // Reduced from 6
      float angle = i * PI / 4 - PI/4;
      line(100, height - 250, 100 + cos(angle) * 30, height - 250 + sin(angle) * 30);
    }
    
    // Right fronds
    for (int i = 0; i < 4; i++) { // Reduced from 6
      float angle = i * PI / 4 - PI/4;
      line(width - 100, height - 250, width - 100 + cos(angle) * 30, height - 250 + sin(angle) * 30);
    }
  }
  
  void drawIndonesianBuildings() {
    // Traditional Indonesian buildings in the background - optimized for smaller screen
    
    // Rumah Adat (Traditional Indonesian House) - Left background
    drawRumahAdat(width * 0.2, height - 320, 120, 80); // Reduced size
    
    // Traditional rice barn (lumbung padi) - Right background  
    drawLumbungPadi(width * 0.8, height - 280, 80, 60); // Reduced size, moved rice barn to right
  }
  
  void drawRumahAdat(float x, float y, float w, float h) {
    pushMatrix();
    translate(x, y);
    
    // Traditional Indonesian house base
    fill(139, 69, 19); // Traditional brown wood
    noStroke();
    rect(-w/2, 0, w, h);
    
    // Traditional wooden posts (stilts)
    fill(101, 50, 0);
    rect(-w/2 + 10, h, 8, 30);
    rect(-w/2 + w/3, h, 8, 30);
    rect(-w/2 + 2*w/3, h, 8, 30);
    rect(-w/2 + w - 18, h, 8, 30);
    
    // Traditional Indonesian roof (atap)
    fill(160, 82, 45); // Traditional roof color
    // Main roof shape
    quad(-w/2 - 20, 0, w/2 + 20, 0, w/2, -h/2, -w/2, -h/2);
    
    // Roof ridge
    fill(120, 60, 30);
    rect(-w/2, -h/2 - 5, w, 10);
    
    // Traditional roof ornaments
    fill(180, 140, 20);
    triangle(-w/2 - 10, 0, -w/2 + 10, 0, -w/2, -15);
    triangle(w/2 - 10, 0, w/2 + 10, 0, w/2, -15);
    
    // Traditional windows with wooden frames
    fill(80, 40, 0);
    rect(-w/4, h/4, w/6, h/3);
    rect(w/8, h/4, w/6, h/3);
    
    // Window details
    fill(139, 69, 19);
    rect(-w/4 + 2, h/4 + 2, w/6 - 4, h/3 - 4);
    rect(w/8 + 2, h/4 + 2, w/6 - 4, h/3 - 4);
    
    // Traditional door
    fill(101, 50, 0);
    rect(-w/12, h/2, w/6, h/2);
    
    // Door frame
    fill(139, 69, 19);
    rect(-w/12 - 2, h/2 - 2, w/6 + 4, h/2 + 4);
    
    // Traditional carvings on house
    fill(180, 140, 20);
    for (int i = 0; i < 3; i++) {
      rect(-w/2 + 20 + i * 30, h/8, 4, 8);
    }
    
    popMatrix();
  }
  
  void drawLumbungPadi(float x, float y, float w, float h) {
    pushMatrix();
    translate(x, y);
    
    // Traditional rice storage building
    fill(160, 120, 80); // Light brown wood
    noStroke();
    
    // Main structure (elevated)
    rect(-w/2, 0, w, h);
    
    // Support posts
    fill(120, 80, 40);
    rect(-w/2 + 10, h, 6, 25);
    rect(w/2 - 16, h, 6, 25);
    rect(-10, h, 6, 25);
    rect(4, h, 6, 25);
    
    // Traditional thatched roof
    fill(184, 134, 11); // Straw color
    ellipse(0, -h/4, w + 30, h/2);
    
    // Roof texture lines
    stroke(160, 120, 0);
    strokeWeight(1);
    for (int i = 0; i < 8; i++) {
      line(-w/2 - 10 + i * 8, -h/4 - 15, -w/2 - 10 + i * 8, -h/4 + 15);
    }
    
    // Traditional ventilation holes
    fill(100, 60, 20);
    noStroke();
    ellipse(-w/4, h/3, 8, 8);
    ellipse(w/4, h/3, 8, 8);
    
    popMatrix();
  }
  
  void drawSceneInfo() {
    // Scene phase indicator with Indonesian cultural context - adjusted for smaller screen
    fill(139, 69, 19, 220); // Traditional brown background
    stroke(255, 215, 0); // Golden border
    strokeWeight(2);
    rect(10, 50, 320, 80, 12); // Reduced width from 380
    
    fill(255, 255, 240);
    textSize(14); // Reduced from 18
    text("Scene 1: Sawah (Rice Field) - Bertemu Teman", 20, 75);
    
    String phaseText = "";
    switch (scenePhase) {
      case 0: phaseText = "Phase: Kedatangan (Arrival)"; break;
      case 1: phaseText = "Phase: Pertemuan (Meeting)"; break;
      case 2: phaseText = "Phase: Makan Bersama (Eating Together)"; break;
      case 3: phaseText = "Phase: Pulang (Going Home)"; break;
    }
    text(phaseText, 20, 95);
    textSize(12); // Smaller text for character info
    text("Karakter: Joko & Temannya di Desa", 20, 115);
    
    // Add traditional Indonesian decorative elements - simplified
    fill(255, 215, 0);
    noStroke();
    // Small decorative diamonds (traditional Indonesian pattern)
    for (int i = 0; i < 2; i++) { // Reduced from 3
      pushMatrix();
      translate(290 + i * 12, 75 + i * 8); // Adjusted position
      rotate(PI/4);
      rect(-2, -2, 4, 4); // Smaller diamonds
      popMatrix();
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

class FoodItem {
  PVector position;
  String type;
  color itemColor;
  
  FoodItem(float x, float y, String t, color c) {
    position = new PVector(x, y);
    type = t;
    itemColor = c;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    
    switch (type) {
      case "leaf": // Banana leaf as traditional plate
        fill(34, 139, 34);
        noStroke();
        ellipse(0, 0, 120, 80);
        // Leaf veins
        stroke(20, 100, 20);
        strokeWeight(2);
        line(-40, 0, 40, 0);
        for (int i = -3; i <= 3; i++) {
          line(i * 12, -10, i * 12, 10);
        }
        break;
        
      case "nasi": // Indonesian rice (nasi)
        fill(255, 255, 240);
        noStroke();
        // Rice grains in traditional mound shape
        ellipse(0, 0, 25, 18);
        for (int i = 0; i < 15; i++) {
          ellipse(random(-10, 10), random(-8, 8), 2, 3);
        }
        break;
        
      case "sayur": // Indonesian vegetables (sayur)
        // Traditional green vegetables
        fill(90, 180, 90);
        noStroke();
        // Leafy vegetables
        for (int i = 0; i < 5; i++) {
          ellipse(random(-8, 8), random(-5, 5), 6, 4);
        }
        break;
        
      case "lauk": // Side dish (lauk pauk)
        fill(160, 82, 45);
        noStroke();
        // Traditional cooked protein
        rect(-6, -3, 12, 6, 2);
        fill(120, 60, 30);
        rect(-4, -2, 8, 4, 1);
        break;
        
      case "buah": // Tropical fruit
        fill(255, 140, 0);
        noStroke();
        // Tropical fruit pieces
        ellipse(0, 0, 10, 10);
        fill(255, 165, 0);
        ellipse(-2, -2, 6, 6);
        break;
    }
    
    popMatrix();
  }
}
