import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum MascotState { idle, happy, sad, talking, surprised, thinking }

class Mascot extends StatefulWidget {
  final MascotState state;
  final double size;
  final bool isHero;

  const Mascot({
    super.key,
    this.state = MascotState.idle,
    this.size = 60,
    this.isHero = true,
  });

  @override
  State<Mascot> createState() => _MascotState();
}

class _MascotState extends State<Mascot> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  String _getFace(double mouthValue) {
    switch (widget.state) {
      case MascotState.happy:
        return '(^‿^)';
      case MascotState.sad:
        return '(T_T)';
      case MascotState.talking:
        return mouthValue > 0.5 ? '(◦_◦)' : '(•_•)';
      case MascotState.surprised:
        return '(O_O)';
      case MascotState.thinking:
        return '(-_-)';
      case MascotState.idle:
        return '(•_•)';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the base face text once per build to avoid flickering
    // except for the talking state which uses mouthValue

    Widget mascotBody = AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        double breathing = _breathingController.value * 0.02; // Reduced breathing for smoothness
        double mouthValue = widget.state == MascotState.talking
            ? (math.sin(DateTime.now().millisecondsSinceEpoch / 150) + 1) / 2
            : 0;

        return Transform.scale(
          scale: 1.0 + breathing,
          child: Transform.rotate(
            angle: widget.state == MascotState.happy
                ? math.sin(DateTime.now().millisecondsSinceEpoch / 400) * 0.05
                : 0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                _getFace(mouthValue),
                style: TextStyle(
                  fontSize: widget.size,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace', // Use generic monospace for better cross-platform support
                  color: Colors.blue.shade800,
                ),
              ),
            ),
          ),
        );
      },
    );

    // Add organic "bobbing" or movements based on state
    if (widget.state == MascotState.talking) {
      mascotBody = mascotBody
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(begin: 0, end: -3, duration: 600.ms, curve: Curves.easeInOut); // Smoother bob
    } else if (widget.state == MascotState.happy) {
      mascotBody = mascotBody
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(begin: 0, end: -10, duration: 500.ms, curve: Curves.easeInOut)
          .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 500.ms);
    } else if (widget.state == MascotState.sad) {
      mascotBody = mascotBody
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shake(hz: 1, duration: 2000.ms, curve: Curves.easeInOut);
    }

    if (widget.isHero) {
      return Hero(
        tag: 'mascot',
        child: Material(
          color: Colors.transparent,
          child: mascotBody,
        ),
      );
    }
    return mascotBody;
  }
}
