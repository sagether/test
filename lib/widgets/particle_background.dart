import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({Key? key}) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int _particleCount = 8;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // 创建动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    // 初始化粒子
    _initParticles();
  }

  void _initParticles() {
    final areas = [
      const Offset(-100, -100),
      const Offset(300, -150),
      const Offset(-150, 300),
      const Offset(350, 350),
      const Offset(100, 100),
      const Offset(-200, 100),
      const Offset(400, 100),
      const Offset(100, -200),
    ];

    for (int i = 0; i < _particleCount; i++) {
      final basePosition = areas[i % areas.length];
      final randomOffset = Offset(
        -100 + _random.nextDouble() * 200,
        -100 + _random.nextDouble() * 200,
      );

      _particles.add(
        Particle(
          size: _randomSize(),
          position: basePosition + randomOffset,
          opacity: _randomOpacity(),
          animationOffset: _random.nextDouble(),
          color: _randomColor(),
          movementScale: 0.05 + _random.nextDouble() * 0.15,
        ),
      );
    }
  }

  double _randomSize() {
    if (_random.nextDouble() > 0.7) {
      return 180 + _random.nextDouble() * 280;
    } else if (_random.nextDouble() > 0.5) {
      return 120 + _random.nextDouble() * 150;
    } else {
      return 60 + _random.nextDouble() * 100;
    }
  }

  double _randomOpacity() {
    return 0.03 + _random.nextDouble() * 0.07;
  }

  Color _randomColor() {
    final colors = [
      Colors.white,
      Colors.blue.shade200,
      Colors.purple.shade200,
      Colors.cyan.shade200,
    ];
    return colors[_random.nextInt(colors.length)];
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
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  final double size;
  final Offset position;
  final double opacity;
  final double animationOffset;
  final Color color;
  final double movementScale;

  Particle({
    required this.size,
    required this.position,
    required this.opacity,
    required this.animationOffset,
    required this.color,
    this.movementScale = 0.15,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final particleProgress = (progress + particle.animationOffset) % 1.0;

      final x =
          particle.position.dx +
          size.width *
              particle.movementScale *
              math.sin(particleProgress * 2 * math.pi);
      final y =
          particle.position.dy +
          size.height *
              particle.movementScale *
              math.cos(particleProgress * 2 * math.pi);

      final paint =
          Paint()
            ..color = particle.color.withOpacity(particle.opacity)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(Offset(x, y), particle.size, paint);

      final glowPaint =
          Paint()
            ..color = particle.color.withOpacity(particle.opacity * 0.25)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0;

      canvas.drawCircle(Offset(x, y), particle.size * 1.25, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
