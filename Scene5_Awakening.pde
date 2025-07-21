// Scene5_Awakening.pde
// Awakening - Bedroom, Late Night to Morning
// Joko realizes his mistake and makes amends with Mom

class Scene5_Awakening {
  // Characters
  Joko joko;
  Mom mom;
  
  // Scene timing
  int sceneStartFrame;
  int sceneFrame;
  final int SCENE_DURATION = 2400; // 40 seconds at 60fps
  
  // Environment elements
  PVector window;
  PVector bed;
  PVector door;
  
  // Lighting and atmosphere
  float timeOfDay; // 0 = late night, 1 = morning
  color nightColor;
  color morningColor;
  color currentSkyColor;
  float lightIntensity;
  float sunlightAngle;
  
  // Animation states
  boolean jokoIsAwake;
  boolean momHasEntered;
  boolean conversationStarted;
  boolean reconciliationComplete;
  float awakeningProgress;
  float emotionalGrowth;
  
  // Effects and particles
  ArrayList<SunRay> sunRays;
  ArrayList<PeaceParticle> peaceParticles;
  float hopeShimmer;
  
  Scene5_Awakening() {
    // Initialize characters
    joko = new Joko(640, 500);
    mom = new Mom(100, 480);
    
    // Scene timing
    sceneStartFrame = frameCount;
    sceneFrame = 0;
    
    // Environment setup
    window = new PVector(950, 200);
    bed = new PVector(640, 550);
    door = new PVector(100, 350);
    
    // Lighting setup
    timeOfDay = 0; // Start at late night
    nightColor = color(20, 25, 40);
    morningColor = color(255, 240, 200);
    currentSkyColor = nightColor;
    lightIntensity = 0.1;
    sunlightAngle = 0;
    
    // Animation states
    jokoIsAwake = false;
    momHasEntered = false;
    conversationStarted = false;
    reconciliationComplete = false;
    awakeningProgress = 0;
    emotionalGrowth = 0;
    
    // Effects
    sunRays = new ArrayList<SunRay>();
    peaceParticles = new ArrayList<PeaceParticle>();
    hopeShimmer = 0;
    
    // Set initial character states
    joko.setAnimation("sleeping");
    joko.position.set(bed.x, bed.y);
    mom.position.set(-100, 480); // Off-screen initially
    mom.setAnimation("concerned");
  }
  
  void init() {
    // Reset scene state when manually navigated to
    sceneStartFrame = frameCount;
    sceneFrame = 0;
    
    // Start happy ending background music for the awakening scene
    if (audioManager != null) {
      audioManager.fadeInHappyEndingMusic(5);
    }
    
    // Reset animation states
    jokoIsAwake = false;
    momHasEntered = false;
    conversationStarted = false;
    reconciliationComplete = false;
    awakeningProgress = 0;
    emotionalGrowth = 0;
    
    // Reset time progression
    timeOfDay = 0;
    currentSkyColor = nightColor;
    lightIntensity = 0.1;
    sunlightAngle = 0;
    
    // Clear effects
    sunRays.clear();
    peaceParticles.clear();
    hopeShimmer = 0;
    
    // Reset character states
    joko.setAnimation("sleeping");
    joko.position.set(bed.x, bed.y);
    mom.position.set(-100, 480);
    mom.setAnimation("concerned");
  }
  
  void update() {
    sceneFrame = frameCount - sceneStartFrame;
    
    // Update time progression (late night to morning)
    timeOfDay = map(sceneFrame, 0, SCENE_DURATION, 0, 1);
    timeOfDay = constrain(timeOfDay, 0, 1);
    
    // Update sky color transition
    currentSkyColor = lerpColor(nightColor, morningColor, timeOfDay);
    lightIntensity = map(timeOfDay, 0, 1, 0.1, 1.0);
    sunlightAngle = map(timeOfDay, 0, 1, 0, PI/3);
    
    // Scene progression based on timing
    updateSceneProgression();
    
    // Update characters
    joko.update();
    mom.update();
    
    // Update effects
    updateSunRays();
    updatePeaceParticles();
    updateHopeEffects();
  }
  
