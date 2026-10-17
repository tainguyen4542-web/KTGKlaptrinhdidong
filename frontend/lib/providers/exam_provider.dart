import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../models/exam_result.dart';
import '../services/api_service.dart';

class ExamProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Exam> _exams = [];
  bool _isLoading = false;
  String? _errorMessage;

  Exam? _currentExam;
  int _currentQuestionIndex = 0;
  
  // State for exam taking
  // questionId -> choiceId
  final Map<int, int> _userAnswers = {};
  // questionId -> isFlagged
  final Set<int> _flaggedQuestions = {};

  // Timer state
  Timer? _timer;
  int _remainingSeconds = 75 * 60; // 75 minutes
  int _totalDurationSeconds = 75 * 60;
  bool _isTimeUp = false;
  bool _isSubmitted = false;
  ExamResult? _lastResult;

  // Getters
  List<Exam> get exams => _exams;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Exam? get currentExam => _currentExam;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, int> get userAnswers => _userAnswers;
  Set<int> get flaggedQuestions => _flaggedQuestions;
  int get remainingSeconds => _remainingSeconds;
  bool get isTimeUp => _isTimeUp;
  bool get isSubmitted => _isSubmitted;
  ExamResult? get lastResult => _lastResult;

  bool get isNearTimeEnd => _remainingSeconds <= 5 * 60 && _remainingSeconds > 0; // <= 5 mins

  Question? get currentQuestion {
    if (_currentExam == null || _currentExam!.questions.isEmpty) return null;
    if (_currentQuestionIndex >= _currentExam!.questions.length) return null;
    return _currentExam!.questions[_currentQuestionIndex];
  }

  int get totalQuestionsCount => _currentExam?.questions.length ?? 0;
  int get answeredCount => _userAnswers.length;
  int get unansweredCount => totalQuestionsCount - answeredCount;

  // Format timer string HH:MM:SS or MM:SS
  String get timerString {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    String minStr = minutes.toString().padLeft(2, '0');
    String secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  // Load Exam List
  Future<void> fetchExams() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exams = await _apiService.getExams();
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách đề thi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Start Exam
  Future<bool> startExam(int examId) async {
    // Check if exam is published
    final existingExam = _exams.firstWhere((e) => e.id == examId, orElse: () => _exams.first);
    if (!existingExam.isPublished) {
      _errorMessage = 'Ca thi này hiện đang ở trạng thái Đóng (Inactive / Draft). Vui lòng đợi giáo viên kích hoạt!';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _userAnswers.clear();
    _flaggedQuestions.clear();
    _currentQuestionIndex = 0;
    _isSubmitted = false;
    _isTimeUp = false;
    _lastResult = null;
    _timer?.cancel();
    notifyListeners();

    try {
      _currentExam = await _apiService.getExamDetail(examId);
      // Ensure currentExam inherits the live isPublished state
      _currentExam = Exam(
        id: _currentExam!.id,
        title: _currentExam!.title,
        description: _currentExam!.description,
        durationMinutes: _currentExam!.durationMinutes,
        totalQuestions: _currentExam!.totalQuestions,
        isPublished: existingExam.isPublished,
        questions: _currentExam!.questions,
        passages: _currentExam!.passages,
      );
      _remainingSeconds = (_currentExam!.durationMinutes) * 60;
      _totalDurationSeconds = _remainingSeconds;
      _startTimer();
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi khởi động đề thi: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isTimeUp = true;
        submitExam(); // Auto submit when time is up
      }
    });
  }

  // Select or Unselect an answer
  void selectAnswer(int questionId, int choiceId) {
    if (_isTimeUp || _isSubmitted) return;

    if (_userAnswers[questionId] == choiceId) {
      // Toggle off / cancel selection as required in PDF
      _userAnswers.remove(questionId);
    } else {
      _userAnswers[questionId] = choiceId;
    }
    notifyListeners();
  }

  // Toggle flag for a question
  void toggleFlag(int questionId) {
    if (_flaggedQuestions.contains(questionId)) {
      _flaggedQuestions.remove(questionId);
    } else {
      _flaggedQuestions.add(questionId);
    }
    notifyListeners();
  }

  // Jump to specific question
  void jumpToQuestion(int index) {
    if (_currentExam != null && index >= 0 && index < _currentExam!.questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentExam != null && _currentQuestionIndex < _currentExam!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // Submit Exam and Calculate Results
  void submitExam() {
    if (_isSubmitted || _currentExam == null) return;

    _timer?.cancel();
    _isSubmitted = true;

    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (var q in _currentExam!.questions) {
      final selectedId = _userAnswers[q.id];
      if (selectedId == null) {
        skipped++;
      } else {
        final correctChoice = q.choices.firstWhere(
          (c) => c.isCorrect,
          orElse: () => q.choices.first,
        );
        if (selectedId == correctChoice.id) {
          correct++;
        } else {
          wrong++;
        }
      }
    }

    final timeSpent = _totalDurationSeconds - _remainingSeconds;
    final score = ExamResult.calculateToeicScore(correct, _currentExam!.questions.length);

    _lastResult = ExamResult(
      examId: _currentExam!.id,
      examTitle: _currentExam!.title,
      totalQuestions: _currentExam!.questions.length,
      correctCount: correct,
      wrongCount: wrong,
      skippedCount: skipped,
      score: score,
      timeSpentSeconds: timeSpent,
      completedAt: DateTime.now(),
      selectedChoices: Map.from(_userAnswers),
      questions: _currentExam!.questions,
    );

    notifyListeners();
  }

  // Admin Methods for Requirements 3 & 4
  void addOrUpdateExam(Exam exam) {
    final index = _exams.indexWhere((e) => e.id == exam.id);
    if (index >= 0) {
      _exams[index] = exam;
    } else {
      _exams.insert(0, exam);
    }
    notifyListeners();
  }

  void toggleExamPublish(int examId, bool isPublished) {
    final index = _exams.indexWhere((e) => e.id == examId);
    if (index >= 0) {
      final old = _exams[index];
      _exams[index] = Exam(
        id: old.id,
        title: old.title,
        description: old.description,
        durationMinutes: old.durationMinutes,
        totalQuestions: old.totalQuestions,
        isPublished: isPublished,
        questions: old.questions,
        passages: old.passages,
      );
      if (_currentExam != null && _currentExam!.id == examId) {
        _currentExam = Exam(
          id: _currentExam!.id,
          title: _currentExam!.title,
          description: _currentExam!.description,
          durationMinutes: _currentExam!.durationMinutes,
          totalQuestions: _currentExam!.totalQuestions,
          isPublished: isPublished,
          questions: _currentExam!.questions,
          passages: _currentExam!.passages,
        );
      }
      notifyListeners();
    }
  }

  void updateQuestionInCurrentExam(Question updatedQuestion) {
    if (_currentExam == null) return;
    final qList = List<Question>.from(_currentExam!.questions);
    final idx = qList.indexWhere((q) => q.id == updatedQuestion.id);
    if (idx >= 0) {
      qList[idx] = updatedQuestion;
      _currentExam = Exam(
        id: _currentExam!.id,
        title: _currentExam!.title,
        description: _currentExam!.description,
        durationMinutes: _currentExam!.durationMinutes,
        totalQuestions: _currentExam!.totalQuestions,
        isPublished: _currentExam!.isPublished,
        questions: qList,
        passages: _currentExam!.passages,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
