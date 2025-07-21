// The Lesson of the Rice - Main Animation File
// Complete 4-scene animation with emotional resolution

// Import Sound library for background music
import processing.sound.*;

// Global variables
SceneManager sceneManager;
AudioManager audioManager;

// Global reference for audio
PApplet sketchRef;

// Scene timing (in frames, 30fps)
final int SCENE1_DURATION = 900; // 30 seconds at 30fps
final int SCENE2_DURATION = 900; // 30 seconds at 30fps
final int SCENE3_DURATION = 900; // 30 seconds at 30fps
final int SCENE4_DURATION = 1800; // 60 seconds at 30fps
final int SCENE5_DURATION = 1200; // 40 seconds at 30fps (lesson learned)
final int TOTAL_FRAMES = 6600; // 220 seconds total (3 minutes 40 seconds)

// Screen dimensions
final int SCREEN_WIDTH = 1280;
final int SCREEN_HEIGHT = 720;

// ========================================
// ENTRY POINT: This function runs once when the program starts
// ========================================
void setup() {
  size(1280, 720);
  frameRate(30); // 30fps for stable performance
  
  // Set global reference
  sketchRef = this;
  
  // Initialize managers
  sceneManager = new SceneManager();
  audioManager = new AudioManager();
  
  // Load background music after AudioManager is created
  audioManager.initializeMusic(this);
  
  // Set up scene 1 as starting point
  sceneManager.setCurrentScene(1);
  
  println("========================================");
  println("Starting 'The Lesson of the Rice' Animation");
  println("Total Runtime: 3 minutes 40 seconds (220 seconds)");
  println("Scene 1: Meeting Friend - Field, Afternoon");
  println("========================================");
}

// ========================================
// MAIN LOOP: This function runs continuously (30 times per second)
// ========================================
void draw() {
  background(135, 206, 235); // Sky blue background
  
  // Update and draw current scene
  sceneManager.update();
  sceneManager.draw();
  
  // Handle speaking animations
  sceneManager.handleSpeaking();
  
  // Handle audio for current scene
  if (sceneManager.getCurrentScene() == 1) {
    audioManager.handleScene1Audio(frameCount - sceneManager.getSceneStartFrame());
  } else if (sceneManager.getCurrentScene() == 2) {
    audioManager.handleScene2Audio(frameCount - sceneManager.getSceneStartFrame());
  } else if (sceneManager.getCurrentScene() == 3) {
    audioManager.handleScene3Audio(frameCount - sceneManager.getSceneStartFrame());
  } else if (sceneManager.getCurrentScene() == 4) {
    audioManager.handleScene4Audio(frameCount - sceneManager.getSceneStartFrame());
  } else if (sceneManager.getCurrentScene() == 5) {
    audioManager.handleScene5Audio(frameCount - sceneManager.getSceneStartFrame());
  }
  
  // Draw narration on screen
  audioManager.drawNarration();
  
  // Display frame info for debugging (moved to avoid narration overlap)
  fill(255);
  textSize(14);
  text("Frame: " + frameCount + " | Scene: " + sceneManager.getCurrentScene() + " | FPS: " + nf(frameRate, 0, 1), 10, height - 50);
  
  // Display controls
  textSize(12);
  text("Controls: [SPACE] Pause | [R] Restart | [1] Scene 1 | [2] Scene 2 | [3] Scene 3 | [4] Scene 4 | [5] Lesson", 10, height - 20);
}

// ========================================
// INPUT HANDLER: This function runs when a key is pressed
// ========================================
void keyPressed() {
  println("Key pressed: " + key); // Debug output
  
  if (key == ' ') {
    // Space to pause/resume
    if (sceneManager.isPaused()) {
      sceneManager.resume();
      println("Resumed animation");
    } else {
      sceneManager.pause();
      println("Paused animation");
    }
  }
  
  if (key == 'r' || key == 'R') {
    // R to restart
    sceneManager.restart();
    println("Restarted animation");
  }
  
  if (key == '1') {
    // 1 to go to Scene 1
    sceneManager.setCurrentScene(1);
    println("Switched to Scene 1");
  }
  
  if (key == '2') {
    // 2 to go to Scene 2
    sceneManager.setCurrentScene(2);
    println("Switched to Scene 2");
  }
  
  if (key == '3') {
    // 3 to go to Scene 3
    sceneManager.setCurrentScene(3);
    println("Switched to Scene 3");
  }
  
  if (key == '4') {
    // 4 to go to Scene 4 (Extended Awakening)
    sceneManager.setCurrentScene(4);
    println("Switched to Scene 4");
  }
  
  if (key == '5') {
    // 5 to go to Scene 5 (The Lesson Learned)
    sceneManager.setCurrentScene(5);
    println("Switched to Scene 5: The Lesson Learned");
  }
}
