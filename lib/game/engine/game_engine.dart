import 'dart:math';
import '../../data/models/player_model.dart';
import '../../data/models/case_model.dart';
import '../../data/models/evidence_model.dart'; // ✅ أضف هذا السطر
import '../../data/models/character_model.dart'; // ✅ أضف هذا السطر
import '../cases/case_database.dart';

enum GamePhase {
  setup, caseSelection, roleDistribution, evidencePhase,
  discussion, voting, elimination, endgame, juryDeliberation,
}

class GameEngine {
  final List<Player> players;
  final List<String> eliminatedPlayers;
  GameCase? currentCase;
  GamePhase currentPhase;
  int currentRound;
  int evidenceIndex;
  final List<GameCase> usedCases;
  Map<String, int> votes;

  GameEngine({
    required this.players,
    this.eliminatedPlayers = const [],
    this.currentPhase = GamePhase.setup,
    this.currentRound = 0,
    this.evidenceIndex = 0,
    this.usedCases = const [],
    this.votes = const {},
  });

  factory GameEngine.initialize(List<String> playerNames) {
    final players = List.generate(playerNames.length, (index) {
      return Player(
        id: 'player_$index',
        name: playerNames[index],
        characterId: '',
        isAlive: true,
        isMafia: false,
      );
    });
    return GameEngine(players: players);
  }

  GameCase selectCase() {
    final availableCases = CaseDatabase.cases
        .where((c) => !usedCases.map((uc) => uc.id).contains(c.id))
        .toList();

    if (availableCases.isEmpty) {
      usedCases.clear();
      return selectCase();
    }

    final random = Random();
    final selectedCase = availableCases[random.nextInt(availableCases.length)];
    usedCases.add(selectedCase);
    currentCase = selectedCase;
    currentPhase = GamePhase.roleDistribution;
    return selectedCase;
  }

  List<Player> assignRoles() {
    if (currentCase == null) throw Exception('No case selected');

    final mafiaCount = players.length >= 5 ? 2 : 1;
    final random = Random();
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);
    
    return shuffledPlayers.asMap().entries.map((entry) {
      final index = entry.key;
      final player = entry.value;
      final isMafia = index < mafiaCount;
      final characterIndex = index % currentCase!.suspects.length;
      final character = currentCase!.suspects[characterIndex];
      
      return player.copyWith(
        characterId: character.id,
        isMafia: isMafia,
      );
    }).toList();
  }

  // ✅ Evidence موجودة الآن
  Evidence? getCurrentEvidence() {
    if (currentCase == null || evidenceIndex >= currentCase!.evidenceCards.length) {
      return null;
    }
    return currentCase!.evidenceCards[evidenceIndex];
  }

  bool nextEvidence() {
    if (currentCase == null) return false;
    if (evidenceIndex < currentCase!.evidenceCards.length - 1) {
      evidenceIndex++;
      return true;
    }
    return false;
  }

  Player? processVotes(Map<String, String> playerVotes) {
    final voteCount = <String, int>{};
    for (final vote in playerVotes.values) {
      voteCount[vote] = (voteCount[vote] ?? 0) + 1;
    }
    String? eliminatedId;
    int maxVotes = 0;
    voteCount.forEach((playerId, count) {
      if (count > maxVotes) {
        maxVotes = count;
        eliminatedId = playerId;
      }
    });
    if (eliminatedId != null) {
      final eliminatedPlayer = players.firstWhere((p) => p.id == eliminatedId);
      return eliminatedPlayer.copyWith(isAlive: false, isEliminated: true);
    }
    return null;
  }

  GameResult? checkWinCondition() {
    final alivePlayers = players.where((p) => p.isAlive).toList();
    final aliveMafia = alivePlayers.where((p) => p.isMafia).toList();
    final aliveInnocents = alivePlayers.where((p) => !p.isMafia).toList();
    if (aliveMafia.isEmpty) return GameResult.innocentsWin;
    if (aliveMafia.length >= aliveInnocents.length) return GameResult.mafiaWin;
    if (alivePlayers.length <= 2) return GameResult.juryPhase;
    return null;
  }
}

enum GameResult { innocentsWin, mafiaWin, juryPhase }