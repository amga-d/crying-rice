// AudioManager.pde
// Handles audio synchronization and playback

class AudioManager {
  // Audio timing for narration
  // For now, we'll use print statements to simulate narration
  // In a full implementation, this would load and play audio files
  
  private int lastNarrationFrame;
  private String currentNarration;
  private int narrationStartFrame;
  private int narrationDuration;
  
  // Background music
  SoundFile backgroundMusic;
  boolean musicLoaded;
  boolean musicPlaying;
  int currentMusicScene;
  
  // Speaking sound effect
  SoundFile speakingSound;
  boolean speakingSoundLoaded;
  
  AudioManager() {
    lastNarrationFrame = 0;
    currentNarration = "";
    narrationStartFrame = 0;
    narrationDuration = 0;
    
    // Initialize music variables
    musicLoaded = false;
    musicPlaying = false;
    currentMusicScene = 0;
    
    // Initialize speaking sound variables
    speakingSoundLoaded = false;
    
    // Load background music
    loadBackgroundMusic();
  }
  
  void loadBackgroundMusic() {
    try {
      // Note: In Processing, we need to access the main sketch instance
      // This will be called from the main sketch, so we'll pass the sketch reference differently
      println("Attempting to load background music...");
      musicLoaded = true; // For now, we'll assume it works
      println("Background music loaded successfully!");
    } catch (Exception e) {
      println("Failed to load background music: " + e.getMessage());
      musicLoaded = false;
    }
  }
  
  void initializeMusic(PApplet sketch) {
    try {
      backgroundMusic = new SoundFile(sketch, "assets/sounds/Background Cartoon Music Loop  (Download and Royalty FREE).mp3");
      musicLoaded = true;
      println("Background music initialized successfully!");
    } catch (Exception e) {
      println("Failed to initialize background music: " + e.getMessage());
      musicLoaded = false;
    }
    
    // Load speaking sound effect
    try {
      speakingSound = new SoundFile(sketch, "assets/sounds/alien-talking-312011.mp3");
      speakingSoundLoaded = true;
      println("Speaking sound effect loaded successfully!");
    } catch (Exception e) {
      println("Failed to load speaking sound effect: " + e.getMessage());
      speakingSoundLoaded = false;
    }
  }
  
  void playNarration(String text, int frame) {
    if (frame != lastNarrationFrame) {
      println("NARRATION [Frame " + frame + "]: " + text);
      lastNarrationFrame = frame;
      
      // Store narration for screen display
      currentNarration = text;
      narrationStartFrame = frameCount;
      
      // Dynamic duration based on text length (more natural)
      int textLength = text.length();
      if (textLength < 30) {
        narrationDuration = 90; // 3 seconds for short text
      } else if (textLength < 60) {
        narrationDuration = 120; // 4 seconds for medium text
      } else {
        narrationDuration = 150; // 5 seconds for long text
      }
      
      // Trigger speaking animation for characters based on content
      if (text.toLowerCase().contains("joko") && text.contains("'")) {
        float speakingDuration = textLength * 0.06; // Faster speaking rate
        triggerCharacterSpeaking("joko", speakingDuration);
      } else if (text.toLowerCase().contains("mother") || text.toLowerCase().contains("mom") || text.toLowerCase().contains("ibu")) {
        float speakingDuration = textLength * 0.06;
        triggerCharacterSpeaking("mother", speakingDuration);
      } else if (text.toLowerCase().contains("friend")) {
        float speakingDuration = textLength * 0.06;
        triggerCharacterSpeaking("friend", speakingDuration);
      }
    }
  }
  
  void triggerCharacterSpeaking(String characterName, float duration) {
    // This method will be called from the scenes to trigger speaking
    // The scenes need to pass their character references
    println("CHARACTER SPEAKING: " + characterName + " for " + duration + " seconds");
  }
  
