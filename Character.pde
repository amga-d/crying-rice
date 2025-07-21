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
  boolean isMoving;
  float walkCycle;
  float bobOffset;
  
  // Walking animation properties
  float legSwing;
  float armSwing;
  float headBob;
  
  // Eating animation properties
  float mouthMovement;
  float handToMouth;
  float sittingPose;
  float reachingArm;
  float chewingMotion;
  
  // Speaking animation properties
  boolean isSpeaking;
  float speakingTimer;
  float speakingDuration;
  float mouthOpenAmount;
  float lipSyncSpeed;
  
  Character(float x, float y, color col, float s) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    fillColor = col;
    size = s;
    animationTime = 0;
    currentFrame = 0;
    currentAnimation = "idle";
    isMoving = false;
    walkCycle = 0;
    bobOffset = 0;
    legSwing = 0;
    armSwing = 0;
    headBob = 0;
    
    // Initialize eating animation properties
    mouthMovement = 0;
    handToMouth = 0;
    sittingPose = 0;
    reachingArm = 0;
    chewingMotion = 0;
    
    // Initialize speaking animation properties
    isSpeaking = false;
    speakingTimer = 0;
    speakingDuration = 0;
    mouthOpenAmount = 0;
    lipSyncSpeed = 8; // Speed of lip movement during speech
  }
  
  void update() {
    // Update position
    position.add(velocity);
    
    // Check if character is moving
    isMoving = velocity.mag() > 0.1;
    
    // Update animation timing - optimized for 30fps
    animationTime += 1.0/30.0; // Changed from 60fps to 30fps
    currentFrame = (int)(animationTime * 4) % 4; // Reduced from 8fps to 4fps animation cycle
    
    // Update walking animation - reduced frequency for performance
    if (isMoving) {
      walkCycle += 0.2; // Reduced walking speed for 30fps
      legSwing = sin(walkCycle) * 15; // Leg swing amplitude
      armSwing = sin(walkCycle + PI) * 10; // Arms opposite to legs
      headBob = abs(sin(walkCycle * 2)) * 3; // Head bobbing
      bobOffset = sin(walkCycle * 2) * 2; // Body bobbing
    } else {
      // Gradually return to idle position
      legSwing *= 0.9;
      armSwing *= 0.9;
      headBob *= 0.9;
      bobOffset *= 0.9;
      walkCycle *= 0.95;
    }
    
    // Update eating animations based on current animation
    updateEatingAnimations();
    
    // Update speaking animation
    updateSpeakingAnimation();
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y + bobOffset);
    
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

  boolean isStopped() {
    return velocity.mag() <= 0.1;
  }
  
  void updateEatingAnimations() {
    // Update eating-related animations based on current animation state
    if (currentAnimation.equals("eating")) {
      // Rhythmic eating motion
      mouthMovement = sin(animationTime * 4) * 3;
      handToMouth = abs(sin(animationTime * 3)) * 15;
      chewingMotion = sin(animationTime * 6) * 2;
    } else if (currentAnimation.equals("reaching")) {
      // Reaching for food
      reachingArm = sin(animationTime * 2) * 25;
      handToMouth = 0;
    } else if (currentAnimation.equals("chewing")) {
      // Chewing motion
      mouthMovement = sin(animationTime * 8) * 4;
      chewingMotion = sin(animationTime * 8) * 3;
      handToMouth = 0;
    } else if (currentAnimation.equals("sitting")) {
      // Sitting pose
      sittingPose = lerp(sittingPose, 20, 0.1);
    } else if (currentAnimation.equals("offering")) {
      // Offering food to friend
      reachingArm = sin(animationTime * 1.5) * 20;
    } else if (currentAnimation.equals("receiving")) {
      // Receiving food from friend
      handToMouth = sin(animationTime * 2) * 10;
    } else if (currentAnimation.equals("preparing")) {
      // Preparing food
      armSwing = sin(animationTime * 3) * 8;
    } else if (currentAnimation.equals("cleaning")) {
      // Cleaning up
      armSwing = sin(animationTime * 4) * 12;
    } else if (currentAnimation.equals("satisfied")) {
      // Satisfied after eating
      bobOffset = sin(animationTime * 1) * 1;
    } else if (currentAnimation.equals("reluctant")) {
      // Reluctant to eat - slow, unenthusiastic movements
      mouthMovement = sin(animationTime * 1) * 1;
      armSwing = sin(animationTime * 0.5) * 3;
    } else if (currentAnimation.equals("picking")) {
      // Picking at food without enthusiasm
      reachingArm = sin(animationTime * 1.5) * 8;
      handToMouth = abs(sin(animationTime * 1)) * 5;
    } else if (currentAnimation.equals("playing_with_food")) {
      // Playing with food instead of eating
      armSwing = sin(animationTime * 2) * 10;
      reachingArm = sin(animationTime * 1.8) * 12;
    } else if (currentAnimation.equals("carrying_plate")) {
      // Enhanced carrying plate animation - both hands holding plate carefully
      handToMouth = -8; // Hands holding plate low
      armSwing = 0;
      reachingArm = sin(animationTime * 1) * 3; // Slight wobble while carrying
      sittingPose = lerp(sittingPose, 0, 0.1); // Standing up gradually
    } else if (currentAnimation.equals("throwing")) {
      // Enhanced throwing food away with multiple stages
      float throwPhase = animationTime * 4; // Faster throwing motion
      
      if (throwPhase < 1) {
        // Stage 1: Lifting plate higher
        handToMouth = lerp(-8, -20, throwPhase);
        reachingArm = sin(throwPhase * PI * 2) * 5;
      } else if (throwPhase < 2) {
        // Stage 2: Tilting plate to dump
        float tiltProgress = throwPhase - 1;
        handToMouth = -20 + sin(tiltProgress * PI) * 10;
        reachingArm = sin(tiltProgress * PI * 4) * 15;
        armSwing = sin(tiltProgress * PI * 3) * 20;
      } else {
        // Stage 3: Dumping motion
        reachingArm = sin(animationTime * 8) * 25;
        armSwing = sin(animationTime * 8) * 20;
        handToMouth = -15 + sin(animationTime * 6) * 8;
      }
    } else if (currentAnimation.equals("blank_stare")) {
      // Added for Scene 2 - sitting blankly
      sittingPose = lerp(sittingPose, 20, 0.1);
      mouthMovement = 0;
      armSwing *= 0.95;
    } else if (currentAnimation.equals("dismissive")) {
      // Added for Scene 2 - dismissive attitude
      armSwing = sin(animationTime * 1) * 5;
      headBob = sin(animationTime * 0.8) * 2;
    } else if (currentAnimation.equals("picking_up")) {
      // Added for Scene 2 - picking up bowl from table
      reachingArm = sin(animationTime * 3) * 15;
      handToMouth = lerp(handToMouth, -10, 0.2); // Reaching down to bowl
      sittingPose = lerp(sittingPose, 0, 0.1); // Standing up
    } else if (currentAnimation.equals("holding_plate")) {
      // Added for Scene 2 - holding plate/bowl steady
      handToMouth = -12;
      reachingArm = sin(animationTime * 0.5) * 2; // Slight steady movement
      armSwing = 0;
    } else if (currentAnimation.equals("putting_down")) {
      // Added for Scene 2 - putting bowl back on table
      reachingArm = sin(animationTime * 2) * 10;
      handToMouth = lerp(handToMouth, 0, 0.2); // Lowering hands
      sittingPose = lerp(sittingPose, 20, 0.1); // Sitting back down
    } else if (currentAnimation.equals("sleeping")) {
      // Added for Scene 3 & 5 - peaceful sleeping
      bobOffset = sin(animationTime * 0.5) * 1;
      mouthMovement = 0;
      armSwing *= 0.98;
      sittingPose = lerp(sittingPose, 0, 0.1); // Lying down
    } else if (currentAnimation.equals("restless_sleep")) {
      // Added for Scene 3 - restless sleep during dream transition
      bobOffset = sin(animationTime * 2) * 3;
      armSwing = sin(animationTime * 1.5) * 8;
      headBob = sin(animationTime * 1.8) * 4;
    } else if (currentAnimation.equals("nightmare")) {
      // Added for Scene 3 - nightmare sleep with distress
      bobOffset = sin(animationTime * 4) * 5;
      armSwing = sin(animationTime * 3) * 12;
      headBob = sin(animationTime * 2.5) * 6;
      mouthMovement = sin(animationTime * 6) * 2; // Disturbed breathing
    } else if (currentAnimation.equals("struggling")) {
      // Added for Scene 3 - farmer struggling with work
      armSwing = sin(animationTime * 3) * 20;
      reachingArm = sin(animationTime * 2.5) * 25;
      bobOffset = sin(animationTime * 4) * 3;
      headBob = sin(animationTime * 1.5) * 5;
    } else if (currentAnimation.equals("crying")) {
      // Added for Scene 3 - farmer crying in despair
      bobOffset = sin(animationTime * 1) * 2;
      armSwing = sin(animationTime * 0.8) * 8; // Covering face
      headBob = sin(animationTime * 2) * 4; // Sobbing motion
      mouthMovement = sin(animationTime * 4) * 3; // Crying sounds
    } else if (currentAnimation.equals("waking_up")) {
      // Added for Scene 5 - gradual awakening
      bobOffset = sin(animationTime * 2) * 2;
      armSwing = sin(animationTime * 1.5) * 3;
      headBob = abs(sin(animationTime * 1)) * 5;
    } else if (currentAnimation.equals("sitting_up")) {
      // Added for Scene 5 - sitting up in bed
      sittingPose = lerp(sittingPose, 15, 0.1);
      bobOffset = sin(animationTime * 0.8) * 1.5;
    } else if (currentAnimation.equals("apologetic")) {
      // Added for Scene 5 - showing remorse
      headBob = sin(animationTime * 0.5) * 3;
      armSwing = sin(animationTime * 0.7) * 4;
      bobOffset = sin(animationTime * 0.3) * 1;
    } else if (currentAnimation.equals("peaceful")) {
      // Added for Scene 5 - content and at peace
      bobOffset = sin(animationTime * 0.2) * 0.5;
      mouthMovement = 0;
      armSwing *= 0.99;
    } else {
      // Gradually return eating animations to neutral
      mouthMovement *= 0.9;
      handToMouth *= 0.9;
      sittingPose *= 0.9;
      reachingArm *= 0.9;
      chewingMotion *= 0.9;
    }
  }
  
  // Speaking animation methods
  void startSpeaking(float duration) {
    isSpeaking = true;
    speakingTimer = 0;
    speakingDuration = duration;
    println("Character started speaking for " + duration + " seconds");
    
    // Play speaking sound effect through AudioManager
    if (audioManager != null) {
      audioManager.playSound("speaking");
    }
  }
  
  void stopSpeaking() {
    isSpeaking = false;
    speakingTimer = 0;
    mouthOpenAmount = 0;
  }
  
  void updateSpeakingAnimation() {
    if (isSpeaking) {
      speakingTimer += 1.0/30.0; // Increment timer based on 30fps
      
      // Check if speaking duration has ended
      if (speakingTimer >= speakingDuration) {
        stopSpeaking();
        return;
      }
      
      // Animate mouth movement with variable intensity
      float speakingPhase = speakingTimer * lipSyncSpeed;
      
      // Create varied mouth movements for natural speech
      float baseMovement = sin(speakingPhase) * 0.6;
      float variation1 = sin(speakingPhase * 1.3) * 0.3;
      float variation2 = sin(speakingPhase * 0.7) * 0.2;
      
      mouthOpenAmount = abs(baseMovement + variation1 + variation2) * 8;
      
      // Add subtle head movement while speaking
      headBob += sin(speakingPhase * 0.3) * 0.5;
    } else {
      // Gradually close mouth when not speaking
      mouthOpenAmount *= 0.9;
    }
  }
}

