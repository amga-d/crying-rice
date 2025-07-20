// The Lesson of the Rice - Main Animation File
// Scene 1: Meeting Friend - Field, Afternoon

// Global variables
SceneManager sceneManager;
AudioManager audioManager;

// Scene timing (in frames, 60fps)
final int SCENE1_DURATION = 1800; // 30 seconds at 60fps
final int TOTAL_FRAMES = 9000; // 150 seconds total

// Screen dimensions
final int SCREEN_WIDTH = 1280;
final int SCREEN_HEIGHT = 720;

void setup() {
  size(1280, 720);
  
  // Initialize managers
  sceneManager = new SceneManager();
  audioManager = new AudioManager();
  
  // Set up scene 1
  sceneManager.setCurrentScene(1);
  
  println("Starting 'The Lesson of the Rice' Animation");
  println("Scene 1: Meeting Friend - Field, Afternoon");
}

void draw() {
  background(135, 206, 235); // Sky blue background
  
  // Update and draw current scene
  sceneManager.update();
  sceneManager.draw();
  
  // Handle audio for current scene
  if (sceneManager.getCurrentScene() == 1) {
    audioManager.handleScene1Audio(frameCount - sceneManager.getSceneStartFrame());
  }
  
  // Display frame info for debugging
  fill(255);
  textSize(16);
  text("Frame: " + frameCount + " | Scene: " + sceneManager.getCurrentScene() + " | FPS: " + nf(frameRate, 0, 1), 10, 30);
}

void keyPressed() {
  if (key == ' ') {
    // Space to pause/resume
    if (sceneManager.isPaused()) {
      sceneManager.resume();
    } else {
      sceneManager.pause();
    }
  }
  
  if (key == 'r' || key == 'R') {
    // R to restart
    sceneManager.restart();
  }
}
