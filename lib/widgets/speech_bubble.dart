import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpeechBubble extends StatelessWidget {
  final String text;
  final bool animate;

  const SpeechBubble({
    super.key,
    required this.text,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );

    if (animate) {
      return bubble.animate().fade(duration: 400.ms).scale(
            curve: Curves.elasticOut,
            duration: 600.ms,
            begin: const Offset(0.8, 0.8),
          );
    }
    return bubble;
  }
}
