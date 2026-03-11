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
  dynamic _selectedOption; // Changed to dynamic to support List<int>
  bool _isAnswerChecked = false;
  bool _isCorrect = false;
  MascotState _mascotState = MascotState.idle;
  int _incorrectAnswers = 0;

  Task get _currentTask => widget.lesson.tasks[_currentTaskIndex];

  void _checkAnswer() {
    if (_currentTask.type == TaskType.info) {
      _nextTask();
      return;
    }

    if (_selectedOption == null || (_selectedOption is List && (_selectedOption as List).isEmpty)) return;

    setState(() {
      _isAnswerChecked = true;
      if (_currentTask.type == TaskType.multipleResponse) {
        List<int> selected = List<int>.from(_selectedOption);
        List<int> correct = List<int>.from(_currentTask.correctAnswerIndex);
        _isCorrect = selected.length == correct.length && selected.every((e) => correct.contains(e));
      } else {
        _isCorrect = _selectedOption == _currentTask.correctAnswerIndex;
      }
      _mascotState = _isCorrect ? MascotState.happy : MascotState.sad;
      if (!_isCorrect) {
        _incorrectAnswers++;
      }
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
      int finalXp = widget.lesson.xpReward;
      // Deduct XP for mistakes, but keep it positive
      if (_incorrectAnswers > 0) {
        finalXp = (finalXp - (_incorrectAnswers * 2)).clamp(2, widget.lesson.xpReward);
      }

      Provider.of<UserProvider>(context, listen: false)
          .completeLesson(widget.lesson.id, finalXp);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LessonSuccessScreen(xp: finalXp),
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
                    if (_currentTask.contentSnippet != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _currentTask.contentSnippet!,
                          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    if (_currentTask.type != TaskType.info)
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
    bool isSelected = false;
    if (_currentTask.type == TaskType.multipleResponse) {
      isSelected = (_selectedOption as List<int>?)?.contains(index) ?? false;
    } else {
      isSelected = _selectedOption == index;
    }

    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.transparent;

    if (_isAnswerChecked) {
      bool isCorrectChoice = false;
      if (_currentTask.type == TaskType.multipleResponse) {
        isCorrectChoice = (_currentTask.correctAnswerIndex as List<int>).contains(index);
      } else {
        isCorrectChoice = index == _currentTask.correctAnswerIndex;
      }

      if (isCorrectChoice) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (isSelected && !isCorrectChoice) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else if (isSelected) {
      borderColor = Colors.blue;
      bgColor = Colors.blue.shade50;
    }

    // Only allow selecting options before check
    void handleTap() {
      if (!_isAnswerChecked) {
        setState(() {
          if (_currentTask.type == TaskType.multipleResponse) {
            _selectedOption ??= <int>[];
            List<int> selected = List<int>.from(_selectedOption);
            if (selected.contains(index)) {
              selected.remove(index);
            } else {
              selected.add(index);
            }
            _selectedOption = selected;
          } else {
            _selectedOption = index;
          }
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: handleTap,
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ElevatedButton(
              onPressed: (_currentTask.type == TaskType.info)
                  ? _nextTask
                  : ((_selectedOption == null || (_selectedOption is List && (_selectedOption as List).isEmpty)) ? null : (_isAnswerChecked ? _nextTask : _checkAnswer)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAnswerChecked || _currentTask.type == TaskType.info
                    ? (_isCorrect || _currentTask.type == TaskType.info ? Colors.green : Colors.blue)
                    : Colors.blue.shade800,
                minimumSize: const Size(double.infinity, 65), // Slightly taller for better touch
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: _isAnswerChecked ? 4 : 2,
              ),
              child: Text(
                _isAnswerChecked || _currentTask.type == TaskType.info ? 'KONTYNUUJ' : 'SPRAWDŹ',
                style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