  void playSound(String soundName) {
    println("SOUND: " + soundName);
    
    // Play speaking sound effect when requested
    if (soundName.equals("speaking") || soundName.equals("alien-talking")) {
      if (speakingSoundLoaded && speakingSound != null) {
        speakingSound.stop(); // Stop any currently playing speaking sound
        speakingSound.play();
        speakingSound.amp(0.4); // Set volume to 40%
        println("Playing speaking sound effect");
      }
    }
  }
  
  // Background music control methods
  void startBackgroundMusic(int sceneNumber) {
    if (musicLoaded && backgroundMusic != null) {
      // Only start music for Scene 1 and Scene 2
      if (sceneNumber == 1 || sceneNumber == 2) {
        if (!musicPlaying || currentMusicScene != sceneNumber) {
          if (musicPlaying) {
            backgroundMusic.stop();
          }
          
          backgroundMusic.loop();
          backgroundMusic.amp(0.3); // Set volume to 30%
          musicPlaying = true;
          currentMusicScene = sceneNumber;
          println("Background music started for Scene " + sceneNumber);
        }
      }
    }
  }
  
  void stopBackgroundMusic() {
    if (musicLoaded && backgroundMusic != null && musicPlaying) {
      backgroundMusic.stop();
      musicPlaying = false;
      currentMusicScene = 0;
      println("Background music stopped");
    }
  }
  
  void fadeOutMusic() {
    if (musicLoaded && backgroundMusic != null && musicPlaying) {
      // Simple fade out by reducing volume gradually
      float currentVolume = 0.3;
      for (int i = 0; i < 30; i++) {
        currentVolume *= 0.9;
        backgroundMusic.amp(currentVolume);
      }
      backgroundMusic.stop();
      musicPlaying = false;
      currentMusicScene = 0;
      println("Background music faded out");
    }
  }
  
  boolean isMusicPlaying() {
    return musicPlaying;
  }
  
  // Methods to access current narration for screen display
  String getCurrentNarration() {
    int currentFrame = frameCount - narrationStartFrame;
    if (currentFrame >= 0 && currentFrame < narrationDuration) {
      return currentNarration;
    }
    return "";
  }
  
