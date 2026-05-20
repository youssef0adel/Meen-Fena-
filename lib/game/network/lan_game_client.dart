import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class LANGameClient {
  WebSocket? _socket;
  String? _clientId;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  
  // Callbacks
  Function(Map<String, dynamic> data)? onMessage;
  Function()? onConnected;
  Function()? onDisconnected;
  Function(String error)? onError;

  bool get isConnected => _isConnected;
  String? get clientId => _clientId;

  Future<void> connect(String host, {int port = 8888}) async {
    try {
      _socket = await WebSocket.connect('ws://$host:$port');
      _isConnected = true;
      onConnected?.call();

      _socket!.listen(
        (data) {
          final message = jsonDecode(data as String) as Map<String, dynamic>;
          
          if (message['type'] == 'welcome') {
            _clientId = message['clientId'] as String;
          }
          
          onMessage?.call(message);
        },
        onDone: () {
          _isConnected = false;
          onDisconnected?.call();
          _startReconnect(host, port);
        },
        onError: (error) {
          onError?.call(error.toString());
        },
      );
    } catch (e) {
      onError?.call(e.toString());
      _startReconnect(host, port);
    }
  }

  void send(Map<String, dynamic> data) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(jsonEncode(data));
    }
  }

  void _startReconnect(String host, int port) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isConnected) {
        connect(host, port: port);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _socket?.close();
    _isConnected = false;
    _clientId = null;
  }

  // Network discovery
  static Future<List<String>> discoverServers({int port = 8888}) async {
    final servers = <String>[];
    // Simple subnet scan (192.168.1.x)
    for (int i = 1; i < 255; i++) {
      try {
        final socket = await Socket.connect(
          '192.168.1.$i',
          port,
          timeout: const Duration(milliseconds: 100),
        );
        servers.add('192.168.1.$i');
        socket.destroy();
      } catch (e) {
        // Server not found at this IP
      }
    }
    return servers;
  }
}