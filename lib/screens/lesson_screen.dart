import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/lesson_models.dart';
import '../providers/user_provider.dart';
import '../widgets/mascot.dart';
import '../widgets/speech_bubble.dart';
import 'lesson_success_screen.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentTaskIndex = 0;
  int? _selectedOption;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;
  MascotState _mascotState = MascotState.idle;

  Task get _currentTask => widget.lesson.tasks[_currentTaskIndex];

  void _checkAnswer() {
    if (_selectedOption == null) return;

    setState(() {
      _isAnswerChecked = true;
      _isCorrect = _selectedOption == _currentTask.correctAnswerIndex;
      _mascotState = _isCorrect ? MascotState.happy : MascotState.sad;
    });

    if (_isCorrect) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.vibrate();
    }
  }

  void _nextTask() {
    if (_currentTaskIndex < widget.lesson.tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _selectedOption = null;
        _isAnswerChecked = false;
        _mascotState = MascotState.idle;
      });
    } else {
      // Lesson complete
      Provider.of<UserProvider>(context, listen: false)
          .completeLesson(widget.lesson.id, widget.lesson.xpReward);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LessonSuccessScreen(xp: widget.lesson.xpReward),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentTaskIndex + 1) / widget.lesson.tasks.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          minHeight: 12,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Mascot(state: _mascotState, size: 80),
                    const SizedBox(height: 20),
                    SpeechBubble(text: _currentTask.question),
                    const SizedBox(height: 30),
                    ...List.generate(
                      _currentTask.options.length,
                      (index) => _buildOption(index),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index) {
    bool isSelected = _selectedOption == index;
    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.transparent;

    if (_isAnswerChecked) {
      if (index == _currentTask.correctAnswerIndex) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (isSelected && !_isCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else if (isSelected) {
      borderColor = Colors.blue;
      bgColor = Colors.blue.shade50;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: _isAnswerChecked ? null : () => setState(() => _selectedOption = index),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 2.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            _currentTask.options[index],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isAnswerChecked && _currentTask.explanation != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                _currentTask.explanation!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: _selectedOption == null ? null : (_isAnswerChecked ? _nextTask : _checkAnswer),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isAnswerChecked
                  ? (_isCorrect ? Colors.green : Colors.blue)
                  : Colors.blue.shade800,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              _isAnswerChecked ? 'KONTYNUUJ' : 'SPRAWDŹ',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
