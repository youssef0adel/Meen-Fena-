import '../../data/models/player_model.dart';

class JurySystem {
  // ✅ اللاعبين اللي خرجوا (المحلفين)
  final List<Player> eliminatedPlayers;
  
  // ✅ اللاعبين المتبقيين (المشتبه بهم النهائيين)
  final List<Player> finalSuspects;

  JurySystem({
    required this.eliminatedPlayers,
    required this.finalSuspects,
  });

  // ✅ المحلفين يصوتوا على المشتبه بهم
  Map<String, int> conductJuryVote(Map<String, String> juryVotes) {
    final voteCount = <String, int>{};
    
    for (final suspect in finalSuspects) {
      voteCount[suspect.id] = 0;
    }
    
    for (final vote in juryVotes.values) {
      if (voteCount.containsKey(vote)) {
        voteCount[vote] = (voteCount[vote] ?? 0) + 1;
      }
    }
    
    return voteCount;
  }

  // ✅ تحديد الفائز بناءً على تصويت المحلفين
  Player? determineWinner(Map<String, int> voteCount) {
    int maxVotes = 0;
    String? winnerId;
    
    voteCount.forEach((playerId, count) {
      if (count > maxVotes) {
        maxVotes = count;
        winnerId = playerId;
      }
    });

    if (winnerId != null) {
      return finalSuspects.firstWhere((p) => p.id == winnerId);
    }
    return null;
  }
}