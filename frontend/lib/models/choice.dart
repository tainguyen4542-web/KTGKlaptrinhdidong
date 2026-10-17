class Choice {
  final int id;
  final String label; // A, B, C, D
  final String content;
  final bool isCorrect;

  Choice({
    required this.id,
    required this.label,
    required this.content,
    this.isCorrect = false,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      content: json['content'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'content': content,
      'isCorrect': isCorrect,
    };
  }
}
