import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  int _xp = 0;
  int _streak = 0;
  DateTime? _lastActivity;
  List<String> _completedLessonIds = [];

  // Accessibility preferences
  double _fontSizeMultiplier = 1.0;
  bool _highContrast = false;
  bool _isFirstRun = true;

  int get xp => _xp;
  int get streak => _streak;
  List<String> get completedLessonIds => _completedLessonIds;
  double get fontSizeMultiplier => _fontSizeMultiplier;
  bool get highContrast => _highContrast;
  bool get isFirstRun => _isFirstRun;

  UserProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _xp = prefs.getInt('xp') ?? 0;
    _streak = prefs.getInt('streak') ?? 0;
    _completedLessonIds = prefs.getStringList('completedLessons') ?? [];
    _fontSizeMultiplier = prefs.getDouble('fontSizeMultiplier') ?? 1.0;
    _highContrast = prefs.getBool('highContrast') ?? false;
    _isFirstRun = prefs.getBool('isFirstRun') ?? true;

    String? lastActivityStr = prefs.getString('lastActivity');
    if (lastActivityStr != null) {
      _lastActivity = DateTime.parse(lastActivityStr);
    }

    _checkStreak();
    notifyListeners();
  }

  void _checkStreak() {
    if (_lastActivity == null) return;

    final now = DateTime.now();
    final difference = now.difference(_lastActivity!).inDays;

    if (difference > 1) {
      _streak = 0;
      _saveStreak();
    }
  }

  Future<void> completeLesson(String lessonId, int xpReward) async {
    if (!_completedLessonIds.contains(lessonId)) {
      _completedLessonIds.add(lessonId);
      _xp += xpReward;

      final now = DateTime.now();
      if (_lastActivity == null || now.difference(_lastActivity!).inDays == 1) {
        _streak += 1;
      } else if (now.difference(_lastActivity!).inDays > 1) {
        _streak = 1;
      }

      _lastActivity = now;
      await _saveProgress();
      notifyListeners();
    }
  }

  Future<void> setAccessibility({double? fontSize, bool? highContrast}) async {
    if (fontSize != null) _fontSizeMultiplier = fontSize;
    if (highContrast != null) _highContrast = highContrast;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeMultiplier', _fontSizeMultiplier);
    await prefs.setBool('highContrast', _highContrast);
    notifyListeners();
  }

  Future<void> completeFirstRun() async {
    _isFirstRun = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
    await prefs.setInt('streak', _streak);
    await prefs.setStringList('completedLessons', _completedLessonIds);
    await prefs.setString('lastActivity', _lastActivity?.toIso8601String() ?? '');
  }

  Future<void> _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', _streak);
  }
}
