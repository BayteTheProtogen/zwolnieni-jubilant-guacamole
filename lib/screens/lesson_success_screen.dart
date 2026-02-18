import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/mascot.dart';

class LessonSuccessScreen extends StatelessWidget {
  final int xp;

  const LessonSuccessScreen({super.key, required this.xp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Świetna robota!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ).animate().fade().scale(),
              const SizedBox(height: 40),
              const Center(
                child: Mascot(
                  state: MascotState.happy,
                  size: 150,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'ZDOBYTO',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '+$xp XP',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 40),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 1, end: 0, curve: Curves.elasticOut, duration: 800.ms),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('WRÓĆ DO MENU', style: TextStyle(fontSize: 22, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