// Joko character class - village Indonesian boy
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
    translate(position.x, position.y + bobOffset);
    scale(1.5); // Make character 50% larger
    
    // Draw Joko - Modern Indonesian boy with curly hair
    // Head with bobbing animation
    pushMatrix();
    translate(0, -headBob);
    
    fill(205, 164, 125); // Indonesian skin tone
    noStroke();
    ellipse(0, -30, 55, 55);
    
    // Curly hair (like in reference image)
    fill(45, 25, 15); // Dark brown/black curly hair
    noStroke();
    // Main hair mass
    ellipse(0, -50, 60, 40);
    
    // Individual curls around the head
    fill(60, 35, 20);
    ellipse(-20, -55, 18, 15); // Left side curls
    ellipse(-25, -45, 15, 12);
    ellipse(-15, -60, 12, 10);
    ellipse(20, -55, 18, 15);  // Right side curls
    ellipse(25, -45, 15, 12);
    ellipse(15, -60, 12, 10);
    ellipse(0, -65, 15, 12);   // Top curls
    ellipse(-8, -62, 10, 8);
    ellipse(8, -62, 10, 8);
    
    // Eyes (large and expressive like reference)
    fill(255); // White of eyes
    noStroke();
    ellipse(-10, -35, 16, 14);
    ellipse(10, -35, 16, 14);
    
    // Eye pupils with sparkle
    fill(0);
    ellipse(-10, -35, 10, 10);
    ellipse(10, -35, 10, 10);
    
    // Eye sparkles (like reference image)
    fill(255);
    ellipse(-12, -37, 4, 4);
    ellipse(8, -37, 4, 4);
    ellipse(-8, -33, 2, 2);
    ellipse(12, -33, 2, 2);
    
    // Eyebrows
    fill(45, 25, 15);
    ellipse(-10, -42, 12, 4);
    ellipse(10, -42, 12, 4);
    
    // Nose
    fill(180, 140, 100);
    ellipse(0, -28, 6, 8);
    
    // Animated mouth based on current animation and speaking
    if (isSpeaking) {
      // Speaking mouth animation - variable opening
      fill(139, 69, 19); // Dark mouth interior
      noStroke();
      ellipse(0, -20, 15, 6 + mouthOpenAmount);
      
      // Lips moving during speech
      fill(200, 100, 80); // Lip color
      ellipse(0, -20 - (mouthOpenAmount * 0.3), 18, 4);
      ellipse(0, -20 + (mouthOpenAmount * 0.7), 18, 4);
      
      // Teeth visible when mouth opens wide
      if (mouthOpenAmount > 4) {
        fill(255, 255, 255);
        ellipse(0, -20 - 1, 12, 3);
      }
    } else if (currentAnimation.equals("eating") || currentAnimation.equals("chewing")) {
      // Eating/chewing mouth (smaller opening, moving)
      fill(139, 69, 19);
      noStroke();
      ellipse(0, -20 + mouthMovement, 12 + chewingMotion, 8 + abs(mouthMovement));
      
      // Teeth during chewing
      if (abs(mouthMovement) > 1) {
        fill(255, 255, 255);
        ellipse(0, -20 + mouthMovement - 2, 8, 4);
      }
    } else {
      // Big smile (like reference image)
      fill(255, 255, 255); // White teeth
      noStroke();
      arc(0, -20, 25, 20, 0, PI);
      
      // Mouth outline
      noFill();
      stroke(139, 69, 19);
      strokeWeight(2);
      arc(0, -20, 25, 20, 0, PI);
    }
    
    popMatrix(); // End head transformation
    
    // Modern Indonesian batik shirt (colorful like reference)
    fill(220, 50, 50); // Red base
    noStroke();
    rect(-25, -8, 50, 70, 8);
    
    // Detailed batik patterns (inspired by reference image)
    // Pattern 1: Traditional Indonesian motifs
    fill(255, 200, 0); // Golden yellow
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        pushMatrix();
        translate(-15 + i * 10, 5 + j * 12);
        rotate(PI/4);
        rect(-2, -2, 4, 4);
        popMatrix();
      }
    }
    
    // Pattern 2: Floral motifs
    fill(0, 150, 100); // Green
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 3; j++) {
        float x = -20 + i * 25;
        float y = 8 + j * 15;
        ellipse(x, y, 6, 6);
        ellipse(x-3, y-3, 3, 3);
        ellipse(x+3, y-3, 3, 3);
        ellipse(x-3, y+3, 3, 3);
        ellipse(x+3, y+3, 3, 3);
      }
    }
    
    // Pattern 3: Traditional lines
    fill(100, 50, 150); // Purple
    for (int i = 0; i < 5; i++) {
      rect(-20 + i * 8, 20, 2, 25);
    }
    
    // Animated Arms with eating and swinging motion
    fill(205, 164, 125); // Skin
    
    // Left arm - adapted for eating animations
    pushMatrix();
    translate(-30, 18);
    
    if (currentAnimation.equals("reaching")) {
      // Reaching toward food
      rotate(radians(reachingArm - 20));
    } else if (currentAnimation.equals("eating") || currentAnimation.equals("receiving")) {
      // Hand to mouth motion
      rotate(radians(-handToMouth - 45));
    } else if (currentAnimation.equals("offering")) {
      // Offering food to friend
      rotate(radians(reachingArm));
    } else {
      // Normal arm swing
      rotate(radians(armSwing));
    }
    
    ellipse(0, 0, 20, 50);
    
    // Left hand with potential food
    fill(205, 164, 125);
    ellipse(0, 27, 12, 12);
    
    // Draw realistic Indonesian food in hand during eating animations
    if ((currentAnimation.equals("eating") || currentAnimation.equals("offering")) && 
        (handToMouth > 5 || reachingArm > 5)) {
      // Small portion of white rice (realistic size)
      fill(255, 255, 248); // Natural rice color
      ellipse(0, 27, 4, 2.5); // Smaller rice portion
      
      // Individual rice grains detail
      fill(250, 250, 245);
      ellipse(-0.5, 27, 0.8, 0.5);
      ellipse(0.5, 26.8, 0.6, 0.4);
      
      // Small piece of rendang (Indonesian spiced beef)
      fill(120, 60, 30); // Rich brown rendang color
      ellipse(0.5, 27.5, 2, 1.2);
      
      // Tiny vegetable piece
      fill(80, 120, 60); // Green leafy vegetable
      ellipse(-0.8, 27.2, 1, 0.6);
    }
    
    // Draw realistic Indonesian rice plate when carrying or throwing
    if (currentAnimation.equals("carrying_plate") || currentAnimation.equals("throwing")) {
      // Traditional Indonesian ceramic plate (smaller, realistic size)
      fill(240, 235, 220); // Off-white ceramic plate
      stroke(200, 195, 180);
      strokeWeight(0.5);
      ellipse(0, 27, 10, 6); // Smaller plate shape
      
      // Plate rim detail
      noFill();
      stroke(180, 175, 160);
      strokeWeight(0.3);
      ellipse(0, 27, 10, 6);
      
      // White rice portion (smaller, realistic serving)
      fill(255, 255, 248);
      noStroke();
      ellipse(0, 26, 7, 4); // Smaller rice mound
      
      // Rice texture details (individual grains)
      fill(252, 252, 245);
      for (int i = 0; i < 4; i++) {
        float rx = random(-2.5, 2.5);
        float ry = random(-1.5, 1.5);
        ellipse(rx, 26 + ry, 0.8, 0.4); // Individual rice grains
      }
      
      // Small piece of rendang (Indonesian beef stew)
      fill(120, 60, 30); // Dark brown rendang
      ellipse(-1, 27, 2, 1.5);
      fill(100, 45, 20); // Darker rendang pieces
      ellipse(0.5, 26.5, 1.5, 1);
      
      // Small vegetables (Indonesian style)
      fill(80, 120, 60); // Green vegetables (kangkung/spinach)
      ellipse(1.5, 27, 1.2, 0.8);
      fill(200, 100, 50); // Carrot pieces
      ellipse(-0.5, 27.5, 0.8, 0.6);
    }
    
    popMatrix();
    
    // Right arm
    pushMatrix();
    translate(30, 18);
    
    if (currentAnimation.equals("reaching")) {
      // Reaching motion for right arm
      rotate(radians(-reachingArm + 10));
    } else if (currentAnimation.equals("eating") && handToMouth > 10) {
      // Supporting eating gesture
      rotate(radians(handToMouth * 0.3));
    } else if (currentAnimation.equals("carrying_plate")) {
      // Both hands carrying plate - coordinated movement
      rotate(radians(-reachingArm * 0.5 + armSwing * 0.3));
    } else if (currentAnimation.equals("throwing")) {
      // Coordinated throwing motion
      rotate(radians(-armSwing * 0.8 + reachingArm * 0.4));
    } else {
      // Normal opposite arm swing
      rotate(radians(-armSwing));
    }
    
    ellipse(0, 0, 20, 50);
    // Right hand
    fill(205, 164, 125);
    ellipse(0, 27, 12, 12);
    popMatrix();
    
    // Animated Legs - adapted for sitting and walking
    fill(40, 40, 60); // Dark blue/navy pants
    
    // Left leg
    pushMatrix();
    translate(-10, 62);
    
    if (currentAnimation.equals("sitting") || currentAnimation.equals("eating") || 
        currentAnimation.equals("chewing") || currentAnimation.equals("preparing") ||
        currentAnimation.equals("offering") || currentAnimation.equals("receiving")) {
      // Sitting position - legs bent forward
      rotate(radians(45 + sittingPose));
      rect(-9, 0, 18, 35, 5); // Shorter legs when sitting
      
      // Left foot in sitting position
      pushMatrix();
      translate(0, 35);
      rotate(radians(45));
      fill(20, 20, 20); // Black shoes
      ellipse(0, 3, 22, 14);
      fill(60, 60, 60);
      ellipse(0, 1, 16, 8);
      popMatrix();
    } else {
      // Walking/standing position
      rotate(radians(legSwing));
      rect(-9, 0, 18, 50, 5);
      
      // Left foot
      pushMatrix();
      translate(0, 50);
      rotate(radians(-legSwing * 0.5));
      fill(20, 20, 20); // Black shoes
      ellipse(0, 3, 22, 14);
      fill(60, 60, 60);
      ellipse(0, 1, 16, 8);
      popMatrix();
    }
    popMatrix();
    
    // Right leg
    pushMatrix();
    translate(10, 62);
    
    if (currentAnimation.equals("sitting") || currentAnimation.equals("eating") || 
        currentAnimation.equals("chewing") || currentAnimation.equals("preparing") ||
        currentAnimation.equals("offering") || currentAnimation.equals("receiving")) {
      // Sitting position - legs bent forward
      rotate(radians(45 + sittingPose));
      fill(40, 40, 60);
      rect(-9, 0, 18, 35, 5); // Shorter legs when sitting
      
      // Right foot in sitting position
      pushMatrix();
      translate(0, 35);
      rotate(radians(45));
      fill(20, 20, 20); // Black shoes
      ellipse(0, 3, 22, 14);
      fill(60, 60, 60);
      ellipse(0, 1, 16, 8);
      popMatrix();
    } else {
      // Walking/standing position
      rotate(radians(-legSwing));
      fill(40, 40, 60);
      rect(-9, 0, 18, 50, 5);
      
      // Right foot
      pushMatrix();
      translate(0, 50);
      rotate(radians(legSwing * 0.5));
      fill(20, 20, 20); // Black shoes
      ellipse(0, 3, 22, 14);
      fill(60, 60, 60);
      ellipse(0, 1, 16, 8);
      popMatrix();
    }
    popMatrix();
    
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

