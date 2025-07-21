// SceneManager.pde
// Manages scene transitions and timing

class SceneManager {
  private int currentScene;
  private int sceneStartFrame;
  private boolean paused;
  
  // Scene objects
  private Scene1_Field scene1;
  private Scene2_Kitchen scene2;
  private Scene3_Dream scene3;
  private Scene4_Bedroom scene4;
  private Scene5_LessonLearned scene5;
  
  SceneManager() {
    currentScene = 1;
    sceneStartFrame = 0;
    paused = false;
    
    // Initialize scenes
    scene1 = new Scene1_Field();
    scene2 = new Scene2_Kitchen();
    scene3 = new Scene3_Dream();
    scene4 = new Scene4_Bedroom();
    scene5 = new Scene5_LessonLearned();
  }
  
  void setCurrentScene(int sceneNum) {
    currentScene = sceneNum;
    sceneStartFrame = frameCount;
    
    // Initialize the specific scene
    switch(currentScene) {
      case 1:
        scene1.init();
        break;
      case 2:
        scene2.init();
        break;
      case 3:
        scene3.init();
        break;
      case 4:
        scene4.init();
        break;
      case 5:
        scene5.init();
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
          // Transition to scene 2
          setCurrentScene(2);
          println("Transitioning to Scene 2: Kitchen");
        }
        break;
      case 2:
        scene2.update(sceneFrame);
        
        // Check if scene 2 is complete (30 seconds) 
        if (sceneFrame >= SCENE1_DURATION) {
          // Transition to scene 3
          setCurrentScene(3);
          println("Transitioning to Scene 3: Dream");
        }
        break;
      case 3:
        scene3.update(sceneFrame);
        
        // Check if scene 3 is complete (30 seconds) 
        if (sceneFrame >= SCENE1_DURATION) {
          // Transition to scene 4
          setCurrentScene(4);
          println("Transitioning to Scene 4: Bedroom");
        }
        break;
      case 4:
        scene4.update(sceneFrame);
        
        // Check if scene 4 is complete (60 seconds) 
        if (sceneFrame >= 1800) { // 60 seconds at 30fps
          // Transition to final lesson scene
          setCurrentScene(5);
          println("Transitioning to Scene 5: The Lesson Learned");
        }
        break;
      case 5:
        scene5.update(sceneFrame);
        
        // Final scene - runs indefinitely until restart
        if (sceneFrame >= 1200) { // 40 seconds for lesson scene
          println("Animation Complete - The Lesson of the Rice has been learned!");
          // Scene 5 continues running - user can restart manually
        }
        break;
    }
  }
  
  void draw() {
    switch(currentScene) {
      case 1:
        scene1.draw();
        break;
      case 2:
        scene2.draw();
        break;
      case 3:
        scene3.draw();
        break;
      case 4:
        scene4.draw();
        break;
      case 5:
        scene5.draw();
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
  
  // Handle speaking animations for current scene
  void handleSpeaking() {
    int sceneFrame = frameCount - sceneStartFrame;
    
    switch(currentScene) {
      case 1:
        scene1.handleSpeaking(sceneFrame);
        break;
      // Add other scenes as needed
    }
  }
}
