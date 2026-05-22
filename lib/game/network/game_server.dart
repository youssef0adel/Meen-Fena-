import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'game_messages.dart';
import '../engine/game_engine.dart';
import '../../data/models/player_model.dart';
import '../../data/models/case_model.dart';

class GameServer {
  HttpServer? _server;
  final Map<String, WebSocket> _clients = {};
  final Map<String, String> _playerNames = {};
  final Map<String, Player> _gamePlayers = {};
  bool _isRunning = false;
  final int port;

  GameEngine? _gameEngine;
  GameCase? _currentCase;

  Function(String playerId, String name)? onPlayerJoined;
  Function(String playerId)? onPlayerLeft;
  Function(Map<String, dynamic>)? onGameUpdate;

  GameServer({this.port = 8888});

  bool get isRunning => _isRunning;
  List<String> get connectedPlayers => _playerNames.keys.toList();
  String get localIp => _getLocalIp();

  Future<void> start() async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      _isRunning = true;
      debugPrint('🌐 Server started on port $port');

      await for (var request in _server!) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocketTransformer.upgrade(request).then(_handleConnection);
        }
      }
    } catch (e) {
      debugPrint('❌ Server error: $e');
      _isRunning = false;
    }
  }

  void _handleConnection(WebSocket socket) {
    final playerId = 'player_${_clients.length + 1}';
    _clients[playerId] = socket;

    socket.listen(
      (data) {
        final message = GameMessage.fromJson(jsonDecode(data as String));
        _processMessage(playerId, message);
      },
      onDone: () {
        _clients.remove(playerId);
        _playerNames.remove(playerId);
        onPlayerLeft?.call(playerId);
        _broadcast(MessageTypes.playerLeft, {'playerId': playerId});
      },
    );
  }

  void _processMessage(String playerId, GameMessage message) {
    switch (message.type) {
      case MessageTypes.join:
        final name = message.data['name'] as String;
        _playerNames[playerId] = name;
        onPlayerJoined?.call(playerId, name);

        _sendTo(playerId, MessageTypes.joined, {'playerId': playerId});
        _broadcast(MessageTypes.playerList, {
          'players': _playerNames.entries
              .map((e) => {'id': e.key, 'name': e.value})
              .toList(),
        });
        break;

      case MessageTypes.voteCast:
        final targetId = message.data['targetId'] as String;
        _processVote(playerId, targetId);
        break;

      case MessageTypes.gameStart:
        startGameForAll();
        break;
    }
  }

  void requestGameStart() {
    if (_playerNames.length < 4) {
      debugPrint('❌ مطلوب 4 لاعبين على الأقل');
      return;
    }
    startGameForAll();
  }

  void startGameForAll() {
    if (_playerNames.length < 4) {
      debugPrint('❌ مطلوب 4 لاعبين على الأقل');
      return;
    }

    _startGame();

    Future.delayed(const Duration(seconds: 1), () {
      startEvidencePhase();
    });
  }

  void _startGame() {
    final playerNames = _playerNames.values.toList();
    if (playerNames.length < 4) return;

    _gameEngine = GameEngine.initialize(playerNames);
    _currentCase = _gameEngine!.selectCase();
    _gameEngine!.assignRoles();

    final players = _gameEngine!.players;
    _gamePlayers.clear();

    int i = 0;
    for (var entry in _clients.entries) {
      if (i < players.length) {
        _gamePlayers[entry.key] = players[i];
        i++;
      }
    }

    _broadcast(MessageTypes.caseDetails, {
      'case': _caseToJson(_currentCase!),
      'suspects': _currentCase!.suspects.map((s) => _characterToJson(s)).toList(),
    });

    for (var entry in _gamePlayers.entries) {
      final player = entry.value;
      final character = _currentCase!.suspects.firstWhere(
        (c) => c.id == player.characterId,
      );

      _sendTo(entry.key, MessageTypes.roleAssign, {
        'playerName': player.name,
        'characterName': character.name,
        'age': character.age,
        'occupation': character.occupation,
        'personality': character.personalityTraits,
        'background': character.background,
        'motivation': character.hiddenMotivation,
        'connection': character.connectionToVictim,
        'isMafia': player.isMafia,
      });
    }

    _broadcast(MessageTypes.gameStart, {
      'message': 'تم بدء اللعبة',
      'totalPlayers': players.length,
    });
  }

  void startEvidencePhase() {
    final evidence = _gameEngine?.getCurrentEvidence();
    if (evidence != null) {
      _broadcast(MessageTypes.evidenceShow, {
        'title': evidence.title,
        'description': evidence.description,
        'hint': evidence.suspiciousHint,
        'round': _gameEngine!.currentRound + 1,
        'totalRounds': _currentCase?.evidenceCards.length ?? 0,
      });
    }
  }

  // ✅ استخدام nextEvidence اللي بترجع bool
  void goToNextEvidence() {
    if (_gameEngine == null) return;
    
    if (_gameEngine!.nextEvidence()) {
      startEvidencePhase();
    } else {
      startDiscussion();
    }
  }

  void startDiscussion() {
    _broadcast(MessageTypes.discussionStart, {
      'message': 'ابدأ المناقشة بين اللاعبين',
      'duration': 120,
    });
  }

  void startVoting() {
    _broadcast(MessageTypes.votingStart, {
      'alivePlayers': _gameEngine!.players
          .where((p) => p.isAlive)
          .map((p) => {'id': p.id, 'name': p.name})
          .toList(),
    });
  }

  void _processVote(String voterId, String targetId) {
    _sendTo(voterId, MessageTypes.voteResult, {
      'votedFor': targetId,
      'message': 'تم تسجيل تصويتك',
    });

    onGameUpdate?.call({
      'type': 'vote',
      'voterId': voterId,
      'target': targetId,
    });
  }

  void processElimination(Map<String, String> votes) {
    final eliminated = _gameEngine?.processVotes(votes);
    if (eliminated != null) {
      _broadcast(MessageTypes.eliminationResult, {
        'eliminatedId': eliminated.id,
        'eliminatedName': eliminated.name,
        'wasMafia': eliminated.isMafia,
        'remainingPlayers': _gameEngine!.players
            .where((p) => p.isAlive)
            .map((p) => p.name)
            .toList(),
      });

      final result = _gameEngine!.checkWinCondition();
      if (result != null) {
        if (result == GameResult.juryPhase) {
          _startJuryPhase();
        } else {
          _endGame(result);
        }
      } else {
        _gameEngine!.currentRound++;
        _gameEngine!.evidenceIndex = 0;
        Future.delayed(const Duration(seconds: 2), () {
          startEvidencePhase();
        });
      }
    }
  }

  void _startJuryPhase() {
    final alivePlayers = _gameEngine!.players.where((p) => p.isAlive).toList();
    final eliminatedPlayers = _gameEngine!.players.where((p) => p.isEliminated).toList();

    _broadcast(MessageTypes.juryPhase, {
      'message': 'تم تفعيل هيئة المحلفين',
      'suspects': alivePlayers.map((p) => p.name).toList(),
      'jurors': eliminatedPlayers.map((p) => p.name).toList(),
    });
  }

  void _endGame(GameResult result) {
    String message;
    bool innocentsWin;

    switch (result) {
      case GameResult.innocentsWin:
        message = '🎉 الأبرياء انتصروا!';
        innocentsWin = true;
        break;
      case GameResult.mafiaWin:
        message = '💀 المافيا انتصرت!';
        innocentsWin = false;
        break;
      default:
        message = 'انتهت اللعبة';
        innocentsWin = false;
    }

    _broadcast(MessageTypes.gameEnd, {
      'message': message,
      'innocentsWin': innocentsWin,
    });
  }

  void _sendTo(String playerId, String type, Map<String, dynamic> data) {
    final client = _clients[playerId];
    if (client != null && client.readyState == WebSocket.open) {
      client.add(jsonEncode(GameMessage(type: type, data: data).toJson()));
    }
  }

  void _broadcast(String type, Map<String, dynamic> data) {
    final message = jsonEncode(GameMessage(type: type, data: data).toJson());
    for (var client in _clients.values) {
      if (client.readyState == WebSocket.open) {
        client.add(message);
      }
    }
  }

  Map<String, dynamic> _caseToJson(GameCase gameCase) {
    return {
      'title': gameCase.title,
      'description': gameCase.description,
      'location': gameCase.location,
      'time': gameCase.timeOfCrime,
      'victim': gameCase.victimName,
      'victimProfile': gameCase.victimProfile,
    };
  }

  Map<String, dynamic> _characterToJson(dynamic character) {
    return {
      'name': character.name,
      'age': character.age,
      'occupation': character.occupation,
      'personality': character.personalityTraits,
      'background': character.background,
    };
  }

  String _getLocalIp() {
    try {
      return '192.168.1.100';
    } catch (e) {
      debugPrint('❌ IP error: $e');
      return '127.0.0.1';
    }
  }

  Future<void> stop() async {
    for (var client in _clients.values) {
      await client.close();
    }
    await _server?.close();
    _isRunning = false;
    _clients.clear();
    _playerNames.clear();
    _gamePlayers.clear();
  }
}