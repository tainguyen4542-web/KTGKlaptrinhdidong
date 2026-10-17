import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exam_provider.dart';
import '../widgets/mobile_device_frame.dart';
import 'exam_taking_screen.dart';
import 'exam_result_screen.dart';
import 'exam_management_screen.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen({super.key});

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'ALL'; // 'ALL', 'ACTIVE', 'LOCKED'
  int _activeTabIndex = 0; // 0: Đề thi, 1: Kết quả, 2: Bí kíp, 3: Tài khoản

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<ExamProvider>().fetchExams();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();

    final filteredExams = provider.exams.where((e) {
      if (_selectedFilter == 'ACTIVE' && !e.isPublished) return false;
      if (_selectedFilter == 'LOCKED' && e.isPublished) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return e.title.toLowerCase().contains(query) ||
            e.description.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    // Mobile App Scaffold
    final mobileAppContent = Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildMobileAppBar(context),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _activeTabIndex,
              children: [
                _buildPracticeTab(context, provider, filteredExams),
                _buildResultsTab(context, provider),
                _buildGuideTab(),
                _buildProfileTab(context),
              ],
            ),
      bottomNavigationBar: _buildMobileBottomNav(),
    );

    // Wrap with realistic Mobile Device Frame on Desktop
    return MobileDeviceFrame(
      appTitle: 'Readora TOEIC Student App',
      child: mobileAppContent,
    );
  }

  // 1. Mobile App Top Bar
  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF2563EB),
                child: const Text(
                  'JL',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),

              // Title
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào, Jamie Lin 👋',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Sinh viên · TOEIC Reading',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),

              // Teacher Web Portal Link Shortcut
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExamManagementScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_rounded, size: 14, color: Color(0xFF2563EB)),
                      SizedBox(width: 4),
                      Text(
                        'Web GV',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Notification bell with red badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 22),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Mobile Bottom Navigation Bar (4 Native Mobile Tabs)
  Widget _buildMobileBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(0, Icons.menu_book_rounded, 'Luyện đề'),
              _buildBottomNavItem(1, Icons.insights_rounded, 'Kết quả'),
              _buildBottomNavItem(2, Icons.lightbulb_rounded, 'Bí kíp'),
              _buildBottomNavItem(3, Icons.person_rounded, 'Tài khoản'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = _activeTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Tab 1: Luyện đề (Practice Tests - Mobile First)
  Widget _buildPracticeTab(BuildContext context, ExamProvider provider, List<dynamic> exams) {
    final activeCount = provider.exams.where((e) => e.isPublished).length;
    final lockedCount = provider.exams.where((e) => !e.isPublished).length;

    return RefreshIndicator(
      onRefresh: () => provider.fetchExams(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        children: [
          // Mobile Hero Card
          _buildMobileHeroBanner(),

          const SizedBox(height: 16),

          // Mobile Search Box
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm đề thi TOEIC...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tất cả (${provider.exams.length})', 'ALL'),
                const SizedBox(width: 8),
                _buildFilterChip('🟢 Đang mở ca ($activeCount)', 'ACTIVE'),
                const SizedBox(width: 8),
                _buildFilterChip('🔒 Đã đóng ($lockedCount)', 'LOCKED'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách đề thi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                '${exams.length} đề thi',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Exam Cards List
          if (exams.isEmpty)
            _buildEmptyState()
          else
            ...exams.map((exam) => _buildMobileExamCard(context, exam)),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String filterKey) {
    final isSelected = _selectedFilter == filterKey;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = filterKey),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'ETS TOEIC READING 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              const Text(
                '75 Phút',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Luyện thi TOEIC Reading\nChuẩn định dạng ETS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Làm bài thi thử có bấm giờ, chấm điểm tự động và xem lại lời giải chi tiết.',
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.3),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildMiniHeroTag('100 câu'),
              const SizedBox(width: 6),
              _buildMiniHeroTag('Part 5, 6, 7'),
              const SizedBox(width: 6),
              _buildMiniHeroTag('Chấm điểm tức thì'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniHeroTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, color: Color(0xFF6EE7B7), size: 11),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 4. Mobile Exam Card (Designed for Smartphone)
  Widget _buildMobileExamCard(BuildContext context, dynamic exam) {
    final bool isPublished = exam.isPublished;
    final bool isOfficial05 = exam.id == 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPublished ? (isOfficial05 ? const Color(0xFF93C5FD) : Colors.grey.shade200) : Colors.grey.shade200,
          width: isPublished && isOfficial05 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Title + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isPublished
                      ? (isOfficial05 ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9))
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isPublished ? Icons.assignment_rounded : Icons.lock_clock_rounded,
                  color: isPublished
                      ? (isOfficial05 ? const Color(0xFF2563EB) : const Color(0xFF64748B))
                      : const Color(0xFF94A3B8),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isPublished ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Status Badge
                    if (isPublished)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 10, color: Color(0xFF166534)),
                            SizedBox(width: 4),
                            Text(
                              '🟢 Đang mở ca thi (Live)',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_rounded, size: 10, color: Color(0xFFDC2626)),
                            SizedBox(width: 4),
                            Text(
                              '🔒 Ca thi đang đóng (Inactive)',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            isPublished
                ? exam.description
                : '${exam.description} • [Giáo viên chưa kích hoạt ca thi này]',
            style: TextStyle(
              fontSize: 12,
              color: isPublished ? Colors.grey.shade600 : Colors.grey.shade400,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 10),

          // Meta row
          Row(
            children: [
              _buildMobileTag(Icons.timer_outlined, '${exam.durationMinutes} phút'),
              const SizedBox(width: 12),
              _buildMobileTag(Icons.help_outline_rounded, '${exam.totalQuestions} câu'),
              const SizedBox(width: 12),
              _buildMobileTag(Icons.auto_stories_rounded, 'Parts 5, 6, 7'),
            ],
          ),

          const SizedBox(height: 14),

          // Full-width Mobile Touch Action Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: isPublished
                ? ElevatedButton.icon(
                    onPressed: () async {
                      final success = await context.read<ExamProvider>().startExam(exam.id);
                      if (success && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExamTakingScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('BẮT ĐẦU LÀM BÀI ➜', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _showExamLockedDialog(context, exam.title),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: const Color(0xFFF8FAFC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.lock_outline_rounded, size: 16, color: Color(0xFF94A3B8)),
                    label: const Text('🔒 Ca thi chưa mở (Chờ GV kích hoạt)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTag(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // 5. Tab 2: Kết quả (My Results - Mobile First)
  Widget _buildResultsTab(BuildContext context, ExamProvider provider) {
    final hasLiveResult = provider.lastResult != null;
    final score = hasLiveResult ? provider.lastResult!.score : 395;
    final correct = hasLiveResult ? provider.lastResult!.correctCount : 82;
    final wrong = hasLiveResult ? provider.lastResult!.wrongCount : 14;
    final skipped = hasLiveResult ? provider.lastResult!.skippedCount : 4;
    final timeStr = hasLiveResult
        ? '${provider.lastResult!.timeSpentSeconds ~/ 60}m ${provider.lastResult!.timeSpentSeconds % 60}s'
        : '68m 24s';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Kết quả bài thi gần nhất',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Theo dõi điểm số và phân tích chi tiết năng lực TOEIC Reading.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),

        // Score Card
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Circular Score Badge
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEFF6FF),
                    border: Border.all(color: const Color(0xFF3B82F6), width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score',
                        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFF1E40AF)),
                      ),
                      const Text(
                        '/ 495 PTS',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Trình độ: B2-C1 (Advanced Proficiency)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'TOEIC Reading Test 05 (ETS Official)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),

                Text(
                  'Thời gian làm bài: $timeStr',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 18),

                // 2x2 Metric Grid
                Row(
                  children: [
                    Expanded(child: _buildResultTile('Đúng', '$correct câu', const Color(0xFF10B981), const Color(0xFFDCFCE7))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildResultTile('Sai', '$wrong câu', const Color(0xFFEF4444), const Color(0xFFFEE2E2))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildResultTile('Bỏ qua', '$skipped câu', const Color(0xFF64748B), const Color(0xFFF1F5F9))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildResultTile('Độ chính xác', '${(correct / 100 * 100).round()}%', const Color(0xFF2563EB), const Color(0xFFEFF6FF))),
                  ],
                ),

                const SizedBox(height: 18),

                if (hasLiveResult)
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ExamResultScreen(result: provider.lastResult!)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.list_alt_rounded, size: 18),
                      label: const Text('Xem Lại Toàn Bộ Đáp Án', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // History
        const Text(
          'Lịch sử làm bài trước đây',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 10),
        _buildMobileHistoryItem('Test 05 - ETS Official', '395 / 495', 'Hôm nay, 16:30', 'Đúng 82/100'),
        _buildMobileHistoryItem('Test 01 - ETS 2024', '360 / 495', '12/10/2026', 'Đúng 74/100'),
        _buildMobileHistoryItem('Test 02 - Economy RC', '385 / 495', '05/10/2026', 'Đúng 80/100'),
      ],
    );
  }

  Widget _buildResultTile(String label, String value, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: textColor.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMobileHistoryItem(String title, String score, String date, String detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                Text('$date · $detail', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
            child: Text(score, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E40AF))),
          ),
        ],
      ),
    );
  }

  // 6. Tab 3: Bí kíp (Study Guide - Mobile First)
  Widget _buildGuideTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Bí kíp phân bổ thời gian',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 4),
        Text(
          'Chiến thuật làm bài chuẩn 75 phút cho 100 câu TOEIC Reading.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 14),

        // Pacing Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timer_outlined, color: Color(0xFF2563EB), size: 20),
                  SizedBox(width: 8),
                  Text('Mục tiêu tốc độ lý tưởng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E40AF))),
                ],
              ),
              SizedBox(height: 8),
              Text('• Part 5: 10-12 phút (30 giây/câu)', style: TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('• Part 6: 8-10 phút (40 giây/câu)', style: TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text('• Part 7: 50-55 phút (1 phút/câu)', style: TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildGuideCardMobile('Part 5: Incomplete Sentences', '30 câu (101-130)', 'Nhận diện từ loại trước. Xác định chủ ngữ, vị ngữ để chọn nhanh đáp án ngữ pháp trong 20s.'),
        _buildGuideCardMobile('Part 6: Text Completion', '16 câu (131-146)', 'Đọc lướt cả đoạn để hiểu ngữ cảnh. Chú ý các từ nối (However, Therefore) để chọn câu điền phù hợp.'),
        _buildGuideCardMobile('Part 7: Reading Comprehension', '54 câu (147-200)', 'Đọc câu hỏi trước khi đọc văn bản. Tìm từ khóa và đối chiếu đoạn văn tương ứng để tránh đọc lại nhiều lần.'),
      ],
    );
  }

  Widget _buildGuideCardMobile(String title, String count, String tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text(count, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(tip, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
        ],
      ),
    );
  }

  // 7. Tab 4: Tài khoản (Profile)
  Widget _buildProfileTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: Color(0xFF2563EB),
                child: Text('JL', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              const Text('Jamie Lin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 4),
              const Text('Mã sinh viên: 2380600189', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('LMS Gateway: Online & Synced (18ms)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        _buildProfileTile(Icons.school_rounded, 'Lớp học', 'TOEIC Reading Intensive - Học kỳ 1 2025-2026'),
        _buildProfileTile(Icons.room_rounded, 'Phòng thi đề xuất', 'Phòng Lab Máy Tính A3.04'),
        _buildProfileTile(Icons.security_rounded, 'Bảo mật ca thi', 'Xác thực tài khoản sinh viên hợp lệ'),

        const SizedBox(height: 24),

        // Direct button to Portal Web
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamManagementScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.laptop_chromebook_rounded, size: 20),
            label: const Text('MỞ WEB QUẢN TRỊ GIÁO VIÊN (STITCH)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showExamLockedDialog(BuildContext context, String examTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock_clock_rounded, color: Color(0xFFDC2626), size: 24),
            SizedBox(width: 8),
            Text('Ca thi chưa được kích hoạt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đề thi "$examTitle" hiện đang ở trạng thái Inactive / Draft.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFFDC2626), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Giáo viên cần bật "Active for Students" trên Web Portal thì sinh viên mới có thể vào làm bài.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF991B1B)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đã hiểu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamManagementScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Mở Web Giáo Viên để Kích Hoạt', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              'Không tìm thấy đề thi phù hợp "$_searchQuery"',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