  void updateSceneProgression() {
    // Phase 1: Gradual awakening (0-8 seconds)
    if (sceneFrame < 480) {
      awakeningProgress = map(sceneFrame, 0, 480, 0, 1);
      if (sceneFrame > 240 && !jokoIsAwake) {
        joko.setAnimation("waking_up");
        jokoIsAwake = true;
        
        // Gentle music volume increase as Joko wakes peacefully
        if (audioManager != null) {
          audioManager.setHappyEndingMusicVolume(0.25);
        }
      }
      
      // Gradually increase volume during awakening
      if (audioManager != null && awakeningProgress > 0) {
        float volume = map(awakeningProgress, 0, 1, 0.15, 0.35);
        audioManager.setHappyEndingMusicVolume(volume);
      }
    }
    
    // Phase 2: Mom enters room (8-12 seconds)
    else if (sceneFrame < 720) {
      if (!momHasEntered) {
        mom.moveTo(300, 480, 2.0);
        mom.setAnimation("approaching");
        momHasEntered = true;
        
        // Increase music volume as emotional connection begins
        if (audioManager != null) {
          audioManager.setHappyEndingMusicVolume(0.4);
        }
      }
    }
    
    // Phase 3: Conversation begins (12-25 seconds)
    else if (sceneFrame < 1500) {
      if (!conversationStarted) {
        joko.setAnimation("sitting_up");
        mom.setAnimation("caring");
        conversationStarted = true;
        
        // Peak emotional volume during heart-to-heart conversation
        if (audioManager != null) {
          audioManager.setHappyEndingMusicVolume(0.45);
        }
      }
      
      // Emotional growth during conversation
      emotionalGrowth = map(sceneFrame, 720, 1500, 0, 1);
    }
    
    // Phase 4: Reconciliation and resolution (25-35 seconds)
    else if (sceneFrame < 2100) {
      if (!reconciliationComplete) {
        joko.setAnimation("apologetic");
        mom.setAnimation("forgiving");
        reconciliationComplete = true;
        
        // Maximum uplifting volume during reconciliation
        if (audioManager != null) {
          audioManager.setHappyEndingMusicVolume(0.5);
        }
        
        // Start peace particles - optimized
        for (int i = 0; i < 3; i++) { // Reduced from 5 to 3
          peaceParticles.add(new PeaceParticle(random(width), random(height)));
        }
      }
    }
    
    // Phase 5: Peaceful resolution (35-40 seconds)
    else {
      joko.setAnimation("peaceful");
      mom.setAnimation("gentle_smile");
      hopeShimmer = sin(sceneFrame * 0.1) * 0.5 + 0.5;
      
      // Maintain uplifting volume for peaceful conclusion
      if (audioManager != null && sceneFrame % 60 == 0) { // Check every 2 seconds
        audioManager.setHappyEndingMusicVolume(0.45);
      }
    }
  }
  
  void updateSunRays() {
    // Add new sun rays as morning progresses
    if (timeOfDay > 0.3 && random(1) < 0.02) {
      sunRays.add(new SunRay(window.x, window.y));
    }
    
    // Update existing sun rays
    for (int i = sunRays.size() - 1; i >= 0; i--) {
      SunRay ray = sunRays.get(i);
      ray.update();
      if (ray.isDead()) {
        sunRays.remove(i);
      }
    }
  }
  
  void updatePeaceParticles() {
    // Update peace particles
    for (int i = peaceParticles.size() - 1; i >= 0; i--) {
      PeaceParticle particle = peaceParticles.get(i);
      particle.update();
      if (particle.isDead()) {
        peaceParticles.remove(i);
      }
    }
    
    // Add more particles during reconciliation
    if (reconciliationComplete && random(1) < 0.01) {
      peaceParticles.add(new PeaceParticle(random(width), random(height)));
    }
  }
  
  void updateHopeEffects() {
    // Create gentle hope shimmer effect
    hopeShimmer = sin(frameCount * 0.02) * 0.3 + 0.7;
  }
  
  void draw() {
    // Draw sky with time progression
    drawSky();
    
    // Draw bedroom environment
    drawBedroom();
    
    // Draw window and natural lighting
    drawWindow();
    
    // Draw sun rays
    drawSunRays();
    
    // Draw characters
    joko.draw();
    if (momHasEntered) {
      mom.draw();
    }
    
    // Draw peace particles
    drawPeaceParticles();
    
    // Draw hope shimmer overlay
    drawHopeShimmer();
    
    // Draw emotional growth indicators
    drawEmotionalGrowth();
  }
  
  void drawSky() {
    // Gradient sky from night to morning
    for (int y = 0; y < height; y++) {
      float inter = map(y, 0, height, 0, 1);
      color skyColor = lerpColor(currentSkyColor, color(red(currentSkyColor) + 30, 
                                                      green(currentSkyColor) + 30, 
                                                      blue(currentSkyColor) + 30), inter);
      stroke(skyColor);
      line(0, y, width, y);
    }
  }
  
  void drawBedroom() {
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
    
    // Bed
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
    
    // Door
    fill(139, 90, 43); // Wooden door
    noStroke();
    rect(door.x - 20, door.y, 40, 120, 5);
    
    // Door handle
    fill(180, 160, 120);
    ellipse(door.x + 15, door.y + 60, 6, 6);
  }
  
