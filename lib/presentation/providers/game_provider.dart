import 'package:flutter/material.dart';
import '../../game/engine/game_engine.dart';
import '../../data/models/player_model.dart';
import '../../data/models/case_model.dart';
import '../../data/models/evidence_model.dart';

enum GamePhase {
  setup, caseSelection, roleDistribution, evidencePhase,
  discussion, voting, elimination, endgame, juryDeliberation,
}

class GameProvider extends ChangeNotifier {
  GameEngine? _gameEngine;
  List<Player> _players = [];
  GameCase? _currentCase;
  GamePhase _currentPhase = GamePhase.setup;
  Evidence? _currentEvidence;
  int _currentRound = 0;
  Player? _currentPlayer;
  Map<String, String> _votes = {};
  double _suspicionLevel = 0.0;

  GameEngine? get gameEngine => _gameEngine;
  List<Player> get players => _players;
  GameCase? get currentCase => _currentCase;
  GamePhase get currentPhase => _currentPhase;
  Evidence? get currentEvidence => _currentEvidence;
  int get currentRound => _currentRound;
  Player? get currentPlayer => _currentPlayer;
  Map<String, String> get votes => _votes;
  double get suspicionLevel => _suspicionLevel;
  List<Player> get alivePlayers => _players.where((p) => p.isAlive).toList();
  List<Player> get eliminatedPlayers => _players.where((p) => p.isEliminated).toList();

  void initializeGame(List<String> playerNames) {
    _gameEngine = GameEngine.initialize(playerNames);
    _players = _gameEngine!.players;
    _currentPhase = GamePhase.setup;
    _suspicionLevel = 0.0;
    notifyListeners();
  }

  void selectCase() {
    if (_gameEngine == null) return;
    _currentCase = _gameEngine!.selectCase();
    _currentPhase = GamePhase.caseSelection;
    notifyListeners();
  }

  void assignRoles() {
    if (_gameEngine == null) return;
    _players = _gameEngine!.assignRoles();
    _currentPhase = GamePhase.roleDistribution;
    notifyListeners();
  }

  void startEvidencePhase() {
    _currentPhase = GamePhase.evidencePhase;
    _currentEvidence = _gameEngine!.getCurrentEvidence();
    _suspicionLevel = 0.3;
    notifyListeners();
  }

  void nextEvidence() {
    if (_gameEngine == null) return;
    if (_gameEngine!.nextEvidence()) {
      _currentEvidence = _gameEngine!.getCurrentEvidence();
      _suspicionLevel += 0.1;
    } else {
      _currentPhase = GamePhase.discussion;
      _suspicionLevel = 0.7;
    }
    notifyListeners();
  }

  void startDiscussion() {
    _currentPhase = GamePhase.discussion;
    _suspicionLevel = 0.6;
    notifyListeners();
  }

  void startVoting() {
    _currentPhase = GamePhase.voting;
    _votes = {};
    _suspicionLevel = 0.85;
    notifyListeners();
  }

  void castVote(String voterId, String targetId) {
    _votes[voterId] = targetId;
    notifyListeners();
  }

  void processElimination() {
    if (_gameEngine == null) return;
    _suspicionLevel = 1.0;
    final eliminatedPlayer = _gameEngine!.processVotes(_votes);
    if (eliminatedPlayer != null) {
      final index = _players.indexWhere((p) => p.id == eliminatedPlayer.id);
      if (index != -1) _players[index] = eliminatedPlayer;
    }
    final result = _gameEngine!.checkWinCondition();
    if (result != null) {
      _currentPhase = GamePhase.endgame;
    } else {
      _currentRound++;
      _votes = {};
      _gameEngine!.evidenceIndex = 0;
      startEvidencePhase();
    }
    notifyListeners();
  }

  void resetGame() {
    _gameEngine = null; _players = []; _currentCase = null;
    _currentPhase = GamePhase.setup; _currentEvidence = null;
    _currentRound = 0; _currentPlayer = null; _votes = {};
    _suspicionLevel = 0.0;
    notifyListeners();
  }
}