enum TaskCategory { penting, biasa }

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskCategory category;
  final bool done;
  final DateTime? completedAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    this.done = false,
    this.completedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'due_date': dueDate.toIso8601String(),
    'category': category.name,
    'done': done ? 1 : 0,
    'completed_at': completedAt?.toIso8601String(),
  };

  factory Task.fromMap(Map<String, dynamic> m) => Task(
    id: m['id'] as int?,
    title: m['title'] as String,
    description: m['description'] as String? ?? '',
    dueDate: DateTime.parse(m['due_date'] as String),
    category: TaskCategory.values.firstWhere(
      (c) => c.name == m['category'],
      orElse: () => TaskCategory.biasa,
    ),
    done: (m['done'] as int? ?? 0) == 1,
    completedAt: m['completed_at'] == null
        ? null
        : DateTime.tryParse(m['completed_at'] as String),
  );

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskCategory? category,
    bool? done,
    DateTime? completedAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    category: category ?? this.category,
    done: done ?? this.done,
    completedAt: completedAt ?? this.completedAt,
  );
}
