class Reminder {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final DateTime reminderDate;
  final bool isCompleted;
  final DateTime createdAt;

  Reminder({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.reminderDate,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'reminder_date': reminderDate.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      reminderDate: DateTime.parse(map['reminder_date']),
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Reminder copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    DateTime? reminderDate,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderDate: reminderDate ?? this.reminderDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
