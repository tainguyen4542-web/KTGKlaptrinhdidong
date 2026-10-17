import 'package:flutter/material.dart';

import '../models/exam_result.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';
import '../widgets/mobile_device_frame.dart';


class ExamResultScreen extends StatefulWidget {
  final ExamResult result;

  const ExamResultScreen({super.key, required this.result});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  String _selectedFilter = 'ALL'; // ALL, WRONG, CORRECT, SKIPPED

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final int accuracy = result.totalQuestions > 0
        ? ((result.correctCount / result.totalQuestions) * 100).round()
        : 0;

    List<Question> filteredQuestions = result.questions.where((q) {
      final selectedId = result.selectedChoices[q.id];
      final correctChoice = q.choices.firstWhere(
        (c) => c.isCorrect,
        orElse: () => q.choices.first,
      );

      if (_selectedFilter == 'CORRECT') {
        return selectedId != null && selectedId == correctChoice.id;
      } else if (_selectedFilter == 'WRONG') {
        return selectedId != null && selectedId != correctChoice.id;
      } else if (_selectedFilter == 'SKIPPED') {
        return selectedId == null;
      }
      return true;
    }).toList();

    return MobileDeviceFrame(
      appTitle: 'Kết Quả Bài Thi',
      child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kết Quả Bài Thi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Về trang chủ',
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Score summary card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'ĐIỂM TOEIC READING',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${result.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      ' / 495',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Độ chính xác: $accuracy% (${result.correctCount}/${result.totalQuestions} câu)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Detailed Stat Badges (Correct, Wrong, Skipped)
          Row(
            children: [
              Expanded(
                child: _buildStatBadge(
                  Icons.check_circle_rounded,
                  'Đúng',
                  '${result.correctCount}',
                  AppTheme.success,
                  'CORRECT',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatBadge(
                  Icons.cancel_rounded,
                  'Sai',
                  '${result.wrongCount}',
                  AppTheme.danger,
                  'WRONG',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatBadge(
                  Icons.help_outline_rounded,
                  'Bỏ qua',
                  '${result.skippedCount}',
                  AppTheme.textMuted,
                  'SKIPPED',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filter bar & Review title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chi tiết bài làm & Gợi ý giải',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_selectedFilter != 'ALL')
                TextButton(
                  onPressed: () => setState(() => _selectedFilter = 'ALL'),
                  child: const Text('Xem tất cả'),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Question list review
          ...filteredQuestions.map((q) => _buildReviewCard(q, result)),
          const SizedBox(height: 24),

          // Return Home Button
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Quay lại danh sách đề thi'),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatBadge(
    IconData icon,
    String label,
    String count,
    Color color,
    String filterKey,
  ) {
    final isSelected = _selectedFilter == filterKey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = isSelected ? 'ALL' : filterKey;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Question question, ExamResult result) {
    final selectedId = result.selectedChoices[question.id];
    final correctChoice = question.choices.firstWhere(
      (c) => c.isCorrect,
      orElse: () => question.choices.first,
    );

    final isCorrect = selectedId != null && selectedId == correctChoice.id;
    final isSkipped = selectedId == null;

    Color statusColor = isSkipped
        ? AppTheme.textMuted
        : (isCorrect ? AppTheme.success : AppTheme.danger);

    String statusText = isSkipped
        ? 'Chưa trả lời'
        : (isCorrect ? 'Chính xác' : 'Sai');

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '${question.questionNumber}',
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
        title: Text(
          question.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          statusText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: statusColor,
          ),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          // All Choices review
          Column(
            children: question.choices.map((choice) {
              final isUserPick = selectedId == choice.id;
              final isRealCorrect = choice.isCorrect;

              Color? bg;
              Border? border;

              if (isRealCorrect) {
                bg = AppTheme.success.withValues(alpha: 0.12);
                border = Border.all(color: AppTheme.success);
              } else if (isUserPick) {
                bg = AppTheme.danger.withValues(alpha: 0.12);
                border = Border.all(color: AppTheme.danger);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: bg ?? Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: border ?? Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Text(
                      '${choice.label}.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(choice.content)),
                    if (isRealCorrect)
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.success,
                        size: 18,
                      )
                    else if (isUserPick)
                      const Icon(
                        Icons.cancel,
                        color: AppTheme.danger,
                        size: 18,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),

          // Explanation / Gợi ý câu trả lời
          if (question.explanation != null &&
              question.explanation!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.info.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: AppTheme.info,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gợi ý & Giải thích chi tiết:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.info,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          question.explanation!,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
