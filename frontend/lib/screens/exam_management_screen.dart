import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exam_provider.dart';
import 'admin_import_screen.dart';
import 'admin_edit_screen.dart';

class ExamManagementScreen extends StatefulWidget {
  const ExamManagementScreen({super.key});

  @override
  State<ExamManagementScreen> createState() => _ExamManagementScreenState();
}

class _ExamManagementScreenState extends State<ExamManagementScreen> {
  String _activeTab = 'ALL'; // ALL, ACTIVE, DRAFT
  String _searchQuery = '';
  int _activeNav = 1; // 0: Dashboard, 1: Exam Management, 2: Question Bank, 3: Analytics

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();
    final exams = provider.exams;

    final activeCount = exams.where((e) => e.isPublished).length;
    final draftCount = exams.where((e) => !e.isPublished).length;
    final totalExams = exams.length;
    final totalQuestions = exams.fold<int>(0, (sum, e) => sum + e.totalQuestions);

    final filteredExams = exams.where((e) {
      if (_activeTab == 'ACTIVE' && !e.isPublished) return false;
      if (_activeTab == 'DRAFT' && e.isPublished) return false;
      if (_searchQuery.isNotEmpty && !e.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Google Stitch Top Navbar
            _buildTopNavBar(context),

            // 2. Main Content Area
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1380),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb & Status Row
                      _buildHeaderSection(),

                      const SizedBox(height: 24),

                      // 4 Summary Metrics Cards
                      _buildMetricsRow(totalExams, activeCount, draftCount, totalQuestions),

                      const SizedBox(height: 28),

                      // Filter & Action Bar
                      _buildFilterAndActionBar(context, totalExams, activeCount, draftCount),

                      const SizedBox(height: 20),

                      // Exam Data Table (Stitch Style)
                      _buildExamTable(context, filteredExams, provider),

                      const SizedBox(height: 20),

                      // Pagination Row
                      _buildPaginationRow(filteredExams.length, exams.length),

                      const SizedBox(height: 28),

                      // Proctor Tip Banner
                      _buildProctorTip(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Logo & Subtitle
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOEIC Exam Portal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Academic Examination System',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(width: 40),

          // Nav Tabs
          _buildNavTab('Dashboard', 0),
          _buildNavTab('Exam Management', 1),
          _buildNavTab('Question Bank', 2),
          _buildNavTab('Analytics', 3),

          const Spacer(),

          // Academic year badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF2563EB)),
                SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Academic year', style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                    Text('2025-2026', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Date & Time
          const Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
              SizedBox(width: 6),
              Text(
                'Thursday, Oct 22, 2026',
                style: TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Notifications
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF64748B), size: 20),
            onPressed: () {},
          ),

          const SizedBox(width: 8),

          // Switch to Student App View
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            icon: const Icon(Icons.phone_android_rounded, size: 16, color: Color(0xFF2563EB)),
            label: const Text(
              'Giao diện Sinh viên (App)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ),

          const SizedBox(width: 16),

          // Profile: Dr. Admin
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF3B82F6),
                child: const Text('DA', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dr. Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Text('Professor / Coordinator', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab(String title, int index) {
    final isActive = _activeNav == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() => _activeNav = index);
          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEditScreen()));
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: isActive ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.home_outlined, size: 15, color: Color(0xFF64748B)),
            const SizedBox(width: 4),
            Text('Dashboard', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 15, color: Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            const Text(
              'Exam Management',
              style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Exam Management',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.5),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Fall Session 2026',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                  ),
                ),
              ],
            ),

            // System Status chip (Stitch style)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'System Status: Online & Synced',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LMS Gateway Latency: 18ms',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.sync_rounded, size: 20, color: Color(0xFF64748B)),
                  tooltip: 'Sync now',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('LMS System is fully synced with mobile student endpoints!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Create, organize, and manage student access to your TOEIC Reading exams.',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(int totalExams, int activeExams, int draftExams, int totalQuestions) {
    return Row(
      children: [
        // Card 1: Total Exams
        _buildMetricCard(
          badge: 'REGISTRY',
          badgeColor: const Color(0xFFF1F5F9),
          badgeTextColor: const Color(0xFF64748B),
          icon: Icons.folder_open_rounded,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          value: '$totalExams',
          unit: 'Curricula',
          title: 'Total Exams',
          subtitle: 'All created modules',
          footerLeft: 'Capacity: 20 Slots',
          footerRight: '10% Used',
        ),
        const SizedBox(width: 18),

        // Card 2: Active Exams
        _buildMetricCard(
          badge: '+1 this semester',
          badgeColor: const Color(0xFFDCFCE7),
          badgeTextColor: const Color(0xFF166534),
          icon: Icons.check_circle_outline_rounded,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF10B981),
          value: '$activeExams',
          unit: 'Live',
          title: 'Active Exams',
          subtitle: 'Currently accessible by students',
          footerLeft: 'Active Cohorts',
          footerRight: '142 Candidates',
        ),
        const SizedBox(width: 18),

        // Card 3: Draft Exams
        _buildMetricCard(
          badge: 'Under review',
          badgeColor: const Color(0xFFF1F5F9),
          badgeTextColor: const Color(0xFF64748B),
          icon: Icons.edit_note_rounded,
          iconBg: const Color(0xFFF1F5F9),
          iconColor: const Color(0xFF64748B),
          value: '$draftExams',
          unit: 'Staged',
          title: 'Draft Exams',
          subtitle: 'Pending student release',
          footerLeft: 'Approval Workflow',
          footerRight: 'Dept Head (1/2)',
        ),
        const SizedBox(width: 18),

        // Card 4: Total Questions
        _buildMetricCard(
          badge: '100% Item-Bank',
          badgeColor: const Color(0xFFEFF6FF),
          badgeTextColor: const Color(0xFF1E40AF),
          icon: Icons.description_outlined,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF1E40AF),
          value: '$totalQuestions',
          unit: 'Items',
          title: 'Total Questions',
          subtitle: 'Verified question items',
          footerLeft: 'Parts 5, 6, 7',
          footerRight: 'ETS Standardized',
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String unit,
    required String title,
    required String subtitle,
    required String footerLeft,
    required String footerRight,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextColor)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                  const SizedBox(width: 6),
                  Text(unit, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                ],
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(footerLeft, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  Text(footerRight, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterAndActionBar(BuildContext context, int total, int active, int draft) {
    return Row(
      children: [
        // Search Input
        SizedBox(
          width: 260,
          height: 42,
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search exam title...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Filter Tabs: All, Active, Draft
        _buildFilterTabButton('All', '$total', 'ALL'),
        _buildFilterTabButton('Active', '$active', 'ACTIVE'),
        _buildFilterTabButton('Draft', '$draft', 'DRAFT'),

        const Spacer(),

        // Export Registry button
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registry exported to CSV successfully!')),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          icon: const Icon(Icons.file_download_outlined, size: 18, color: Color(0xFF334155)),
          label: const Text('Export Registry', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        ),

        const SizedBox(width: 12),

        // Primary: + Import from Word (.docx)
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminImportScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          icon: const Icon(Icons.upload_file_rounded, size: 18),
          label: const Text(
            '+ Import from Word (.docx)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabButton(String label, String count, String tabKey) {
    final isSelected = _activeTab == tabKey;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => setState(() => _activeTab = tabKey),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamTable(BuildContext context, List<dynamic> exams, ExamProvider provider) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Table Headers
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 4, child: Text('EXAM TITLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text('QUESTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text('TIME LIMIT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text('CREATED DATE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                Expanded(flex: 3, child: Text('STUDENT ACCESS (SESSION STATUS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                SizedBox(width: 120, child: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
              ],
            ),
          ),

          // Table Rows
          if (exams.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('Không có đề thi nào phù hợp')),
            )
          else
            ...exams.map((exam) => _buildTableRow(context, exam, provider)),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, dynamic exam, ExamProvider provider) {
    final bool isSessionActive = exam.isPublished;
    final isTest05 = exam.id == 5;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // Exam Title & Badges
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isTest05 ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isTest05 ? Icons.assignment_rounded : Icons.drafts_rounded,
                    color: isTest05 ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('100 reading questions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                          ),
                          Text(
                            isTest05 ? 'ETS Official Format · Parts 5, 6, 7' : 'Practice Archive · Parts 5, 6, 7',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.description_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  '${exam.totalQuestions}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),

          // Time limit
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  '${exam.durationMinutes} mins',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),

          // Created date
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Text(
                  isTest05 ? '17/10/2026' : '10/10/2026',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                ),
              ],
            ),
          ),

          // STUDENT ACCESS (SESSION STATUS) - TOGGLE SWITCH (Stitch Style)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Switch(
                      value: isSessionActive,
                      activeThumbColor: const Color(0xFF10B981),
                      activeTrackColor: const Color(0xFFA7F3D0),
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade200,
                      onChanged: (val) {
                        provider.toggleExamPublish(exam.id, val);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: val ? const Color(0xFF10B981) : const Color(0xFF64748B),
                            duration: const Duration(seconds: 2),
                            content: Text(
                              val
                                  ? 'Đã KÍCH HOẠT CA THI "${exam.title}"! Sinh viên có thể vào thi ngay.'
                                  : 'Đã đóng ca thi "${exam.title}" (Chuyển sang Inactive/Draft).',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isSessionActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSessionActive ? const Color(0xFF166534) : Colors.grey.shade500,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isSessionActive ? 'Active for Students' : 'Inactive / Draft',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSessionActive ? const Color(0xFF166534) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  child: Text(
                    isSessionActive ? 'Live session open for 142 enrolled students' : 'Hidden from student portal',
                    style: TextStyle(fontSize: 11, color: isSessionActive ? const Color(0xFF15803D) : Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),

          // ACTIONS (query_stats, edit, delete)
          SizedBox(
            width: 120,
            child: Row(
              children: [
                if (isTest05)
                  IconButton(
                    icon: const Icon(Icons.query_stats_rounded, size: 20, color: Color(0xFF2563EB)),
                    tooltip: 'Analytics & Score Results',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Viewing live test analytics for Test 05...')),
                      );
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF475569)),
                  tooltip: 'Edit Questions',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminEditScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFEF4444)),
                  tooltip: 'Delete Exam',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cannot delete active benchmark test.')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationRow(int showing, int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 1-$showing of $total exams',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Row(
          children: [
            Text('Rows per page: 10', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(width: 16),
            IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: () {}),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildProctorTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF2563EB), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Proctor Tip: Instant Access Control',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(4)),
                      child: const Text('Real-Time Sync', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Toggling "Student Access" enables or disables instant access for students enrolled in your TOEIC Reading course in real-time. Unauthorized attempts are redirected to an advisory waiting screen with timed countdown security.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
