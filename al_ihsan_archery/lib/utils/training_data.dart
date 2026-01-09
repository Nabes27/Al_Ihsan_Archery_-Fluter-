class TrainingSession {
  String id;
  DateTime date;
  int numberOfPlayers;
  List<String> playerNames;
  int numberOfRounds;
  int arrowsPerRound;
  String targetType;
  Map<String, List<List<String>>> scores; // playerName -> rounds -> arrows
  
  TrainingSession({
    required this.id,
    required this.date,
    required this.numberOfPlayers,
    required this.playerNames,
    required this.numberOfRounds,
    required this.arrowsPerRound,
    required this.targetType,
    required this.scores,
  });

  int getTotalScore(String playerName) {
    int total = 0;
    if (scores[playerName] != null) {
      for (var round in scores[playerName]!) {
        for (var score in round) {
          total += convertScoreToInt(score);
        }
      }
    }
    return total;
  }

  double getAverageScore(String playerName) {
    int total = getTotalScore(playerName);
    int totalArrows = numberOfRounds * arrowsPerRound;
    return totalArrows > 0 ? total / totalArrows : 0;
  }

  int convertScoreToInt(String score) {
    if (score == 'X') return 10;
    if (score == 'M' || score.isEmpty) return 0;
    return int.tryParse(score) ?? 0;
  }

  bool isComplete() {
    for (var playerName in playerNames) {
      if (scores[playerName] == null) return false;
      if (scores[playerName]!.length < numberOfRounds) return false;
      for (var round in scores[playerName]!) {
        if (round.length < arrowsPerRound) return false;
        if (round.any((score) => score.isEmpty)) return false;
      }
    }
    return true;
  }
}

class TrainingData {
  static final TrainingData _instance = TrainingData._internal();
  
  factory TrainingData() {
    return _instance;
  }
  
  TrainingData._internal();

  List<TrainingSession> sessions = [];
  TrainingSession? currentSession;

  void addSession(TrainingSession session) {
    sessions.add(session);
  }

  void saveCurrentSession() {
    if (currentSession != null && currentSession!.isComplete()) {
      addSession(currentSession!);
      currentSession = null;
    }
  }

  List<TrainingSession> getCompletedSessions() {
    return sessions.where((s) => s.isComplete()).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