// Friend character class - Modern Indonesian boy
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
    translate(position.x, position.y + bobOffset);
    scale(1.5); // Make character 50% larger
    
    // Draw Friend - Modern Indonesian boy with different hair style
    // Head with bobbing animation
    pushMatrix();
    translate(0, -headBob);
    
    fill(210, 170, 130); // Indonesian skin tone
    noStroke();
    ellipse(0, -30, 55, 55);
    
    // Different hair style - wavy/textured (variation of curly)
    fill(25, 15, 8); // Very dark brown hair
    noStroke();
    // Main hair mass
    ellipse(0, -50, 58, 38);
    
    // Wavy hair texture
    fill(40, 25, 15);
    ellipse(-18, -52, 15, 18); // Left side waves
    ellipse(-22, -42, 12, 15);
    ellipse(-10, -58, 10, 12);
    ellipse(18, -52, 15, 18);  // Right side waves
    ellipse(22, -42, 12, 15);
    ellipse(10, -58, 10, 12);
    ellipse(0, -62, 12, 10);   // Top waves
    ellipse(-6, -60, 8, 10);
    ellipse(6, -60, 8, 10);
    
    // Eyes (large and expressive like reference)
    fill(255); // White of eyes
    noStroke();
    ellipse(-10, -35, 16, 14);
    ellipse(10, -35, 16, 14);
    
    // Eye pupils with sparkle
    fill(0);
    ellipse(-10, -35, 10, 10);
    ellipse(10, -35, 10, 10);
    
    // Eye sparkles
    fill(255);
    ellipse(-12, -37, 4, 4);
    ellipse(8, -37, 4, 4);
    ellipse(-8, -33, 2, 2);
    ellipse(12, -33, 2, 2);
    
    // Eyebrows
    fill(25, 15, 8);
    ellipse(-10, -42, 12, 4);
    ellipse(10, -42, 12, 4);
    
    // Nose
    fill(185, 145, 105);
    ellipse(0, -28, 6, 8);
    
    // Animated mouth based on current animation and speaking (same as Joko)
    if (isSpeaking) {
      // Speaking mouth animation - variable opening
      fill(139, 69, 19); // Dark mouth interior
      noStroke();
      ellipse(0, -20, 15, 6 + mouthOpenAmount);
      
      // Lips moving during speech
      fill(200, 100, 80); // Lip color
      ellipse(0, -20 - (mouthOpenAmount * 0.3), 18, 4);
      ellipse(0, -20 + (mouthOpenAmount * 0.7), 18, 4);
      
      // Teeth visible when mouth opens wide
      if (mouthOpenAmount > 4) {
        fill(255, 255, 255);
        ellipse(0, -20 - 1, 12, 3);
      }
    } else if (currentAnimation.equals("eating") || currentAnimation.equals("chewing")) {
      // Eating/chewing mouth (smaller opening, moving)
      fill(139, 69, 19);
      noStroke();
      ellipse(0, -20 + mouthMovement, 12 + chewingMotion, 8 + abs(mouthMovement));
      
      // Teeth during chewing
      if (abs(mouthMovement) > 1) {
        fill(255, 255, 255);
        ellipse(0, -20 + mouthMovement - 2, 8, 4);
      }
    } else {
      // Big smile
      fill(255, 255, 255); // White teeth
      noStroke();
      arc(0, -20, 25, 20, 0, PI);
      
      // Mouth outline
      noFill();
      stroke(139, 69, 19);
      strokeWeight(2);
      arc(0, -20, 25, 20, 0, PI);
    }
    
    popMatrix(); // End head transformation
    
    // Modern Indonesian batik shirt (different color scheme)
    fill(50, 100, 180); // Blue base
    noStroke();
    rect(-25, -8, 50, 70, 8);
    
    // Different batik patterns
    // Pattern 1: Traditional Indonesian geometric
    fill(255, 180, 50); // Orange/yellow
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        float x = -18 + i * 9;
        float y = 2 + j * 12;
        pushMatrix();
        translate(x, y);
        rotate(PI/6);
        ellipse(0, 0, 6, 3);
        popMatrix();
      }
    }
    
    // Pattern 2: Traditional Indonesian flowers
    fill(150, 50, 100); // Purple/magenta
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        float x = -15 + i * 15;
        float y = 10 + j * 18;
        // Flower petals
        ellipse(x, y, 4, 8);
        ellipse(x-3, y-2, 4, 8);
        ellipse(x+3, y-2, 4, 8);
        ellipse(x-2, y+3, 4, 8);
        ellipse(x+2, y+3, 4, 8);
        // Center
        fill(255, 255, 0);
        ellipse(x, y, 3, 3);
        fill(150, 50, 100); // Reset color
      }
    }
    
    // Pattern 3: Traditional waves
    fill(0, 150, 120); // Teal
    for (int i = 0; i < 6; i++) {
      float x = -22 + i * 7;
      for (int j = 0; j < 4; j++) {
        float y = 8 + j * 12;
        arc(x, y, 6, 6, 0, PI);
      }
    }
    
    // Animated Arms with eating and swinging motion (same as Joko)
    fill(210, 170, 130); // Skin
    
    // Left arm - adapted for eating animations
    pushMatrix();
    translate(-30, 18);
    
    if (currentAnimation.equals("reaching")) {
      // Reaching toward food
      rotate(radians(reachingArm - 20));
    } else if (currentAnimation.equals("eating") || currentAnimation.equals("receiving")) {
      // Hand to mouth motion
      rotate(radians(-handToMouth - 45));
    } else if (currentAnimation.equals("offering")) {
      // Offering food to friend
      rotate(radians(reachingArm));
    } else {
      // Normal arm swing
      rotate(radians(armSwing));
    }
    
    ellipse(0, 0, 20, 50);
    
    // Left hand with potential food
    fill(210, 170, 130);
    ellipse(0, 27, 12, 12);
    
    // Draw realistic Indonesian food in hand during eating animations
    if ((currentAnimation.equals("eating") || currentAnimation.equals("offering")) && 
        (handToMouth > 5 || reachingArm > 5)) {
      // Small portion of white rice (realistic size)
      fill(255, 255, 248); // Natural rice color
      ellipse(0, 27, 4, 2.5); // Smaller rice portion
      
      // Individual rice grains detail
      fill(250, 250, 245);
      ellipse(-0.5, 27, 0.8, 0.5);
      ellipse(0.5, 26.8, 0.6, 0.4);
      
      // Different side dish - green vegetables (sayur)
      fill(60, 130, 70); // Dark green leafy vegetables
      ellipse(0.8, 27.3, 1.8, 1);
      
      // Small piece of tempeh or tofu
      fill(240, 220, 180); // Light brown tempeh color
      ellipse(-0.5, 27.5, 1.5, 0.8);
    }
    
    popMatrix();
    
    // Right arm
    pushMatrix();
    translate(30, 18);
    
    if (currentAnimation.equals("reaching")) {
      // Reaching motion for right arm
      rotate(radians(-reachingArm + 10));
    } else if (currentAnimation.equals("eating") && handToMouth > 10) {
      // Supporting eating gesture
      rotate(radians(handToMouth * 0.3));
    } else {
      // Normal opposite arm swing
      rotate(radians(-armSwing));
    }
    
    ellipse(0, 0, 20, 50);
    // Right hand
    fill(210, 170, 130);
    ellipse(0, 27, 12, 12);
    popMatrix();
    
    // Animated Legs - adapted for sitting and walking (same logic as Joko)
    fill(60, 40, 40); // Dark brown/maroon pants
    
    // Left leg
    pushMatrix();
    translate(-10, 62);
    
    if (currentAnimation.equals("sitting") || currentAnimation.equals("eating") || 
        currentAnimation.equals("chewing") || currentAnimation.equals("preparing") ||
        currentAnimation.equals("offering") || currentAnimation.equals("receiving")) {
      // Sitting position - legs bent forward
      rotate(radians(45 + sittingPose));
      rect(-9, 0, 18, 35, 5); // Shorter legs when sitting
      
      // Left foot in sitting position
      pushMatrix();
      translate(0, 35);
      rotate(radians(45));
      fill(60, 30, 0); // Brown shoes
      ellipse(0, 3, 22, 14);
      fill(100, 60, 30);
      ellipse(0, 1, 16, 8);
      popMatrix();
    } else {
      // Walking/standing position
      rotate(radians(legSwing));
      rect(-9, 0, 18, 50, 5);
      
      // Left foot
      pushMatrix();
      translate(0, 50);
      rotate(radians(-legSwing * 0.5));
      fill(60, 30, 0); // Brown shoes
      ellipse(0, 3, 22, 14);
      fill(100, 60, 30);
      ellipse(0, 1, 16, 8);
      popMatrix();
    }
    popMatrix();
    
    // Right leg
    pushMatrix();
    translate(10, 62);
    
    if (currentAnimation.equals("sitting") || currentAnimation.equals("eating") || 
        currentAnimation.equals("chewing") || currentAnimation.equals("preparing") ||
        currentAnimation.equals("offering") || currentAnimation.equals("receiving")) {
      // Sitting position - legs bent forward
      rotate(radians(45 + sittingPose));
      fill(60, 40, 40);
      rect(-9, 0, 18, 35, 5); // Shorter legs when sitting
      
      // Right foot in sitting position
      pushMatrix();
      translate(0, 35);
      rotate(radians(45));
      fill(60, 30, 0); // Brown shoes
      ellipse(0, 3, 22, 14);
      fill(100, 60, 30);
      ellipse(0, 1, 16, 8);
      popMatrix();
    } else {
      // Walking/standing position
      rotate(radians(-legSwing));
      fill(60, 40, 40);
      rect(-9, 0, 18, 50, 5);
      
      // Right foot
      pushMatrix();
      translate(0, 50);
      rotate(radians(legSwing * 0.5));
      fill(60, 30, 0); // Brown shoes
      ellipse(0, 3, 22, 14);
      fill(100, 60, 30);
      ellipse(0, 1, 16, 8);
      popMatrix();
    }
    popMatrix();
    
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

