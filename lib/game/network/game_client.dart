import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'game_messages.dart';

class GameClient {
  WebSocket? _socket;
  String? _playerId;
  String? _playerName;
  bool _isConnected = false;

  Function()? onConnected;
  Function()? onDisconnected;
  Function(String error)? onError;
  Function(String type, Map<String, dynamic> data)? onMessage;

  bool get isConnected => _isConnected;
  String? get playerId => _playerId;

  Future<void> connect(String host, {int port = 8888, required String playerName}) async {
    try {
      _playerName = playerName;
      _socket = await WebSocket.connect('ws://$host:$port');
      _isConnected = true;
      onConnected?.call();

      _socket!.listen(
        (data) {
          final message = GameMessage.fromJson(jsonDecode(data as String));
          
          if (message.type == MessageTypes.joined) {
            _playerId = message.data['playerId'] as String;
          }
          
          onMessage?.call(message.type, message.data);
        },
        onDone: () {
          _isConnected = false;
          onDisconnected?.call();
        },
        onError: (error) {
          onError?.call(error.toString());
        },
      );

      // إرسال طلب الانضمام
      send(MessageTypes.join, {'name': playerName});
    } catch (e) {
      onError?.call(e.toString());
    }
  }

  void send(String type, Map<String, dynamic> data) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(jsonEncode(GameMessage(type: type, data: data).toJson()));
    }
  }

  void sendVote(String targetId) {
    send(MessageTypes.voteCast, {'targetId': targetId});
  }

  void requestGameStart() {
    send(MessageTypes.gameStart, {});
  }

  Future<void> disconnect() async {
    await _socket?.close();
    _isConnected = false;
    _playerId = null;
  }
}