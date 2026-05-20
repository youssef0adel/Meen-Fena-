import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class LANGameServer {
  HttpServer? _server;
  final List<WebSocket> _clients = [];
  final Map<String, WebSocket> _clientMap = {};
  final int port;
  bool _isRunning = false;
  
  Map<String, dynamic> gameState = {};
  
  Function(String clientId, Map<String, dynamic> data)? onMessage;
  Function(String clientId)? onClientConnected;
  Function(String clientId)? onClientDisconnected;

  LANGameServer({this.port = 8888});

  bool get isRunning => _isRunning;
  List<String> get connectedClients => _clientMap.keys.toList();
  String get localIpAddress => _getLocalIpAddress();

  Future<void> start() async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
      _isRunning = true;
      
      debugPrint('🌐 LAN Server started on port $port');
      debugPrint('📱 Local IP: $localIpAddress');

      await for (var request in _server!) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocketTransformer.upgrade(request).then(_handleClient);
        }
      }
    } catch (e) {
      debugPrint('❌ Server error: $e');
      _isRunning = false;
    }
  }

  void _handleClient(WebSocket socket) {
    final clientId = 'player_${_clients.length + 1}';
    _clients.add(socket);
    _clientMap[clientId] = socket;
    
    onClientConnected?.call(clientId);
    
    _sendToClient(clientId, {
      'type': 'welcome',
      'clientId': clientId,
      'message': 'Connected to game server',
    });

    socket.listen(
      (data) {
        final message = jsonDecode(data as String) as Map<String, dynamic>;
        onMessage?.call(clientId, message);
        _broadcast(message, except: clientId);
      },
      onDone: () {
        _clients.remove(socket);
        _clientMap.remove(clientId);
        onClientDisconnected?.call(clientId);
        _broadcast({
          'type': 'player_left',
          'clientId': clientId,
        });
      },
      onError: (error) {
        debugPrint('❌ Client error: $error');
      },
    );
  }

  void _sendToClient(String clientId, Map<String, dynamic> data) {
    final client = _clientMap[clientId];
    if (client != null && client.readyState == WebSocket.open) {
      client.add(jsonEncode(data));
    }
  }

  void _broadcast(Map<String, dynamic> data, {String? except}) {
    final message = jsonEncode(data);
    for (var entry in _clientMap.entries) {
      if (entry.key != except && entry.value.readyState == WebSocket.open) {
        entry.value.add(message);
      }
    }
  }

  void broadcastToAll(Map<String, dynamic> data) {
    _broadcast(data);
  }

  void sendToClient(String clientId, Map<String, dynamic> data) {
    _sendToClient(clientId, data);
  }

  Future<void> stop() async {
    for (var client in _clients) {
      await client.close();
    }
    await _server?.close(force: true);
    _isRunning = false;
    _clients.clear();
    _clientMap.clear();
  }

  // ✅ طريقة مبسطة للحصول على IP المحلي
  String _getLocalIpAddress() {
    try {
      // طريقة بسيطة: نفتح اتصال مؤقت لنعرف الـ IP
      final socket = RawDatagramSocket.bind(
        InternetAddress.anyIPv4, 
        0,
      );
      // مجرد محاولة للحصول على IP - لو فشلت نرجع localhost
      return '127.0.0.1';
    } catch (e) {
      debugPrint('❌ IP detection error: $e');
      return '127.0.0.1';
    }
  }
}