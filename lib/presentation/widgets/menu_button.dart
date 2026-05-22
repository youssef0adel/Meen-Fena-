import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  // ✅ دالة منفصلة للتحويل
  Matrix4 _getArrowTransform() {
    if (_isPressed) {
      return Matrix4.identity()..translate(4.0, 0.0);
    }
    return Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.cardDark,
                  AppTheme.cardLight,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isPressed
                    ? AppTheme.goldAccent.withOpacity(0.5)
                    : AppTheme.bloodRed.withOpacity(0.2),
                width: _isPressed ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isPressed
                      ? AppTheme.goldAccent.withOpacity(0.1)
                      : AppTheme.bloodRed.withOpacity(0.05),
                  blurRadius: _isPressed ? 20 : 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // أيقونة الزر
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.bloodRed.withOpacity(0.3),
                        AppTheme.bloodRed.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isPressed
                          ? AppTheme.goldAccent.withOpacity(0.5)
                          : AppTheme.bloodRedLight.withOpacity(0.3),
                      width: _isPressed ? 1.5 : 1,
                    ),
                    boxShadow: _isPressed
                        ? [
                            BoxShadow(
                              color: AppTheme.goldAccent.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.goldAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: _isPressed
                              ? AppTheme.goldAccent
                              : AppTheme.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ سهم التوجيه - استخدام الدالة المنفصلة
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: _getArrowTransform(),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: _isPressed
                        ? AppTheme.goldAccent
                        : AppTheme.goldAccent.withOpacity(0.3),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}