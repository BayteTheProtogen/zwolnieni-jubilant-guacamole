enum TaskType { multipleChoice, suspiciousElement, trueFalse }

class Task {
  final String id;
  final TaskType type;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String? contentSnippet; // For suspicious element tasks

  Task({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.contentSnippet,
  });
}

class Lesson {
  final String id;
  final String title;
  final List<Task> tasks;
  final int xpReward;

  Lesson({
    required this.id,
    required this.title,
    required this.tasks,
    this.xpReward = 10,
  });
}

class Category {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final String icon;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.icon,
  });
}