// Mother character class - redesigned to match Joko's style with long hair
class Mom extends Character {
  // Mom-specific properties
  float hairSway;
  boolean isCarryingFood;
  float cookingMotion;
  float servingGesture;
  float concernLevel;
  
  Mom(float x, float y) {
    super(x, y, color(205, 164, 125), 130); // Same skin tone as Joko, slightly larger size
    hairSway = 0;
    isCarryingFood = false;
    cookingMotion = 0;
    servingGesture = 0;
    concernLevel = 0;
  }
  
  void updateEatingAnimations() {
    // Update Mom-specific animations based on current animation
    switch (currentAnimation) {
      case "cooking":
        cookingMotion = sin(animationTime * 6) * 8; // Stirring motion
        break;
      case "preparing":
        cookingMotion = sin(animationTime * 4) * 5; // Chopping motion
        break;
      case "carrying":
        isCarryingFood = true;
        hairSway = sin(walkCycle) * 5;
        break;
      case "serving":
        servingGesture = sin(animationTime * 3) * 10;
        isCarryingFood = false;
        break;
      case "concerned":
        concernLevel = 0.3;
        break;
      case "disappointed":
        concernLevel = 0.6;
        break;
      case "very_disappointed":
        concernLevel = 1.0;
        break;
      case "blank_stare":
        concernLevel = 0.1;
        break;
      case "dismissive":
        concernLevel = 0.4;
        break;
      case "approaching":
        concernLevel = 0.2;
        armSwing = sin(animationTime * 1) * 3;
        break;
      case "caring":
        concernLevel = 0.1;
        servingGesture = sin(animationTime * 1.5) * 5;
        break;
      case "forgiving":
        concernLevel = 0.0;
        armSwing = sin(animationTime * 0.8) * 4;
        servingGesture = sin(animationTime * 1) * 8;
        break;
      case "gentle_smile":
        concernLevel = 0.0;
        bobOffset = sin(animationTime * 0.3) * 0.5;
        break;
      default:
        cookingMotion *= 0.9;
        servingGesture *= 0.9;
        concernLevel *= 0.95;
        isCarryingFood = false;
        break;
    }
  }
  
