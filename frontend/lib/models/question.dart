import 'choice.dart';

class Question {
  final int id;
  final int questionNumber; // 101 - 200
  final int part; // 5, 6, 7
  final String content;
  final List<Choice> choices;
  final int? passageId;
  final String? explanation;
  final bool allowShuffle;

  Question({
    required this.id,
    required this.questionNumber,
    required this.part,
    required this.content,
    required this.choices,
    this.passageId,
    this.explanation,
    this.allowShuffle = true,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var choicesJson = json['choices'] as List? ?? [];
    List<Choice> choiceList = choicesJson.map((c) => Choice.fromJson(c)).toList();

    return Question(
      id: json['id'] ?? 0,
      questionNumber: json['questionNumber'] ?? 0,
      part: json['part'] ?? 5,
      content: json['content'] ?? '',
      choices: choiceList,
      passageId: json['passageId'],
      explanation: json['explanation'],
      allowShuffle: json['allowShuffle'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionNumber': questionNumber,
      'part': part,
      'content': content,
      'choices': choices.map((c) => c.toJson()).toList(),
      'passageId': passageId,
      'explanation': explanation,
      'allowShuffle': allowShuffle,
    };
  }
}
