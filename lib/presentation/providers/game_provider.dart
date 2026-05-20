import 'package:flutter/material.dart';
import '../../game/engine/game_engine.dart';
import '../../data/models/player_model.dart';
import '../../data/models/case_model.dart';
import '../../data/models/evidence_model.dart';

class GameProvider extends ChangeNotifier {
  GameEngine? _gameEngine;
  List<Player> _players = [];
  GameCase? _currentCase;
  GamePhase _currentPhase = GamePhase.setup;
  Evidence? _currentEvidence;
  int _currentRound = 0;
  Player? _currentPlayer;
  Map<String, String> _votes = {};

  // Getters
  GameEngine? get gameEngine => _gameEngine;
  List<Player> get players => _players;
  GameCase? get currentCase => _currentCase;
  GamePhase get currentPhase => _currentPhase;
  Evidence? get currentEvidence => _currentEvidence;
  int get currentRound => _currentRound;
  Player? get currentPlayer => _currentPlayer;
  Map<String, String> get votes => _votes;
  
  List<Player> get alivePlayers => 
      _players.where((p) => p.isAlive).toList();
  
  List<Player> get eliminatedPlayers => 
      _players.where((p) => p.isEliminated).toList();

  // Initialize game with player names
  void initializeGame(List<String> playerNames) {
    _gameEngine = GameEngine.initialize(playerNames);
    _players = _gameEngine!.players;
    _currentPhase = GamePhase.setup;
    notifyListeners();
  }

  // Select random case
  void selectCase() {
    if (_gameEngine == null) return;
    _currentCase = _gameEngine!.selectCase();
    _currentPhase = GamePhase.caseSelection;
    notifyListeners();
  }

  // Assign roles to players
  void assignRoles() {
    if (_gameEngine == null) return;
    _players = _gameEngine!.assignRoles();
    _currentPhase = GamePhase.roleDistribution;
    notifyListeners();
  }

  // Start evidence phase
  void startEvidencePhase() {
    _currentPhase = GamePhase.evidencePhase;
    _currentEvidence = _gameEngine!.getCurrentEvidence();
    notifyListeners();
  }

  // Next evidence card
  void nextEvidence() {
    if (_gameEngine == null) return;
    if (_gameEngine!.nextEvidence()) {
      _currentEvidence = _gameEngine!.getCurrentEvidence();
    } else {
      _currentPhase = GamePhase.discussion;
    }
    notifyListeners();
  }

  // Start discussion phase
  void startDiscussion() {
    _currentPhase = GamePhase.discussion;
    notifyListeners();
  }

  // Start voting phase
  void startVoting() {
    _currentPhase = GamePhase.voting;
    _votes = {};
    notifyListeners();
  }

  // Cast vote
  void castVote(String voterId, String targetId) {
    _votes[voterId] = targetId;
    notifyListeners();
  }

  // Process votes and eliminate player
  void processElimination() {
    if (_gameEngine == null) return;
    
    final eliminatedPlayer = _gameEngine!.processVotes(_votes);
    if (eliminatedPlayer != null) {
      final index = _players.indexWhere((p) => p.id == eliminatedPlayer.id);
      if (index != -1) {
        _players[index] = eliminatedPlayer;
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
    }
    
    notifyListeners();
  }

  // Handle game results
  void _handleGameResult(GameResult result) {
    switch (result) {
      case GameResult.innocentsWin:
        _currentPhase = GamePhase.endgame;
        break;
      case GameResult.mafiaWin:
        _currentPhase = GamePhase.endgame;
        break;
      case GameResult.juryPhase:
        _currentPhase = GamePhase.juryDeliberation;
        break;
    }
    notifyListeners();
  }

  // Pass device to next player (Pass-and-Play mode)
  void passToNextPlayer() {
    final currentIndex = _players.indexOf(_currentPlayer!);
    final nextIndex = (currentIndex + 1) % _players.length;
    _currentPlayer = _players[nextIndex];
    notifyListeners();
  }

  // Reset game
  void resetGame() {
    _gameEngine = null;
    _players = [];
    _currentCase = null;
    _currentPhase = GamePhase.setup;
    _currentEvidence = null;
    _currentRound = 0;
    _currentPlayer = null;
    _votes = {};
    notifyListeners();
  }
}