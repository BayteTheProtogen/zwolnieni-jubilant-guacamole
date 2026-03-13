enum TaskType { multipleChoice, suspiciousElement, trueFalse, info, multipleResponse }

class Task {
  final String id;
  final TaskType type;
  final String question;
  final List<String> options;
  final dynamic correctAnswerIndex; // Int for single choice, List<int> for multipleResponse
  final String? explanation;
  final String? contentSnippet; // For suspicious element tasks or extra text for info
  final String? imageUrl;
  final String? videoUrl;

  Task({
    required this.id,
    required this.type,
    required this.question,
    required this.options,
    this.correctAnswerIndex,
    this.explanation,
    this.contentSnippet,
    this.imageUrl,
    this.videoUrl,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      type: TaskType.values.firstWhere((e) => e.name == json['type']),
      question: json['question'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      contentSnippet: json['contentSnippet'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
    );
  }
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

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      xpReward: json['xpReward'] ?? 10,
      tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
    );
  }
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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      lessons: (json['lessons'] as List).map((l) => Lesson.fromJson(l)).toList(),
    );
  }
}
