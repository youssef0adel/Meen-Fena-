import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bloodDripAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _bloodDripAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/menu');
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              AppTheme.cardDark,
              AppTheme.primaryDark,
              AppTheme.primaryDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            // تأثير الدم النازف
            AnimatedBuilder(
              animation: _bloodDripAnimation,
              builder: (context, child) {
                return Positioned(
                  top: _bloodDripAnimation.value,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: _BloodDripPainter(),
                  ),
                );
              },
            ),
            
            // المحتوى الرئيسي
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // دائرة التحقيق
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.goldAccent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.bloodRed.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.search,
                          size: 60,
                          color: AppTheme.goldAccent,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // اسم اللعبة - كبير ومميز
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            AppTheme.goldAccent,
                            AppTheme.bloodRedLight,
                            AppTheme.goldDark,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          'مين فينا؟',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 6,
                            shadows: [
                              Shadow(
                                color: AppTheme.bloodRed,
                                blurRadius: 20,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // خط زخرفي
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 2,
                            color: AppTheme.goldAccent,
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.diamond,
                            color: AppTheme.bloodRedLight,
                            size: 12,
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 40,
                            height: 2,
                            color: AppTheme.goldAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // العنوان الإنجليزي
                      Text(
                        'WHO AMONG US?',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                          letterSpacing: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // شعار الجريمة
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.bloodRed.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🔍 لعبة استنتاج • غموض • تحقيق',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      // مؤشر التحميل
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: AppTheme.bloodRedLight,
                          strokeWidth: 2,
                          backgroundColor: AppTheme.cardDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ رسام تأثير الدم
class _BloodDripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.bloodRed.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.3, 80, size.width * 0.5, 40);
    path.quadraticBezierTo(size.width * 0.7, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // قطرات دم
    final dripPaint = Paint()
      ..color = AppTheme.bloodRed.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, 120), 8, dripPaint);
    canvas.drawCircle(Offset(size.width * 0.5, 90), 5, dripPaint);
    canvas.drawCircle(Offset(size.width * 0.8, 140), 10, dripPaint);
    canvas.drawCircle(Offset(size.width * 0.35, 160), 4, dripPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}