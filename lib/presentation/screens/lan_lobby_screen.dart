import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../game/network/game_server.dart';
import '../../game/network/game_client.dart';
import '../../game/network/game_messages.dart';
import '../providers/game_provider.dart';

class LANLobbyScreen extends StatefulWidget {
  final bool isHost;
  final String? hostIp;

  const LANLobbyScreen({super.key, required this.isHost, this.hostIp});

  @override
  State<LANLobbyScreen> createState() => _LANLobbyScreenState();
}

class _LANLobbyScreenState extends State<LANLobbyScreen> {
  GameServer? _server;
  GameClient? _client;
  final _nameController = TextEditingController();
  final _ipController = TextEditingController(text: '192.168.1.');
  String _status = 'جاري الاتصال...';
  List<Map<String, String>> _players = [];
  bool _gameStarted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isHost) {
      _startServer();
    }
  }

  Future<void> _startServer() async {
    setState(() => _status = 'جاري تشغيل السيرفر...');
    _server = GameServer();
    _server!.onPlayerJoined = (id, name) {
      setState(() {
        _players.add({'id': id, 'name': name});
        _status = 'انضم $name';
      });
    };
    _server!.onPlayerLeft = (id) {
      setState(() {
        _players.removeWhere((p) => p['id'] == id);
        _status = 'غادر لاعب';
      });
    };
    await _server!.start();
    setState(() {
      _status = 'السيرفر شغال - في انتظار اللاعبين';
    });
  }

  void _joinGame() {
    final name = _nameController.text.trim();
    final ip = _ipController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل اسمك أولاً')),
      );
      return;
    }

    if (ip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل IP السيرفر')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'جاري الاتصال...';
    });

    _client = GameClient();
    _client!.onConnected = () {
      setState(() {
        _isLoading = false;
        _status = 'متصل! في انتظار بدء اللعبة';
      });
    };
    _client!.onDisconnected = () {
      setState(() {
        _isLoading = false;
        _status = 'انقطع الاتصال';
      });
    };
    _client!.onError = (error) {
      setState(() {
        _isLoading = false;
        _status = 'خطأ: $error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الاتصال: $error')),
      );
    };
    _client!.onMessage = (type, data) {
      _handleMessage(type, data);
    };

    _client!.connect(ip, playerName: name);
  }

  void _handleMessage(String type, Map<String, dynamic> data) {
    switch (type) {
      case MessageTypes.playerList:
        final list = data['players'] as List;
        setState(() {
          _players = list
              .map((p) => {'id': p['id'] as String, 'name': p['name'] as String})
              .toList();
        });
        break;

      case MessageTypes.caseDetails:
        // استقبال تفاصيل القضية
        _handleGameStart(data);
        break;

      case MessageTypes.roleAssign:
        // استقبال الدور
        _handleRoleAssign(data);
        break;

      case MessageTypes.evidenceShow:
        // استقبال الدليل
        break;

      case MessageTypes.votingStart:
        // بدء التصويت
        break;

      case MessageTypes.eliminationResult:
        // نتيجة الإقصاء
        break;

      case MessageTypes.gameEnd:
        // نهاية اللعبة
        break;
    }
  }

  void _handleGameStart(Map<String, dynamic> data) {
    setState(() => _gameStarted = true);
    // هنا يتم تهيئة اللعبة من بيانات السيرفر
    final gp = context.read<GameProvider>();
    // سيتم استكمالها حسب الحاجة
  }

  void _handleRoleAssign(Map<String, dynamic> data) {
    // عرض الدور للاعب
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(
          data['characterName'] ?? '',
          style: const TextStyle(color: AppTheme.goldAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('العمر: ${data['age']}', style: const TextStyle(color: AppTheme.textSecondary)),
            Text('المهنة: ${data['occupation']}', style: const TextStyle(color: AppTheme.textSecondary)),
            Text('الخلفية: ${data['background']}', style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (data['isMafia'] as bool)
                    ? AppTheme.mafiaRed.withOpacity(0.2)
                    : AppTheme.innocentBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                (data['isMafia'] as bool) ? 'مافيا 🔪' : 'بريء 🛡️',
                style: TextStyle(
                  color: (data['isMafia'] as bool) ? AppTheme.mafiaRed : AppTheme.innocentBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _startGameAsHost() {
    if (_players.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مطلوب 4 لاعبين على الأقل')),
      );
      return;
    }
    _server?.startGameForAll();
    setState(() => _gameStarted = true);
  }

  @override
  void dispose() {
    _server?.stop();
    _client?.disconnect();
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(widget.isHost ? '🎮 استضافة لعبة' : '🔗 انضمام للعبة'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // بطاقة الحالة
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.goldAccent.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.bloodRed.withOpacity(0.1),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    widget.isHost ? Icons.wifi : Icons.wifi_find,
                    color: AppTheme.goldAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  if (widget.isHost && _server != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.bloodRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'IP: ${_server!.localIp}',
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // إدخال الاسم والـ IP (لغير المستضيف)
            if (!widget.isHost && _client == null) ...[
              TextField(
                controller: _nameController,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'أدخل اسمك',
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.person, color: AppTheme.goldAccent),
                  filled: true,
                  fillColor: AppTheme.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.bloodRed.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ipController,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'IP السيرفر (مثال: 192.168.1.5)',
                  hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.computer, color: AppTheme.goldAccent),
                  filled: true,
                  fillColor: AppTheme.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.bloodRed.withOpacity(0.3)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _joinGame,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.login),
                  label: Text(_isLoading ? 'جاري الاتصال...' : 'انضم للعبة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bloodRed,
                    foregroundColor: AppTheme.goldAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // قائمة اللاعبين
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, color: AppTheme.goldAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'اللاعبون (${_players.length})',
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_players.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'في انتظار انضمام اللاعبين...',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ..._players.map((player) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.bloodRed.withOpacity(0.3),
                                ),
                                child: const Icon(Icons.person, color: AppTheme.goldAccent, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                player['name'] ?? '',
                                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                              ),
                              const Spacer(),
                              Icon(Icons.check_circle, color: AppTheme.goldAccent.withOpacity(0.5), size: 18),
                            ],
                          ),
                        )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // زر البدء (للمستضيف)
            if (widget.isHost)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _players.length >= 3 ? _startGameAsHost : null,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(
                    _players.length >= 3 ? 'ابدأ اللعبة' : 'بانتظار ${4 - _players.length} لاعبين آخرين',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _players.length >= 3 ? AppTheme.bloodRed : AppTheme.cardDark,
                    foregroundColor: _players.length >= 3 ? AppTheme.goldAccent : AppTheme.textMuted,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // تعليمات
            if (widget.isHost)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'تأكد من اتصال جميع الأجهزة بنفس شبكة WiFi',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}