import 'question.dart';

class ExamResult {
  final int examId;
  final String examTitle;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final int score; // TOEIC scaled score (5 to 495)
  final int timeSpentSeconds;
  final DateTime completedAt;
  final Map<int, int> selectedChoices; // questionId -> choiceId
  final List<Question> questions;

  ExamResult({
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.score,
    required this.timeSpentSeconds,
    required this.completedAt,
    required this.selectedChoices,
    required this.questions,
  });

  // Calculate estimated TOEIC Reading score (approx ETS curve out of 495)
  static int calculateToeicScore(int correctCount, int totalQuestions) {
    if (totalQuestions == 0) return 5;
    double percentage = correctCount / totalQuestions;
    if (percentage <= 0.15) return 5;
    int raw = (percentage * 490 + 5).round();
    // Round to nearest 5
    return ((raw + 2) ~/ 5) * 5;
  }
}
