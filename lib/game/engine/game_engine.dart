import 'dart:math';
import '../../data/models/player_model.dart';
import '../../data/models/case_model.dart';
import '../../data/models/evidence_model.dart';
import '../cases/case_database.dart';

enum GamePhase {
  setup, caseSelection, roleDistribution, evidencePhase,
  discussion, voting, elimination, endgame, juryDeliberation,
}

class GameEngine {
  List<Player> players;
  List<String> eliminatedPlayers;
  GameCase? currentCase;
  GamePhase currentPhase;
  int currentRound;
  int evidenceIndex;
  List<GameCase> usedCases;
  Map<String, int> votes;

  GameEngine({
    required this.players,
    this.eliminatedPlayers = const [],
    this.currentPhase = GamePhase.setup,
    this.currentRound = 0,
    this.evidenceIndex = 0,
    List<GameCase>? usedCases,
    Map<String, int>? votes,
  })  : usedCases = usedCases ?? [],
        votes = votes ?? {};

  factory GameEngine.initialize(List<String> playerNames) {
    final players = List.generate(playerNames.length, (index) {
      return Player(id: 'player_$index', name: playerNames[index], characterId: '');
    });
    return GameEngine(players: players, usedCases: [], eliminatedPlayers: []);
  }

  GameCase selectCase() {
    final availableCases = CaseSelector.getCasesForPlayerCount(players.length)
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
    evidenceIndex = 0;
    return selectedCase;
  }

  List<Player> assignRoles() {
    if (currentCase == null) selectCase();
    if (currentCase == null) throw Exception('No case selected');

    final mafiaCount = players.length >= 5 ? 2 : 1;
    final random = Random();
    final shuffledPlayers = List<Player>.from(players)..shuffle(random);
    final mafiaIndices = <int>{};
    while (mafiaIndices.length < mafiaCount) {
      mafiaIndices.add(random.nextInt(players.length));
    }

    final updatedPlayers = <Player>[];
    for (int i = 0; i < shuffledPlayers.length; i++) {
      final player = shuffledPlayers[i];
      final isMafia = mafiaIndices.contains(i);
      final character = currentCase!.suspects[random.nextInt(currentCase!.suspects.length)];
      updatedPlayers.add(player.copyWith(characterId: character.id, isMafia: isMafia));
    }
    updatedPlayers.shuffle(random);
    players = updatedPlayers;
    return players;
  }

  Evidence? getEvidenceForRound(int round) {
    if (currentCase == null) return null;
    if (round < currentCase!.evidenceCards.length) {
      return currentCase!.evidenceCards[round];
    }
    return null;
  }

  Evidence? getCurrentEvidence() {
    if (currentCase == null || evidenceIndex >= currentCase!.evidenceCards.length) return null;
    return currentCase!.evidenceCards[evidenceIndex];
  }

  // ✅ دالة ترجع bool
  bool nextEvidence() {
    if (currentCase == null) return false;
    if (evidenceIndex < currentCase!.evidenceCards.length - 1) {
      evidenceIndex++;
      return true;
    }
    return false;
  }

  void advanceToNextEvidence() {
    if (currentCase != null && evidenceIndex < currentCase!.evidenceCards.length - 1) {
      evidenceIndex++;
    }
  }

  bool hasMoreEvidence() {
    if (currentCase == null) return false;
    return evidenceIndex < currentCase!.evidenceCards.length - 1;
  }

  Player? processVotes(Map<String, String> playerVotes) {
    final voteCount = <String, int>{};
    for (final vote in playerVotes.values) {
      voteCount[vote] = (voteCount[vote] ?? 0) + 1;
    }
    String eliminatedId = '';
    int maxVotes = 0;
    voteCount.forEach((playerId, count) {
      if (count > maxVotes) { maxVotes = count; eliminatedId = playerId; }
    });
    if (eliminatedId.isNotEmpty) {
      final index = players.indexWhere((p) => p.id == eliminatedId);
      if (index != -1) {
        players[index] = players[index].copyWith(isAlive: false, isEliminated: true);
        if (!eliminatedPlayers.contains(eliminatedId)) {
          eliminatedPlayers.add(eliminatedId);
        }
        return players[index];
      }
    }
    return null;
  }

  GameResult? checkWinCondition() {
    final alivePlayers = players.where((p) => p.isAlive).toList();
    final aliveMafia = alivePlayers.where((p) => p.isMafia).toList();
    final aliveInnocents = alivePlayers.where((p) => !p.isMafia).toList();

    if (aliveMafia.isEmpty) return GameResult.innocentsWin;
    if (aliveMafia.length >= aliveInnocents.length && alivePlayers.length > 2) return GameResult.mafiaWin;
    if (alivePlayers.length == 2) return GameResult.juryPhase;
    return null;
  }
}

enum GameResult { innocentsWin, mafiaWin, juryPhase }