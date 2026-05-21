import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/evidence_model.dart';

class EvidenceCard extends StatefulWidget {
  final Evidence evidence;
  const EvidenceCard({super.key, required this.evidence});

  @override
  State<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends State<EvidenceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _flipCard();
    });
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
      if (_isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // ✅ لما الكارت بيتقلب 180 درجة، النص الداخلي بيتقلب معاه
          // فبنضرب في -1 عشان النص يفضل مقروء
          final angle = _animation.value * 3.14159;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: _animation.value < 0.5
                ? _buildFront()
                : Transform(
                    // ✅ نقلب النص عكس دوران الكارت عشان يبقى مقروء
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.cardDark, AppTheme.bloodRed.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.goldAccent.withOpacity(0.5)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 60, color: AppTheme.goldAccent),
            SizedBox(height: 16),
            Text(
              'دليل جديد',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'اضغط للكشف',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentRed, width: 2),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الدليل
            Text(
              widget.evidence.title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(width: 30, height: 2, color: AppTheme.accentRed),
            const SizedBox(height: 12),

            // وصف الدليل
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.evidence.description,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.8,
                  ),
                ),
              ),
            ),

            // تلميح
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.suspicionAmber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.suspicionAmber.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber,
                      color: AppTheme.suspicionAmber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.evidence.suspiciousHint,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppTheme.suspicionAmber,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}