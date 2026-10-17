import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/choice.dart';
import '../models/passage.dart';
import '../models/question.dart';
import '../providers/exam_provider.dart';
import '../theme/app_theme.dart';
import 'exam_result_screen.dart';
import '../widgets/mobile_device_frame.dart';


class ExamTakingScreen extends StatelessWidget {
  const ExamTakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();

    if (provider.isLoading || provider.currentExam == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If teacher turned off the exam session
    if (!provider.currentExam!.isPublished) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(provider.currentExam!.title),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0F172A),
          elevation: 1,
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(36),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_rounded, size: 38, color: Color(0xFFDC2626)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ca thi đã bị khóa bởi Giáo viên',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Giáo viên quản trị vừa chuyển trạng thái ca thi này sang Inactive / Draft trên Web Portal. Sinh viên không thể tiếp tục làm bài thi này.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Quay lại danh sách đề thi', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Auto navigate to result if submitted
    if (provider.isSubmitted && provider.lastResult != null) {
      Future.microtask(() {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ExamResultScreen(result: provider.lastResult!),
            ),
          );
        }
      });
    }

    final currentQ = provider.currentQuestion;
    if (currentQ == null) {
      return const Scaffold(body: Center(child: Text('Không có câu hỏi')));
    }

    // Find passage if this is Part 6 or Part 7
    Passage? passage;
    if (currentQ.passageId != null) {
      passage = provider.currentExam!.passages.firstWhere(
        (p) => p.id == currentQ.passageId,
        orElse: () => Passage(id: 0, title: '', content: ''),
      );
    }

    final isFlagged = provider.flaggedQuestions.contains(currentQ.id);

    return MobileDeviceFrame(
      appTitle: 'Làm bài thi TOEIC',
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _showExitConfirmation(context) ?? false;
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Thoát bài thi',
                onPressed: () => _showExitConfirmation(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.currentExam!.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Câu ${provider.currentQuestionIndex + 1}/${provider.totalQuestionsCount} (Part ${currentQ.part})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Timer Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: provider.isNearTimeEnd
                      ? AppTheme.danger.withValues(alpha: 0.12)
                      : AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: provider.isNearTimeEnd
                        ? AppTheme.danger
                        : AppTheme.primaryLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: provider.isNearTimeEnd
                          ? AppTheme.danger
                          : AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider.timerString,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: provider.isNearTimeEnd
                            ? AppTheme.danger
                            : AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFlagged ? Icons.bookmark : Icons.bookmark_border,
                color: isFlagged ? AppTheme.warning : AppTheme.textMuted,
              ),
              tooltip: 'Gắn cờ xem lại',
              onPressed: () => provider.toggleFlag(currentQ.id),
            ),
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              tooltip: 'Danh sách câu hỏi',
              onPressed: () => _showQuestionGridSheet(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value:
                  (provider.currentQuestionIndex + 1) /
                  provider.totalQuestionsCount,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                provider.isNearTimeEnd
                    ? AppTheme.danger
                    : AppTheme.primaryLight,
              ),
              minHeight: 3,
            ),

            // Question Content (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Part Header Badge
                  _buildPartHeader(currentQ.part),
                  const SizedBox(height: 12),

                  // Passage (if Part 6 or Part 7)
                  if (passage != null && passage.content.isNotEmpty) ...[
                    _buildPassageCard(passage),
                    const SizedBox(height: 16),
                  ],

                  // Question Box
                  _buildQuestionBox(currentQ),
                  const SizedBox(height: 16),

                  // 4 Answer Choices
                  ...currentQ.choices.map(
                    (choice) => _buildChoiceTile(
                      context,
                      currentQ,
                      choice,
                      provider.userAnswers[currentQ.id] == choice.id,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomBar(context, provider),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildPartHeader(int part) {
    String partName = '';
    switch (part) {
      case 5:
        partName = 'Part 5: Incomplete Sentences (Câu độc lập)';
        break;
      case 6:
        partName = 'Part 6: Text Completion (Điền đoạn văn)';
        break;
      case 7:
        partName = 'Part 7: Reading Comprehension (Đọc hiểu văn bản)';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            partName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassageCard(Passage passage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (passage.title.isNotEmpty) ...[
            Text(
              passage.title,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
            const Divider(height: 16, color: AppTheme.border),
          ],
          Text(
            passage.content,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionBox(Question question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${question.questionNumber}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              question.content,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceTile(
    BuildContext context,
    Question question,
    Choice choice,
    bool isSelected,
  ) {
    final provider = context.read<ExamProvider>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          provider.selectAnswer(question.id, choice.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.primary : Colors.grey.shade100,
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  choice.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  choice.content,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.primaryDark
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, ExamProvider provider) {
    final isFirst = provider.currentQuestionIndex == 0;
    final isLast =
        provider.currentQuestionIndex == provider.totalQuestionsCount - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous button
            OutlinedButton(
              onPressed: isFirst ? null : () => provider.previousQuestion(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, size: 16),
            ),
            const SizedBox(width: 8),

            // Next button
            Expanded(
              child: isLast
                  ? ElevatedButton(
                      onPressed: () =>
                          _showSubmitConfirmation(context, provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 18),
                          SizedBox(width: 6),
                          Text('Nộp bài thi'),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () => provider.nextQuestion(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Câu tiếp theo'),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_ios_rounded, size: 14),
                        ],
                      ),
                    ),
            ),
            const SizedBox(width: 8),

            // Quick Submit Button in toolbar
            if (!isLast)
              IconButton(
                icon: const Icon(Icons.send_rounded, color: AppTheme.primary),
                tooltip: 'Nộp bài ngay',
                onPressed: () => _showSubmitConfirmation(context, provider),
              ),
          ],
        ),
      ),
    );
  }

  // Question Navigator Grid Bottom Sheet
  void _showQuestionGridSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer<ExamProvider>(
          builder: (context, provider, _) {
            final questions = provider.currentExam!.questions;
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Danh sách câu hỏi (100 câu)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegend(
                        AppTheme.primary,
                        'Đã làm (${provider.answeredCount})',
                      ),
                      _buildLegend(
                        Colors.grey.shade200,
                        'Chưa làm (${provider.unansweredCount})',
                        textColor: AppTheme.textPrimary,
                      ),
                      _buildLegend(
                        AppTheme.warning,
                        'Gắn cờ (${provider.flaggedQuestions.length})',
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Grid of questions
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: questions.length,
                      itemBuilder: (context, idx) {
                        final q = questions[idx];
                        final isAnswered = provider.userAnswers.containsKey(
                          q.id,
                        );
                        final isCurrent = provider.currentQuestionIndex == idx;
                        final isFlagged = provider.flaggedQuestions.contains(
                          q.id,
                        );

                        Color bgColor;
                        Color textColor;
                        Border? border;

                        if (isCurrent) {
                          border = Border.all(
                            color: AppTheme.primaryDark,
                            width: 2.5,
                          );
                        }

                        if (isFlagged) {
                          bgColor = AppTheme.warning.withValues(alpha: 0.2);
                          border = Border.all(
                            color: AppTheme.warning,
                            width: 2,
                          );
                          textColor = AppTheme.warning;
                        } else if (isAnswered) {
                          bgColor = AppTheme.primary;
                          textColor = Colors.white;
                        } else {
                          bgColor = Colors.grey.shade100;
                          textColor = AppTheme.textPrimary;
                        }

                        return InkWell(
                          onTap: () {
                            provider.jumpToQuestion(idx);
                            Navigator.pop(ctx);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  border ??
                                  Border.all(color: Colors.grey.shade300),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${q.questionNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showSubmitConfirmation(context, provider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Nộp bài thi'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLegend(Color color, String label, {Color? textColor}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  // Confirmation dialogs
  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thoát bài thi?'),
        content: const Text(
          'Bạn có chắc chắn muốn thoát? Kết quả bài làm hiện tại sẽ không được lưu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tiếp tục thi'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              Navigator.pop(ctx, true);
              Navigator.pop(context);
            },
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  void _showSubmitConfirmation(BuildContext context, ExamProvider provider) {
    final unanswered = provider.unansweredCount;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              unanswered > 0
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline,
              color: unanswered > 0 ? AppTheme.warning : AppTheme.success,
            ),
            const SizedBox(width: 8),
            const Text('Xác nhận nộp bài'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (unanswered > 0) ...[
              Text(
                'Cảnh báo: Bạn còn $unanswered câu chưa hoàn thành!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.danger,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Bạn có chắc chắn muốn nộp bài thi ngay bây giờ?'),
            ] else ...[
              const Text('Bạn đã hoàn thành tất cả các câu hỏi!'),
              const SizedBox(height: 8),
              const Text(
                'Bạn có muốn gửi dữ liệu bài làm và chấm điểm ngay không?',
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kiểm tra lại'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: unanswered > 0
                  ? AppTheme.warning
                  : AppTheme.success,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              provider.submitExam();
            },
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );
  }
}
