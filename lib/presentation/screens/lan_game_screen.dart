import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../game/network/lan_game_server.dart';
import '../../game/network/lan_game_client.dart';
import '../providers/game_provider.dart';

class LANGameScreen extends StatefulWidget {
  const LANGameScreen({super.key});

  @override
  State<LANGameScreen> createState() => _LANGameScreenState();
}

class _LANGameScreenState extends State<LANGameScreen> {
  LANGameServer? _server;
  LANGameClient? _client;
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  String _status = 'Not connected';
  bool _isHost = false;
  List<String> _players = [];
  List<String> _discoveredServers = [];

  @override
  void dispose() {
    _server?.stop();
    _client?.disconnect();
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _hostGame() async {
    setState(() {
      _isHost = true;
      _status = 'Starting server...';
    });

    _server = LANGameServer();
    _server!.onClientConnected = (clientId) {
      setState(() {
        _players.add(clientId);
        _status = 'Player $clientId joined';
      });
    };

    _server!.onClientDisconnected = (clientId) {
      setState(() {
        _players.remove(clientId);
        _status = 'Player $clientId left';
      });
    };

    _server!.onMessage = (clientId, data) {
      _handleGameMessage(clientId, data);
    };

    await _server!.start();
    setState(() {
      _status = 'Server running on ${_server!.localIpAddress}:${_server!.port}';
    });
  }

  Future<void> _joinGame() async {
    if (_ipController.text.isEmpty) return;

    setState(() {
      _status = 'Connecting...';
    });

    _client = LANGameClient();
    _client!.onConnected = () {
      setState(() {
        _status = 'Connected!';
      });
      _client!.send({
        'type': 'join',
        'name': _nameController.text,
      });
    };

    _client!.onDisconnected = () {
      setState(() {
        _status = 'Disconnected';
      });
    };

    _client!.onMessage = (data) {
      _handleServerMessage(data);
    };

    _client!.onError = (error) {
      setState(() {
        _status = 'Error: $error';
      });
    };

    await _client!.connect(_ipController.text);
  }

  void _handleGameMessage(String clientId, Map<String, dynamic> data) {
    // Handle game-specific messages
    switch (data['type']) {
      case 'vote':
        // Process vote
        break;
      case 'ready':
        // Player ready
        break;
      // ... other game actions
    }
  }

  void _handleServerMessage(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'game_start':
        Navigator.pushNamed(context, '/game');
        break;
      case 'player_list':
        setState(() {
          _players = List<String>.from(data['players'] as List);
        });
        break;
    }
  }

  Future<void> _scanNetwork() async {
    setState(() {
      _status = 'Scanning network...';
      _discoveredServers = [];
    });

    final servers = await LANGameClient.discoverServers();
    setState(() {
      _discoveredServers = servers;
      _status = 'Found ${servers.length} server(s)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAN Multiplayer'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.wifi, color: AppTheme.goldAccent, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      _status,
                      style: const TextStyle(color: AppTheme.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              if (!_isHost && _client == null) ...[
                // Join Game Section
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'Server IP Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.computer),
                    hintText: '192.168.1.x',
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _joinGame,
                  icon: const Icon(Icons.login),
                  label: const Text('JOIN GAME'),
                ),
              ],
              
              const SizedBox(height: 20),
              const Divider(color: AppTheme.textSecondary),
              const SizedBox(height: 20),
              
              // Host Game Button
              if (!_isHost)
                ElevatedButton.icon(
                  onPressed: _hostGame,
                  icon: const Icon(Icons.add),
                  label: const Text('HOST NEW GAME'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldAccent,
                    foregroundColor: AppTheme.primaryDark,
                  ),
                ),
              
              if (_isHost) ...[
                const Text(
                  'Players in lobby:',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _players.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.person, color: AppTheme.accentRed),
                        title: Text(
                          _players[index],
                          style: const TextStyle(color: AppTheme.textPrimary),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _server?.broadcastToAll({'type': 'game_start'});
                    Navigator.pushNamed(context, '/game');
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('START GAME'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                  ),
                ),
              ],
              
              // Network scan
              ElevatedButton.icon(
                onPressed: _scanNetwork,
                icon: const Icon(Icons.search),
                label: const Text('SCAN NETWORK'),
              ),
              if (_discoveredServers.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  'Found Servers:',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                ..._discoveredServers.map((server) => ListTile(
                  title: Text(server, style: const TextStyle(color: AppTheme.textSecondary)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _ipController.text = server;
                      _joinGame();
                    },
                    child: const Text('Join'),
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}