// SceneManager.pde
// Manages scene transitions and timing

class SceneManager {
  private int currentScene;
  private int sceneStartFrame;
  private boolean paused;
  
  // Scene objects
  private Scene1_Field scene1;
  
  SceneManager() {
    currentScene = 1;
    sceneStartFrame = 0;
    paused = false;
    
    // Initialize scenes
    scene1 = new Scene1_Field();
  }
  
  void setCurrentScene(int sceneNum) {
    currentScene = sceneNum;
    sceneStartFrame = frameCount;
    
    // Initialize the specific scene
    switch(currentScene) {
      case 1:
        scene1.init();
        break;
    }
  }
  
  void update() {
    if (paused) return;
    
    int sceneFrame = frameCount - sceneStartFrame;
    
    switch(currentScene) {
      case 1:
        scene1.update(sceneFrame);
        
        // Check if scene 1 is complete (30 seconds)
        if (sceneFrame >= SCENE1_DURATION) {
          // Transition to scene 2 (not implemented yet)
          println("Scene 1 Complete - would transition to Scene 2");
        }
        break;
    }
  }
  
  void draw() {
    switch(currentScene) {
      case 1:
        scene1.draw();
        break;
    }
  }
  
  int getCurrentScene() {
    return currentScene;
  }
  
  int getSceneStartFrame() {
    return sceneStartFrame;
  }
  
  boolean isPaused() {
    return paused;
  }
  
  void pause() {
    paused = true;
  }
  
  void resume() {
    paused = false;
  }
  
  void restart() {
    setCurrentScene(1);
  }
}
