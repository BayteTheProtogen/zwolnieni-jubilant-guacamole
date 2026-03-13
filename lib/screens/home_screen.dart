import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/mascot.dart';
import '../widgets/update_popup.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          _buildMainContent(context, userProvider),
          if (userProvider.showUpdatePopup) const UpdatePopup(),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, UserProvider userProvider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CyberSpryt', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          _buildStat(Icons.local_fire_department, userProvider.streak.toString(), Colors.orange),
          _buildStat(Icons.stars, userProvider.xp.toString(), Colors.blue),
          const SizedBox(width: 10),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Mascot(state: MascotState.idle, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Twoja ścieżka wiedzy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (userProvider.isLoadingLessons)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 20),
            ...userProvider.categories.map((cat) => _buildCategorySection(context, cat, userProvider)),
            const SizedBox(height: 40),
            _buildComingSoonSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, dynamic category, UserProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: category.lessons.length,
            itemBuilder: (ctx, index) {
              final lesson = category.lessons[index];
              final isCompleted = provider.completedLessonIds.contains(lesson.id);
              return _buildLessonCard(context, lesson, isCompleted);
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLessonCard(BuildContext context, dynamic lesson, bool isCompleted) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)),
          );
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.shade100 : Colors.blue.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? Colors.green : Colors.blue,
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.play_arrow,
                    size: 40,
                    color: isCompleted ? Colors.green : Colors.blue,
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      child: const Icon(Icons.star, color: Colors.white, size: 20),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              lesson.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.grey),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'Wkrótce nowe lekcje! Rozwijaj swoje cyfrowe bezpieczeństwo z nami.',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
