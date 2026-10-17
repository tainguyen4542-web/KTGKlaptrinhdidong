import 'question.dart';

class Passage {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final int orderIndex;
  final List<Question> questions;

  Passage({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.orderIndex = 0,
    this.questions = const [],
  });

  factory Passage.fromJson(Map<String, dynamic> json) {
    var qJson = json['questions'] as List? ?? [];
    List<Question> qList = qJson.map((q) => Question.fromJson(q)).toList();

    return Passage(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      orderIndex: json['orderIndex'] ?? 0,
      questions: qList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'orderIndex': orderIndex,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
