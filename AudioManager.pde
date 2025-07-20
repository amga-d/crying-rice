// AudioManager.pde
// Handles audio synchronization and playback

class AudioManager {
  // Audio timing for narration
  // For now, we'll use print statements to simulate narration
  // In a full implementation, this would load and play audio files
  
  private int lastNarrationFrame;
  
  AudioManager() {
    lastNarrationFrame = 0;
  }
  
  void playNarration(String text, int frame) {
    if (frame != lastNarrationFrame) {
      println("NARRATION [Frame " + frame + "]: " + text);
      lastNarrationFrame = frame;
    }
  }
  
  void playSound(String soundName) {
    println("SOUND: " + soundName);
  }
  
  // Scene 1 narration timing
  void handleScene1Audio(int sceneFrame) {
    // Narration timing for Scene 1 - Indonesian cultural context
    if (sceneFrame == 60) { // 1 second in
      playNarration("Meet little Joko, a cheerful village boy who meets his friend at the sawah (rice field).", sceneFrame);
    }
    
    if (sceneFrame == 480) { // 8 seconds in
      playNarration("They laugh and share nasi with sayuran on a banana leaf under the warm Indonesian sky.", sceneFrame);
    }
    
    if (sceneFrame == 900) { // 15 seconds in
      playNarration("'Enak sekali! Let's eat and play!' says Joko happily.", sceneFrame);
    }
    
    if (sceneFrame == 1200) { // 20 seconds in
      playNarration("After sharing the traditional meal, Joko heads home through the village, full of energy.", sceneFrame);
    }
    
    // Sound effects with Indonesian ambiance
    if (sceneFrame == 300) {
      playSound("barefoot_on_soil");
    }
    
    if (sceneFrame == 480) {
      playSound("children_laughter_indonesian");
    }
    
    if (sceneFrame == 900) {
      playSound("eating_traditional_meal");
    }
    
    if (sceneFrame == 1500) {
      playSound("tropical_birds_ambiance");
    }
  }
}

// Create global instance
AudioManager audioManager;