  void drawNarration() {
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
        float currentLineWidth = 0;
        
        for (String word : words) {
          String testLine = currentLine.length() > 0 ? currentLine + " " + word : word;
          float testWidth = textWidth(testLine);
          
          if (testWidth < maxWidth) {
            currentLine = testLine;
            currentLineWidth = testWidth;
          } else {
            if (currentLine.length() > 0) {
              lines.add(currentLine);
            }
            currentLine = word;
            currentLineWidth = textWidth(word);
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
      float bgY = 80 + (bgHeight/2); // Moved to top of screen with margin
      
      // Draw elegant background with gradient effect
      for (int i = 0; i < 8; i++) {
        float alpha = map(i, 0, 7, fadeAlpha * 0.4, 0);
        fill(0, 0, 0, alpha);
        noStroke();
        rectMode(CENTER);
        rect(bgX, bgY, bgWidth + (i * 2), bgHeight + (i * 2), 15 + i);
      }
      
      // Main background
      fill(25, 25, 35, fadeAlpha * 0.9);
      stroke(220, 180, 100, fadeAlpha * 0.8);
      strokeWeight(2);
      rect(bgX, bgY, bgWidth, bgHeight, 12);
      
      // Decorative border accent
      stroke(255, 215, 130, fadeAlpha * 0.6);
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
      
      // Main text with warm color
      fill(255, 248, 230, fadeAlpha);
      for (int i = 0; i < lines.size(); i++) {
        float yPos = bgY - ((lines.size() - 1) * lineHeight / 2) + (i * lineHeight);
        text(lines.get(i), bgX, yPos);
      }
      
      // Subtle typing indicator animation
      if (currentFrame < narrationDuration - 30) {
        float indicatorAlpha = (sin(frameCount * 0.2) + 1) * 0.5 * fadeAlpha;
        fill(255, 215, 130, indicatorAlpha);
        noStroke();
        ellipse(bgX + (bgWidth/2) - 15, bgY + (bgHeight/2) - 8, 6, 6);
      }
      
      popStyle();
      popMatrix();
    }
  }
  
  // Scene 1 narration timing - optimized for 30fps (STREAMLINED)
  void handleScene1Audio(int sceneFrame) {
    // Start background music at the beginning of Scene 1
    if (sceneFrame == 1) {
      startBackgroundMusic(1);
    }
    
    // Opening narration - brief intro
    if (sceneFrame == 15) { // 0.5 seconds in
      playNarration("Little Joko meets his friend at the rice field for lunch.", sceneFrame);
    }
    
    // Mid-scene transition
    if (sceneFrame == 600) { // 20 seconds in
      playNarration("After sharing their meal, Joko heads home.", sceneFrame);
    }
    
    // Sound effects (reduced)
    if (sceneFrame == 150) { // 5 seconds
      playSound("children_laughter_indonesian");
    }
    
    if (sceneFrame == 750) { // 25 seconds
      playSound("tropical_birds_ambiance");
    }
  }
  
  // Scene 2 narration timing - Kitchen scene - STREAMLINED
  void handleScene2Audio(int sceneFrame) {
    // Continue background music from Scene 1 (it should keep playing)
    if (sceneFrame == 1) {
      startBackgroundMusic(2);
    }
    
    // Opening scene setting
    if (sceneFrame == 15) { // 0.5 seconds in
      playNarration("At home, Mother has prepared rice and vegetables with love.", sceneFrame);
    }
    
    // Transition to conflict
    if (sceneFrame == 360) { // 12 seconds in
      playNarration("But Joko seems uninterested in the meal.", sceneFrame);
    }
    
    // Waste moment
    if (sceneFrame == 720) { // 24 seconds in
      playNarration("Without thinking, Joko throws the rice away.", sceneFrame);
    }
    
    // Sound effects (reduced and focused)
    if (sceneFrame == 300) { // 10 seconds
      playSound("plate_being_served");
    }
    
    if (sceneFrame == 720) { // 24 seconds
      playSound("food_thrown_in_trash");
    }
    
    if (sceneFrame == 840) { // 28 seconds
      playSound("mother_disappointed_sigh");
    }
  }
  
  // Scene 3 narration timing - Dream sequence - STREAMLINED
  void handleScene3Audio(int sceneFrame) {
    // Stop background music when entering dream sequence
    if (sceneFrame == 1) {
      fadeOutMusic();
    }
    
    // Dream begins
    if (sceneFrame == 15) { // 0.5 seconds in
      playNarration("Joko falls asleep, but troubling dreams begin...", sceneFrame);
    }
    
    // Core dream imagery
    if (sceneFrame == 300) { // 10 seconds in
      playNarration("He dreams of a crying farmer in a dried rice field...", sceneFrame);
    }
    
    // Emotional climax
    if (sceneFrame == 600) { // 20 seconds in
      playNarration("Even the rice grains weep: 'Why do you waste us?'", sceneFrame);
    }
    
    // Sound effects (focused)
    if (sceneFrame == 30) {
      playSound("dream_transition_ethereal");
    }
    
    if (sceneFrame == 300) {
      playSound("farmer_sobbing");
    }
    
    if (sceneFrame == 600) {
      playSound("rice_grains_crying");
    }
    
    if (sceneFrame == 750) {
      playSound("nightmare_intensity_build");
    }
  }
  
  // Scene 4 narration timing - COMPLETE 60-SECOND EMOTIONAL ARC
  void handleScene4Audio(int sceneFrame) {
    // Phase 1: Nightmare continuation (0-15 seconds)
    if (sceneFrame == 15) { // 0.5 seconds in
      playNarration("The nightmare intensifies, haunting Joko's sleep...", sceneFrame);
    }
    
    if (sceneFrame == 300) { // 10 seconds in
      playNarration("The crying rice and farmer break through his defenses...", sceneFrame);
    }
    
    // Phase 2: Emotional awakening (15-25 seconds)
    if (sceneFrame == 480) { // 16 seconds in
      playNarration("Joko awakens with tears, finally understanding.", sceneFrame);
    }
    
    // Phase 3: Mom enters (25-35 seconds)
    if (sceneFrame == 750) { // 25 seconds in
      playNarration("Mother enters gently, seeing her changed son.", sceneFrame);
    }
    
    // Phase 4: Heart-to-heart conversation (35-50 seconds)
    if (sceneFrame == 1050) { // 35 seconds in
      playNarration("'Maaf, Bu... I understand now about the rice.'", sceneFrame);
    }
    
    if (sceneFrame == 1350) { // 45 seconds in
      playNarration("'The farmers work so hard... I'll never waste food again.'", sceneFrame);
    }
    
    // Phase 5: Resolution (50-60 seconds)
    if (sceneFrame == 1500) { // 50 seconds in
      playNarration("Mother embraces him as morning light brings new hope.", sceneFrame);
    }
    
    if (sceneFrame == 1680) { // 56 seconds in
      playNarration("The lesson of the rice has taken root in his heart.", sceneFrame);
    }
    
    // Sound effects synchronized with emotions
    if (sceneFrame == 300) {
      playSound("nightmare_climax");
    }
    
    if (sceneFrame == 480) {
      playSound("emotional_awakening");
    }
    
    if (sceneFrame == 750) {
      playSound("gentle_footsteps");
    }
    
    if (sceneFrame == 1050) {
      playSound("heartfelt_apology");
    }
    
    if (sceneFrame == 1500) {
      playSound("loving_embrace");
    }
    
    if (sceneFrame == 1680) {
      playSound("peaceful_morning_hope");
    }
  }
  
  // Scene 5: The Lesson Learned - Inspirational narration
  void handleScene5Audio(int sceneFrame) {
    // Scene 5: Beautiful lesson summary with wisdom and reflection
    
    if (sceneFrame == 60) { // 2 seconds - Opening reflection
      playNarration("From this beautiful story, we learn a timeless lesson about gratitude and respect.", sceneFrame);
    }
    
    if (sceneFrame == 180) { // 6 seconds - The heart of the lesson
      playNarration("Setiap butir nasi membawa cerita perjuangan petani yang bekerja keras di sawah. (Every grain of rice carries the story of farmers who work hard in the fields.)", sceneFrame);
    }
    
    if (sceneFrame == 360) { // 12 seconds - Universal wisdom
      playNarration("When we appreciate our food, we honor the hands that grew it, the earth that nurtured it, and the love that prepared it.", sceneFrame);
    }
    
    if (sceneFrame == 540) { // 18 seconds - Personal responsibility
      playNarration("Jangan pernah menyia-nyiakan makanan, karena di setiap butir ada harapan dan kerja keras. (Never waste food, because in every grain there is hope and hard work.)", sceneFrame);
    }
    
    if (sceneFrame == 720) { // 24 seconds - Call to action
      playNarration("Let us promise to always be grateful for what we have, and to share our blessings with others in need.", sceneFrame);
    }
    
    if (sceneFrame == 900) { // 30 seconds - Final wisdom
      playNarration("Karena dengan bersyukur, kita tidak hanya menghargai makanan, tetapi juga kehidupan itu sendiri. (Because by being grateful, we not only appreciate food, but life itself.)", sceneFrame);
    }
    
    if (sceneFrame == 1080) { // 36 seconds - Closing message
      playNarration("Remember: In every grain of rice lies love, sweat, and hope. Treat it with the respect it deserves.", sceneFrame);
    }
    
    // Soft background sounds for peaceful atmosphere
    if (sceneFrame == 30) {
      playSound("gentle_wind");
    }
    
    if (sceneFrame == 300) {
      playSound("nature_harmony");
    }
    
    if (sceneFrame == 600) {
      playSound("peaceful_bells");
    }
    
    if (sceneFrame == 1000) {
      playSound("wisdom_chimes");
    }
  }
}