  void draw() {
    pushMatrix();
    translate(position.x, position.y + bobOffset);
    scale(1.6); // Make Mom character larger
    
    // Body (wearing a simple, elegant dress)
    fill(150, 120, 180); // Soft lavender dress color
    noStroke();
    ellipse(0, 0, size * 0.6, size * 0.9); // Dress shape
    
    // Dress details (e.g., a simple neckline)
    fill(170, 140, 200);
    arc(0, -size * 0.3, size * 0.4, size * 0.3, 0, PI);
    
    // Head (similar style to Joko)
    pushMatrix();
    translate(0, -headBob);
    
    // Long, flowing dark hair (drawn first, behind the face)
    fill(45, 25, 15); // Dark brown/black hair
    noStroke();
    // Main hair mass
    ellipse(0, -45, 70, 80);
    
    // Hair strands for movement and texture
    fill(60, 35, 20);
    ellipse(-25, -30, 15, 50); // Left side hair
    ellipse(25, -30, 15, 50);  // Right side hair
    ellipse(0, -20, 20, 60);   // Back hair
    
    // Face shape
    fill(205, 164, 125); // Same skin tone as Joko
    noStroke();
    ellipse(0, -35, 58, 58);
    
    // Eyes (large, expressive, and kind)
    fill(255); // White of eyes
    noStroke();
    ellipse(-12, -40, 18, 16);
    ellipse(12, -40, 18, 16);
    
    // Eye pupils
    fill(0);
    ellipse(-12, -40, 11, 11);
    ellipse(12, -40, 11, 11);
    
    // Eye sparkles (gentle and warm)
    fill(255);
    ellipse(-14, -42, 5, 5);
    ellipse(10, -42, 5, 5);
    ellipse(-10, -38, 2.5, 2.5);
    ellipse(14, -38, 2.5, 2.5);
    
    // Eyebrows (soft and gentle)
    fill(45, 25, 15);
    arc(-12, -50, 15, 8, PI, TWO_PI);
    arc(12, -50, 15, 8, PI, TWO_PI);
    
    // Nose (similar to Joko's but softer)
    fill(180, 140, 100);
    ellipse(0, -32, 7, 9);
    
    // Mouth (gentle smile)
    noFill();
    stroke(139, 69, 19);
    strokeWeight(2);
    arc(0, -25, 20, 12, 0, PI);
    
    popMatrix(); // End head matrix
    
    // Arms
    stroke(205, 164, 125); // Skin tone
    strokeWeight(10);
    
    // Left arm
    line(-size * 0.25, -size * 0.1, -size * 0.4 + armSwing, size * 0.2);
    // Right arm
    line(size * 0.25, -size * 0.1, size * 0.4 - armSwing, size * 0.2);
    
    // Hands
    fill(205, 164, 125); // Skin tone
    noStroke();
    ellipse(-size * 0.4 + armSwing, size * 0.2, 12, 12); // Left hand
    ellipse(size * 0.4 - armSwing, size * 0.2, 12, 12); // Right hand
    
    // Legs (partially visible)
    fill(150, 120, 180); // Dress color
    noStroke();
    rect(-size * 0.15, size * 0.4, 15, 20);
    rect(size * 0.05, size * 0.4, 15, 20);
    
    // Feet
    fill(205, 164, 125); // Skin tone
    noStroke();
    ellipse(-size * 0.1, size * 0.55, 18, 10);
    ellipse(size * 0.1, size * 0.55, 18, 10);
    
    popMatrix(); // End main character matrix
  }
}
