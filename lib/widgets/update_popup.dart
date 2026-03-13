import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UpdatePopup extends StatelessWidget {
  const UpdatePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.new_releases, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Nowe lekcje dostępne!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
        .animate()
        .slideX(begin: 1, end: 0, duration: 500.ms, curve: Curves.easeOutCubic)
        .fade()
        .then(delay: 3.seconds)
        .fadeOut(duration: 500.ms),
      ),
    );
  }
}
