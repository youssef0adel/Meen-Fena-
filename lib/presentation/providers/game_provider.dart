import 'package:flutter/material.dart';
import '../../game/engine/game_engine.dart';
import '../../data/models/player_model.dart';
import '../../data/models/case_model.dart';
import '../../data/models/evidence_model.dart';

enum GamePhase {
  setup,
  caseSelection,
  roleDistribution,
  evidencePhase,
  discussion,
  voting,
  elimination,
  endgame,
  juryDeliberation,
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
  
  // ✅ تأثيرات الشك
  double _suspicionLevel = 0.0;
  bool _isPhaseTransitioning = false;
  String _lastAction = '';
  List<String> _suspicionLog = [];

  // Getters
  GameEngine? get gameEngine => _gameEngine;
  List<Player> get players => _players;
  GameCase? get currentCase => _currentCase;
  GamePhase get currentPhase => _currentPhase;
  Evidence? get currentEvidence => _currentEvidence;
  int get currentRound => _currentRound;
  Player? get currentPlayer => _currentPlayer;
  Map<String, String> get votes => _votes;
  double get suspicionLevel => _suspicionLevel;
  bool get isPhaseTransitioning => _isPhaseTransitioning;
  String get lastAction => _lastAction;
  List<String> get suspicionLog => _suspicionLog;
  
  List<Player> get alivePlayers => 
      _players.where((p) => p.isAlive).toList();
  
  List<Player> get eliminatedPlayers => 
      _players.where((p) => p.isEliminated).toList();

  void initializeGame(List<String> playerNames) {
    _gameEngine = GameEngine.initialize(playerNames);
    _players = _gameEngine!.players;
    _currentPhase = GamePhase.setup;
    _suspicionLevel = 0.0;
    _suspicionLog = [];
    _addToLog('🕵️ تم بدء لعبة جديدة مع ${playerNames.length} لاعبين');
    notifyListeners();
  }

  void selectCase() {
    if (_gameEngine == null) return;
    _currentCase = _gameEngine!.selectCase();
    _currentPhase = GamePhase.caseSelection;
    _addToLog('📋 تم اختيار قضية: ${_currentCase?.title ?? ""}');
    _increaseSuspicion(0.1);
    notifyListeners();
  }

  void assignRoles() {
    if (_gameEngine == null) return;
    _players = _gameEngine!.assignRoles();
    _currentPhase = GamePhase.roleDistribution;
    _addToLog('🎭 تم توزيع الشخصيات... من هو المافيا؟');
    _increaseSuspicion(0.2);
    notifyListeners();
  }

  void startEvidencePhase() {
    _setPhaseTransition(true);
    _currentPhase = GamePhase.evidencePhase;
    _currentEvidence = _gameEngine!.getCurrentEvidence();
    _addToLog('🔍 ظهور دليل جديد...');
    _increaseSuspicion(0.15);
    
    Future.delayed(const Duration(milliseconds: 600), () {
      _setPhaseTransition(false);
      notifyListeners();
    });
    notifyListeners();
  }

  void nextEvidence() {
    if (_gameEngine == null) return;
    _setPhaseTransition(true);
    
    if (_gameEngine!.nextEvidence()) {
      _currentEvidence = _gameEngine!.getCurrentEvidence();
      _addToLog('🃏 دليل إضافي يظهر...');
      _increaseSuspicion(0.1);
    } else {
      _currentPhase = GamePhase.discussion;
      _addToLog('💬 بدء مرحلة الاتهامات والشك');
      _suspicionLevel = 0.7;
    }
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _setPhaseTransition(false);
      notifyListeners();
    });
    notifyListeners();
  }

  void startDiscussion() {
    _setPhaseTransition(true);
    _currentPhase = GamePhase.discussion;
    _addToLog('🗣️ تناقشوا... لكن احذروا الكاذبين');
    _suspicionLevel = 0.6;
    
    Future.delayed(const Duration(milliseconds: 400), () {
      _setPhaseTransition(false);
      notifyListeners();
    });
    notifyListeners();
  }

  void startVoting() {
    _setPhaseTransition(true);
    _currentPhase = GamePhase.voting;
    _votes = {};
    _addToLog('🗳️ وقت التصويت... اختاروا بحكمة');
    _suspicionLevel = 0.85;
    
    Future.delayed(const Duration(milliseconds: 400), () {
      _setPhaseTransition(false);
      notifyListeners();
    });
    notifyListeners();
  }

  void castVote(String voterId, String targetId) {
    _votes[voterId] = targetId;
    _addToLog('👈 تم الإدلاء بصوت');
    _increaseSuspicion(0.05);
    notifyListeners();
  }

  void processElimination() {
    if (_gameEngine == null) return;
    _setPhaseTransition(true);
    _suspicionLevel = 1.0;
    
    final eliminatedPlayer = _gameEngine!.processVotes(_votes);
    if (eliminatedPlayer != null) {
      final index = _players.indexWhere((p) => p.id == eliminatedPlayer.id);
      if (index != -1) {
        _players[index] = eliminatedPlayer;
        _addToLog('💀 تم إقصاء ${eliminatedPlayer.name}!');
      }
    }

    final result = _gameEngine!.checkWinCondition();
    if (result != null) {
      _handleGameResult(result);
    } else {
      _currentRound++;
      _currentPhase = GamePhase.evidencePhase;
      _gameEngine!.nextEvidence();
      _currentEvidence = _gameEngine!.getCurrentEvidence();
      _suspicionLevel = 0.3;
    }
    
    Future.delayed(const Duration(milliseconds: 800), () {
      _setPhaseTransition(false);
      notifyListeners();
    });
    notifyListeners();
  }

  void _handleGameResult(GameResult result) {
    switch (result) {
      case GameResult.innocentsWin:
        _currentPhase = GamePhase.endgame;
        _addToLog('🎉 الأبرياء انتصروا! تم القبض على كل المافيا');
        break;
      case GameResult.mafiaWin:
        _currentPhase = GamePhase.endgame;
        _addToLog('💀 المافيا انتصرت... سقط الأبرياء');
        break;
      case GameResult.juryPhase:
        _currentPhase = GamePhase.juryDeliberation;
        _addToLog('⚖️ هيئة المحلفين تجتمع للقرار النهائي');
        break;
    }
    notifyListeners();
  }

  void _increaseSuspicion(double amount) {
    _suspicionLevel = (_suspicionLevel + amount).clamp(0.0, 1.0);
  }

  void _setPhaseTransition(bool value) {
    _isPhaseTransitioning = value;
    notifyListeners();
  }

  void _addToLog(String message) {
    _lastAction = message;
    _suspicionLog.insert(0, message);
    if (_suspicionLog.length > 20) {
      _suspicionLog.removeLast();
    }
  }

  void resetGame() {
    _gameEngine = null;
    _players = [];
    _currentCase = null;
    _currentPhase = GamePhase.setup;
    _currentEvidence = null;
    _currentRound = 0;
    _currentPlayer = null;
    _votes = {};
    _suspicionLevel = 0.0;
    _suspicionLog = [];
    _lastAction = '';
    notifyListeners();
  }
}