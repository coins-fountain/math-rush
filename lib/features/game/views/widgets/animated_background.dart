import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SymbolParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Create initial particles
    for (int i = 0; i < 15; i++) {
      _particles.add(SymbolParticle.random(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(_particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class SymbolParticle {
  final String symbol;
  final double x;
  double y;
  final double speed;
  final double size;
  final double rotation;

  SymbolParticle({
    required this.symbol,
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotation,
  });

  factory SymbolParticle.random(math.Random random) {
    const symbols = ['+', '-', '×', '÷', '=', '?', '%'];
    return SymbolParticle(
      symbol: symbols[random.nextInt(symbols.length)],
      x: random.nextDouble(),
      y: random.nextDouble() * 1.2, // Start slightly off screen
      speed: 0.05 + random.nextDouble() * 0.1,
      size: 14 + random.nextDouble() * 20,
      rotation: random.nextDouble() * math.pi * 2,
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final List<SymbolParticle> particles;
  final double animationValue;

  BackgroundPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var particle in particles) {
      // Calculate current position
      double currentY = ((particle.y - (animationValue * particle.speed)) % 1.2) - 0.1;
      
      final offset = Offset(
        particle.x * size.width,
        currentY * size.height,
      );

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(particle.rotation + (animationValue * math.pi));

      textPainter.text = TextSpan(
        text: particle.symbol,
        style: TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.1),
          fontSize: particle.size,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) => true;
}
