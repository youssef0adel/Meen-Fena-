import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const MenuButton({super.key, required this.icon, required this.label, required this.description, required this.onTap});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _isPressed = false;

  Matrix4 _getTransform() {
    if (_isPressed) return Matrix4.identity()..scale(0.97);
    return Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) { setState(() => _isPressed = false); widget.onTap(); },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(18),
          transform: _getTransform(),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.cardDark, AppTheme.cardLight]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.bloodRed.withOpacity(0.2)),
            boxShadow: [BoxShadow(color: AppTheme.bloodRed.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Row(children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.bloodRed.withOpacity(0.3), AppTheme.bloodRed.withOpacity(0.1)]), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.bloodRedLight.withOpacity(0.3))), child: Icon(widget.icon, color: AppTheme.goldAccent, size: 24)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 17, fontWeight: FontWeight.bold)), const SizedBox(height: 3), Text(widget.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12))])),
            Icon(Icons.arrow_forward_ios, color: AppTheme.goldAccent.withOpacity(0.3), size: 16),
          ]),
        ),
      ),
    );
  }
}