import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DiscussionTimer extends StatefulWidget {
  final int duration;

  const DiscussionTimer({super.key, this.duration = 120});

  @override
  State<DiscussionTimer> createState() => _DiscussionTimerState();
}

class _DiscussionTimerState extends State<DiscussionTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _remainingSeconds = 0;
  bool _isWarning = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _remainingSeconds = (_animation.value * widget.duration).round();
          _isWarning = _remainingSeconds <= 30;
          _isFinished = _remainingSeconds <= 0;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isFinished = true);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFinished
              ? AppTheme.bloodRed
              : _isWarning
                  ? AppTheme.accentRed
                  : AppTheme.goldAccent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _isWarning
                ? AppTheme.accentRed.withOpacity(0.2)
                : AppTheme.goldAccent.withOpacity(0.1),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isFinished ? 'انتهى الوقت!' : 'وقت المناقشة',
            style: TextStyle(
              color: _isFinished
                  ? AppTheme.bloodRedLight
                  : AppTheme.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: _isFinished ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _animation.value,
                  backgroundColor: AppTheme.secondaryDark,
                  color: _isFinished
                      ? AppTheme.bloodRed
                      : _isWarning
                          ? AppTheme.accentRed
                          : AppTheme.goldAccent,
                  strokeWidth: 6,
                ),
                Center(
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _isFinished
                          ? AppTheme.bloodRedLight
                          : _isWarning
                              ? AppTheme.accentRed
                              : AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isFinished)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'يمكنك الانتقال للتصويت',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }
}