  void drawWindow() {
    // Window frame
    fill(139, 90, 43); // Wooden window frame
    noStroke();
    rect(window.x - 60, window.y, 120, 150, 8);
    
    // Window glass with morning light
    if (timeOfDay > 0.2) {
      fill(255, 255, 200, 100 + lightIntensity * 100);
    } else {
      fill(20, 30, 60, 150); // Night sky through window
    }
    rect(window.x - 50, window.y + 10, 100, 130);
    
    // Window cross frame
    fill(139, 90, 43);
    rect(window.x - 5, window.y + 10, 10, 130);
    rect(window.x - 50, window.y + 70, 100, 10);
    
    // Morning sun (if it's morning time)
    if (timeOfDay > 0.5) {
      fill(255, 240, 100, lightIntensity * 200);
      noStroke();
      ellipse(window.x + 30, window.y + 40, 40 * lightIntensity, 40 * lightIntensity);
      
      // Sun glow
      fill(255, 250, 150, 50);
      ellipse(window.x + 30, window.y + 40, 80 * lightIntensity, 80 * lightIntensity);
    }
  }
  
  void drawSunRays() {
    for (SunRay ray : sunRays) {
      ray.draw();
    }
  }
  
  void drawPeaceParticles() {
    for (PeaceParticle particle : peaceParticles) {
      particle.draw();
    }
  }
  
  void drawHopeShimmer() {
    if (reconciliationComplete) {
      fill(255, 255, 200, 30 * hopeShimmer);
      noStroke();
      rect(0, 0, width, height);
    }
  }
  
  void drawEmotionalGrowth() {
    if (emotionalGrowth > 0) {
      // Gentle aura around characters showing emotional connection
      fill(100, 200, 255, 50 * emotionalGrowth);
      noStroke();
      ellipse(joko.position.x, joko.position.y, 200 * emotionalGrowth, 150 * emotionalGrowth);
      
      if (momHasEntered) {
        fill(255, 150, 100, 50 * emotionalGrowth);
        ellipse(mom.position.x, mom.position.y, 180 * emotionalGrowth, 140 * emotionalGrowth);
      }
    }
  }
  
  boolean isComplete() {
    return sceneFrame >= SCENE_DURATION;
  }
}

// Sun Ray class for morning light effect
class SunRay {
  PVector position;
  PVector velocity;
  float life;
  float maxLife;
  color rayColor;
  float alpha;
  float width;
  
  SunRay(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-2, 2), random(2, 5));
    maxLife = random(180, 300);
    life = maxLife;
    rayColor = color(255, 240, 150);
    alpha = random(100, 200);
    width = random(3, 8);
  }
  
  void update() {
    position.add(velocity);
    life--;
    alpha = map(life, 0, maxLife, 0, 200);
  }
  
  void draw() {
    stroke(red(rayColor), green(rayColor), blue(rayColor), alpha);
    strokeWeight(width);
    line(position.x, position.y, position.x - velocity.x * 20, position.y - velocity.y * 20);
  }
  
  boolean isDead() {
    return life <= 0 || position.y > height + 50;
  }
}

// Peace Particle class for reconciliation effect
class PeaceParticle {
  PVector position;
  PVector velocity;
  float life;
  float maxLife;
  color particleColor;
  float size;
  float rotation;
  float rotationSpeed;
  
  PeaceParticle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(random(-1, 1), random(-2, -0.5));
    maxLife = random(300, 600);
    life = maxLife;
    particleColor = color(random(100, 255), random(150, 255), random(200, 255));
    size = random(5, 15);
    rotation = 0;
    rotationSpeed = random(-0.1, 0.1);
  }
  
  void update() {
    position.add(velocity);
    velocity.mult(0.995); // Gradual slow down
    life--;
    rotation += rotationSpeed;
    
    // Gentle floating motion
    velocity.x += sin(frameCount * 0.01) * 0.02;
    velocity.y += cos(frameCount * 0.015) * 0.02;
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);
    
    float alpha = map(life, 0, maxLife, 0, 150);
    fill(red(particleColor), green(particleColor), blue(particleColor), alpha);
    noStroke();
    
    // Draw gentle star shape - optimized
    beginShape();
    for (int i = 0; i < 3; i++) { // Reduced from 5 to 3 points
      float angle = map(i, 0, 3, 0, TWO_PI);
      float x = cos(angle) * size;
      float y = sin(angle) * size;
      vertex(x, y);
      
      // Inner points
      angle = map(i + 0.5, 0, 3, 0, TWO_PI);
      x = cos(angle) * size * 0.5;
      y = sin(angle) * size * 0.5;
      vertex(x, y);
    }
    endShape(CLOSE);
    
    popMatrix();
  }
  
  boolean isDead() {
    return life <= 0;
  }
}
