class Assignment {
  final String id;
  final String courseId;
  final String title;
  final DateTime dueDate;
  final bool completed;
  final Duration notifyBefore; // e.g., Duration(hours: 1)

  Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.dueDate,
    this.completed = false,
    this.notifyBefore = const Duration(hours: 1),
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'completed': completed,
    'notifyBefore': notifyBefore.inMicroseconds,
  };

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: json['id'],
    courseId: json['courseId'],
    title: json['title'],
    dueDate: DateTime.parse(json['dueDate']),
    completed: json['completed'] ?? false,
    notifyBefore: Duration(
      microseconds: json['notifyBefore'] ?? 3600000000,
    ), // 1 hour default
  );
}
