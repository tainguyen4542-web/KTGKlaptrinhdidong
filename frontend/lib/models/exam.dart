import 'passage.dart';
import 'question.dart';

class Exam {
  final int id;
  final String title;
  final String description;
  final int durationMinutes; // 75
  final int totalQuestions; // 100
  final bool isPublished;
  final List<Question> questions;
  final List<Passage> passages;

  Exam({
    required this.id,
    required this.title,
    this.description = '',
    this.durationMinutes = 75,
    this.totalQuestions = 100,
    this.isPublished = true,
    this.questions = const [],
    this.passages = const [],
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    var qJson = json['questions'] as List? ?? [];
    List<Question> qList = qJson.map((q) => Question.fromJson(q)).toList();

    var pJson = json['passages'] as List? ?? [];
    List<Passage> pList = pJson.map((p) => Passage.fromJson(p)).toList();

    return Exam(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 75,
      totalQuestions: json['totalQuestions'] ?? 100,
      isPublished: json['isPublished'] ?? false,
      questions: qList,
      passages: pList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'totalQuestions': totalQuestions,
      'isPublished': isPublished,
      'questions': questions.map((q) => q.toJson()).toList(),
      'passages': passages.map((p) => p.toJson()).toList(),
    };
  }
}
