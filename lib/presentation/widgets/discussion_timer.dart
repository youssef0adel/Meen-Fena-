import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DiscussionTimer extends StatefulWidget {
  final int duration; // in seconds

  const DiscussionTimer({super.key, required this.duration});

  @override
  State<DiscussionTimer> createState() => _DiscussionTimerState();
}

class _DiscussionTimerState extends State<DiscussionTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _remainingSeconds = 0;
  bool _isWarning = false;

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
        });
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
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
          color: _isWarning ? AppTheme.accentRed : AppTheme.goldAccent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'DISCUSSION TIME',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: _animation.value,
                      backgroundColor: AppTheme.secondaryDark,
                      color: _isWarning
                          ? AppTheme.accentRed
                          : AppTheme.goldAccent,
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _isWarning
                              ? AppTheme.accentRed
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}