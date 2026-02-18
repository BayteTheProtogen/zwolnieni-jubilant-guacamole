import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/mascot.dart';
import '../widgets/speech_bubble.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Expanded(
                child: Center(
                  child: Mascot(
                    state: MascotState.talking,
                    size: 100,
                  ),
                ),
              ),
              if (_step == 0) ...[
                const SpeechBubble(
                  text: 'Cześć! Jestem Twoim przewodnikiem po świecie CyberSprytu. Najpierw dostosujmy aplikację do Twoich potrzeb.',
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => setState(() => _step++),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Zaczynajmy!', style: TextStyle(fontSize: 20)),
                ),
              ] else if (_step == 1) ...[
                const SpeechBubble(
                  text: 'Wybierz wielkość tekstu, która jest dla Ciebie najwygodniejsza.',
                ),
                const SizedBox(height: 20),
                _buildFontOption(context, 'Mały', 0.8, userProvider),
                const SizedBox(height: 10),
                _buildFontOption(context, 'Normalny', 1.0, userProvider),
                const SizedBox(height: 10),
                _buildFontOption(context, 'Duży', 1.3, userProvider),
                const SizedBox(height: 10),
                _buildFontOption(context, 'Bardzo duży', 1.6, userProvider),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => setState(() => _step++),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Dalej', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ] else if (_step == 2) ...[
                const SpeechBubble(
                  text: 'Czy chcesz włączyć wysoki kontrast, aby tekst był wyraźniejszy?',
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Wysoki kontrast', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  value: userProvider.highContrast,
                  onChanged: (val) => userProvider.setAccessibility(highContrast: val),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    userProvider.completeFirstRun();
                    // Navigation happens automatically in main.dart based on isFirstRun
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Gotowe! Wejdź do gry', style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontOption(BuildContext context, String label, double size, UserProvider provider) {
    bool selected = provider.fontSizeMultiplier == size;
    return InkWell(
      onTap: () => provider.setAccessibility(fontSize: size),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: selected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 18 * size)),
            if (selected) const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
