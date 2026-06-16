class Transaction {
  final int? id;
  final int userId;
  final int categoryId;
  final String categoryName;
  final double amount;
  final String type; // 'income' or 'expense'
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  Transaction({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      categoryName: map['category_name'] ?? '',
      amount: map['amount'].toDouble(),
      type: map['type'],
      date: DateTime.parse(map['date']),
      note: map['note'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Transaction copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? categoryName,
    double? amount,
    String? type,
    DateTime? date,
    String? note,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
