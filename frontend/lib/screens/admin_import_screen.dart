import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/toeic_test_05_data.dart';
import '../models/exam.dart';
import '../providers/exam_provider.dart';
import 'admin_edit_screen.dart';

class AdminImportScreen extends StatefulWidget {
  const AdminImportScreen({super.key});

  @override
  State<AdminImportScreen> createState() => _AdminImportScreenState();
}

class _AdminImportScreenState extends State<AdminImportScreen> {
  final String _fileName = 'Reading v05.docx';
  final String _fileSize = '4.2 MB';
  bool _activateSession = true;
  String _difficulty = 'Intermediate';

  final TextEditingController _titleController = TextEditingController(
    text: 'TOEIC Reading Test 05 (ETS Official)',
  );
  final TextEditingController _timeController = TextEditingController(text: '75 minutes');

  Exam? _parsedExam;

  @override
  void initState() {
    super.initState();
    _parsedExam = ToeicTest05Data.getExam();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveAndPublish() {
    if (_parsedExam == null) return;

    final provider = Provider.of<ExamProvider>(context, listen: false);
    final examToSave = Exam(
      id: _parsedExam!.id,
      title: _titleController.text.trim().isEmpty ? _parsedExam!.title : _titleController.text.trim(),
      description: _parsedExam!.description,
      durationMinutes: 75,
      totalQuestions: 100,
      isPublished: _activateSession,
      questions: _parsedExam!.questions,
      passages: _parsedExam!.passages,
    );

    provider.addOrUpdateExam(examToSave);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Published "${examToSave.title}" successfully with 100 questions!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View Library',
          textColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. Readora Admin Top Bar (Figma Style)
          _buildAdminTopBar(context),

          // Main Scrollable Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Exam library',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text('  /  ', style: TextStyle(color: Colors.grey.shade400)),
                          const Text(
                            'New exam',
                            style: TextStyle(color: Color(0xFF1E40AF), fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title & Subtitle
                      const Text(
                        'From document to exam, in minutes.',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Upload your TOEIC Reading paper. We will organize the questions, passages, and answer key.',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),

                      // 2. Stepper (Figma Style)
                      _buildStepper(),

                      const SizedBox(height: 32),

                      // 3. Two-Column Layout (Figma Style)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column: Upload document & Exam details (Flex 6)
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                _buildExamDocumentCard(),
                                const SizedBox(height: 24),
                                _buildExamDetailsCard(),
                              ],
                            ),
                          ),

                          const SizedBox(width: 24),

                          // Right Column: Ready for review & Activate session (Flex 4)
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                _buildReadyForReviewCard(context),
                                const SizedBox(height: 24),
                                _buildActivateSessionCard(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTopBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Logo Readora
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Readora',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // ADMIN WORKSPACE Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'ADMIN WORKSPACE',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
          ),

          const SizedBox(width: 36),

          // Navigation Links
          _buildAdminNavLink('Overview', false),
          _buildAdminNavLink('Exam library', true),
          _buildAdminNavLink('Learners', false),
          _buildAdminNavLink('Reports', false),

          const Spacer(),

          // Notification icon
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF64748B)),
            onPressed: () {},
          ),

          const SizedBox(width: 12),

          // Avatar Alex Lee
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFF1E40AF),
                child: const Text('AL', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              const Text(
                'Alex Lee',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF64748B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminNavLink(String title, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: active ? FontWeight.bold : FontWeight.w500,
          color: active ? const Color(0xFF1E40AF) : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStepItem('1', 'Upload document', true, true),
        _buildStepConnector(true),
        _buildStepItem('2', 'Review parsed content', true, false),
        _buildStepConnector(false),
        _buildStepItem('3', 'Publish exam', false, false),
      ],
    );
  }

  Widget _buildStepItem(String number, String label, bool isActive, bool isDone) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1E40AF) : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF0F172A) : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 48,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: isActive ? const Color(0xFF1E40AF) : Colors.grey.shade300,
    );
  }

  Widget _buildExamDocumentCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Exam document',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '.DOCX ONLY',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dropzone Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF1E40AF), size: 28),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Drop your Word document here',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  'or browse files · .docx format up to 25 MB',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text('Browse files', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Uploaded file item (Figma style)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_rounded, color: Color(0xFF1E40AF), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fileName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        '$_fileSize · Uploaded just now',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 14, color: Color(0xFF166534)),
                      SizedBox(width: 4),
                      Text(
                        'Parsed successfully',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildExamDetailsCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exam details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 16),

          // Exam Title field
          const Text('Exam title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(height: 16),

          // Difficulty & Time limit row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Difficulty', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _difficulty,
                          isExpanded: true,
                          items: ['Beginner', 'Intermediate', 'Advanced']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (val) => setState(() => _difficulty = val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Time limit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildReadyForReviewCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ready for review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 20),
            ],
          ),
          const SizedBox(height: 16),

          // Big number 100
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                '100',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              ),
              const SizedBox(width: 8),
              Text(
                'questions detected',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const Divider(height: 32),

          // Breakdown rows
          _buildBreakdownRow('Part 5', 'Incomplete sentences', '30 Qs', '101-130'),
          const SizedBox(height: 12),
          _buildBreakdownRow('Part 6', 'Text completion', '16 Qs', '131-146'),
          const SizedBox(height: 12),
          _buildBreakdownRow('Part 7', 'Reading comprehension', '54 Qs', '147-200'),
          const Divider(height: 32),

          // Green check confirmations
          Row(
            children: [
              const Icon(Icons.check, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              const Text('100 answer keys matched', style: TextStyle(fontSize: 13, color: Color(0xFF166534), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.check, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              const Text('19 passages linked · No issues found', style: TextStyle(fontSize: 13, color: Color(0xFF166534), fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 20),

          // Review & edit button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminEditScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              icon: const Icon(Icons.edit_note, size: 18, color: Color(0xFF0F172A)),
              label: const Text(
                'Review & edit questions',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBreakdownRow(String part, String name, String count, String range) {
    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(part, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
        ),
        Expanded(
          child: Text(name, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
            Text(range, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
          ],
        ),
      ],
    );
  }

  Widget _buildActivateSessionCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activate exam session',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Make this exam available to learners as soon as it is published.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _activateSession,
                activeThumbColor: const Color(0xFF10B981),
                onChanged: (val) => setState(() => _activateSession = val),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Primary button: Save & Publish Exam
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveAndPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: const Icon(Icons.rocket_launch_rounded, size: 18),
              label: const Text(
                'Save & Publish Exam',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
