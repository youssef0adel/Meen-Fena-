import 'package:flutter/material.dart';
import '../../game/engine/game_engine.dart';
import '../../game/engine/jury_system.dart';
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
  JurySystem? _jurySystem;
  List<Player> _finalSuspects = [];
  bool _isJuryPhase = false;

  GameEngine? get gameEngine => _gameEngine;
  List<Player> get players => _players;
  GameCase? get currentCase => _currentCase;
  GamePhase get currentPhase => _currentPhase;
  Evidence? get currentEvidence => _currentEvidence;
  int get currentRound => _currentRound;
  Player? get currentPlayer => _currentPlayer;
  Map<String, String> get votes => _votes;
  double get suspicionLevel => _suspicionLevel;
  JurySystem? get jurySystem => _jurySystem;
  bool get isJuryPhase => _isJuryPhase;
  List<Player> get finalSuspects => _finalSuspects;
  List<Player> get alivePlayers => _players.where((p) => p.isAlive).toList();
  // ✅ المحلفين = اللاعبين اللي خرجوا
  List<Player> get eliminatedPlayersList => _players.where((p) => p.isEliminated).toList();

  // أضف المتغير ده في GameProvider
  int _discussionTime = 120;
  int get discussionTime => _discussionTime;

  void setDiscussionTime(int seconds) {
    _discussionTime = seconds;
    notifyListeners();
  }

  void initializeGame(List<String> playerNames) {
    _gameEngine = GameEngine.initialize(playerNames);
    _players = _gameEngine!.players;
    _currentPhase = GamePhase.setup;
    _currentRound = 0;
    _suspicionLevel = 0.0;
    _isJuryPhase = false;
    _finalSuspects = [];
    notifyListeners();
  }

  void selectCase() {
    if (_gameEngine == null) return;
    _currentCase = _gameEngine!.selectCase();
    notifyListeners();
  }

  void assignRoles() {
    if (_gameEngine == null) return;
    _players = _gameEngine!.assignRoles();
    notifyListeners();
  }

  void startEvidencePhase() {
    if (_gameEngine == null) return;
    _currentPhase = GamePhase.evidencePhase;
    _currentEvidence = _gameEngine!.getEvidenceForRound(_currentRound);
    _suspicionLevel = 0.3 + (_currentRound * 0.1);
    notifyListeners();
  }

  void goToDiscussion() {
    _currentPhase = GamePhase.discussion;
    _suspicionLevel = 0.6;
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

    final eliminatedPlayer = _gameEngine!.processVotes(_votes);
    if (eliminatedPlayer != null) {
      final index = _players.indexWhere((p) => p.id == eliminatedPlayer.id);
      if (index != -1) _players[index] = eliminatedPlayer;
    }

    final result = _gameEngine!.checkWinCondition();
    if (result != null) {
      if (result == GameResult.juryPhase) {
        // ✅ تفعيل هيئة المحلفين
        _startJuryPhase();
      } else {
        _currentPhase = GamePhase.endgame;
      }
    } else {
      // ✅ انتقال للدليل التالي
      _gameEngine!.advanceToNextEvidence();
      _currentRound++;
      _votes = {};
      _currentEvidence = _gameEngine!.getEvidenceForRound(_currentRound);
      if (_currentEvidence == null) {
        _currentPhase = GamePhase.discussion;
      } else {
        _currentPhase = GamePhase.evidencePhase;
      }
      _suspicionLevel = 0.3;
    }
    notifyListeners();
  }

  // ✅ بدء مرحلة المحلفين
void _startJuryPhase() {
    _isJuryPhase = true;
    _currentPhase = GamePhase.juryDeliberation;
    
    // ✅ المشتبه بهم = اللاعبين الأحياء (2 لاعبين)
    _finalSuspects = _players.where((p) => p.isAlive).toList();
    
    // ✅ المحلفين = اللاعبين اللي تم إقصاؤهم
    final jury = _players.where((p) => p.isEliminated).toList();
    
    // ✅ لو مفيش محلفين (حالة نادرة)، نخلي اللاعبين الأحياء يصوتوا
    if (jury.isEmpty) {
      _finalSuspects = _players.where((p) => p.isAlive).toList();
      _jurySystem = JurySystem(
        eliminatedPlayers: _finalSuspects, // يصوتوا على بعض
        finalSuspects: _finalSuspects,
      );
    } else {
      _jurySystem = JurySystem(
        eliminatedPlayers: jury,
        finalSuspects: _finalSuspects,
      );
    }
    
    _votes = {};
    notifyListeners();
  }
  void castJuryVote(String voterId, String targetId) {
    _votes[voterId] = targetId;
    notifyListeners();
  }

  void processJuryVotes() {
    if (_jurySystem == null) return;
    final voteCount = _jurySystem!.conductJuryVote(_votes);
    final winner = _jurySystem!.determineWinner(voteCount);
    if (winner != null) {
      _currentPhase = GamePhase.endgame;
      _currentPlayer = winner;
    }
    notifyListeners();
  }

  void resetGame() {
    _gameEngine = null; _players = []; _currentCase = null;
    _currentPhase = GamePhase.setup; _currentEvidence = null;
    _currentRound = 0; _currentPlayer = null; _votes = {};
    _suspicionLevel = 0.0; _jurySystem = null;
    _isJuryPhase = false; _finalSuspects = [];
    notifyListeners();
  }
}