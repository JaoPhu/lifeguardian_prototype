import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller, curve: Curves.easeInOut));
    
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // TODO: Check actual login state here. For now, default to Welcome (not logged in).
        context.go('/welcome');
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
      backgroundColor: const Color(0xFF1E5F5B), // Teal-ish color from image
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.monitor_heart_outlined, // Pulse icon
                  size: 48,
                  color: Color(0xFF1E5F5B),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'LifeGuardian',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              'SENIOR SAFETY SYSTEM',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 80),
            // Loading Bar
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _animation.value,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF64FFDA)), // Bright teal accent
                      minHeight: 4,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
