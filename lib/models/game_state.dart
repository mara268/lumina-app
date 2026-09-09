class GameState {
  int currentPhase;
  List<String> unlockedAchievements;

  GameState({
    this.currentPhase = 1,
    List<String>? unlockedAchievements,
  }) : unlockedAchievements = unlockedAchievements ?? [];

  void completePhase(int phase, String achievementName) {
    if (!unlockedAchievements.contains(achievementName)) {
      unlockedAchievements.add(achievementName);
    }
    if (currentPhase <= phase && currentPhase < 5) {
      currentPhase = phase + 1;
    }
  }
}