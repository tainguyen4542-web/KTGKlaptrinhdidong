import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/toeic_test_05_data.dart';
import '../models/choice.dart';
import '../models/question.dart';
import '../providers/exam_provider.dart';

class AdminEditScreen extends StatefulWidget {
  const AdminEditScreen({super.key});

  @override
  State<AdminEditScreen> createState() => _AdminEditScreenState();
}

class _AdminEditScreenState extends State<AdminEditScreen> {
  int _selectedPart = 0; // 0: All, 5: Part 5, 6: Part 6, 7: Part 7
  String _searchQuery = '';
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    final exam = ToeicTest05Data.getExam();
    _questions = List.from(exam.questions);
  }

  List<Question> get _filteredQuestions {
    return _questions.where((q) {
      final matchPart = _selectedPart == 0 || q.part == _selectedPart;
      final matchSearch = _searchQuery.isEmpty ||
          q.questionNumber.toString().contains(_searchQuery) ||
          q.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchPart && matchSearch;
    }).toList();
  }

  void _openEditDialog(Question q) {
    final contentCtrl = TextEditingController(text: q.content);
    final expCtrl = TextEditingController(text: q.explanation ?? '');
    
    final aCtrl = TextEditingController(text: q.choices.isNotEmpty ? q.choices[0].content : '');
    final bCtrl = TextEditingController(text: q.choices.length > 1 ? q.choices[1].content : '');
    final cCtrl = TextEditingController(text: q.choices.length > 2 ? q.choices[2].content : '');
    final dCtrl = TextEditingController(text: q.choices.length > 3 ? q.choices[3].content : '');

    String correctLabel = 'A';
    for (var c in q.choices) {
      if (c.isCorrect) {
        correctLabel = c.label;
        break;
      }
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dialog Header (Figma style)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit question ${q.questionNumber}',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Part ${q.part} · ${q.part == 5 ? "Incomplete sentences" : q.part == 6 ? "Text completion" : "Reading comprehension"}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                        const Divider(height: 28),

                        // Question Content Field
                        const Text('Question content', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: contentCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Answer choices
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Answer choices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                            Text('Select the radio for the correct answer', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        _buildChoiceOption('A', aCtrl, correctLabel, (val) => setDialogState(() => correctLabel = val!)),
                        const SizedBox(height: 8),
                        _buildChoiceOption('B', bCtrl, correctLabel, (val) => setDialogState(() => correctLabel = val!)),
                        const SizedBox(height: 8),
                        _buildChoiceOption('C', cCtrl, correctLabel, (val) => setDialogState(() => correctLabel = val!)),
                        const SizedBox(height: 8),
                        _buildChoiceOption('D', dCtrl, correctLabel, (val) => setDialogState(() => correctLabel = val!)),
                        const SizedBox(height: 20),

                        // Explanation / Passage
                        const Text('Explanation / Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF334155))),
                        const SizedBox(height: 6),
                        TextField(
                          controller: expCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Bottom Action Bar
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '✓ Correct answer: $correctLabel',
                                style: const TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                final updatedQ = Question(
                                  id: q.id,
                                  questionNumber: q.questionNumber,
                                  part: q.part,
                                  passageId: q.passageId,
                                  content: contentCtrl.text.trim(),
                                  explanation: expCtrl.text.trim(),
                                  choices: [
                                    Choice(id: 1, label: 'A', content: aCtrl.text.trim(), isCorrect: correctLabel == 'A'),
                                    Choice(id: 2, label: 'B', content: bCtrl.text.trim(), isCorrect: correctLabel == 'B'),
                                    Choice(id: 3, label: 'C', content: cCtrl.text.trim(), isCorrect: correctLabel == 'C'),
                                    Choice(id: 4, label: 'D', content: dCtrl.text.trim(), isCorrect: correctLabel == 'D'),
                                  ],
                                );

                                setState(() {
                                  final idx = _questions.indexWhere((item) => item.id == q.id);
                                  if (idx >= 0) {
                                    _questions[idx] = updatedQ;
                                  }
                                });

                                Provider.of<ExamProvider>(context, listen: false).updateQuestionInCurrentExam(updatedQ);

                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFF10B981),
                                    content: Text('Updated question #${q.questionNumber} successfully!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E40AF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Save question', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChoiceOption(
    String label,
    TextEditingController controller,
    String selectedLabel,
    ValueChanged<String?> onChanged,
  ) {
    final isSelected = selectedLabel == label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => onChanged(label),
            child: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF1E40AF) : Colors.grey.shade400,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Enter choice content...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredQuestions;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. Readora Admin Top Bar
          _buildAdminHeader(context),

          // Main content
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
                            child: Text('Exam library', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          ),
                          Text('  /  ', style: TextStyle(color: Colors.grey.shade400)),
                          Text('Practice Test 05', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                          Text('  /  ', style: TextStyle(color: Colors.grey.shade400)),
                          const Text('Questions', style: TextStyle(color: Color(0xFF1E40AF), fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title & Subtitle
                      const Text(
                        'Fine-tune every question',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'TOEIC Reading - Practice Test 05 · 100 questions detected',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 24),

                      // Filter Tabs & Search row
                      Row(
                        children: [
                          _buildFilterTab('All parts · 100', 0),
                          const SizedBox(width: 8),
                          _buildFilterTab('Part 5 · 30', 5),
                          const SizedBox(width: 8),
                          _buildFilterTab('Part 6 · 16', 6),
                          const SizedBox(width: 8),
                          _buildFilterTab('Part 7 · 54', 7),
                          const Spacer(),
                          SizedBox(
                            width: 260,
                            height: 38,
                            child: TextField(
                              onChanged: (val) => setState(() => _searchQuery = val),
                              decoration: InputDecoration(
                                hintText: 'Search questions...',
                                hintStyle: const TextStyle(fontSize: 12),
                                prefixIcon: const Icon(Icons.search, size: 18),
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Questions Table (Figma Style)
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(width: 70, child: Text('QUESTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                                  SizedBox(width: 80, child: Text('PART', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                                  Expanded(child: Text('CONTENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                                  SizedBox(width: 80, child: Text('ANSWER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                                  SizedBox(width: 60, child: Text('EDIT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)))),
                                ],
                              ),
                            ),

                            // Table Rows
                            ...filtered.map((q) => _buildTableRow(q)),
                          ],
                        ),
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

  Widget _buildAdminHeader(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: const Color(0xFF1E40AF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Readora', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
            child: const Text('ADMIN WORKSPACE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int part) {
    final isSelected = _selectedPart == part;
    return InkWell(
      onTap: () => setState(() => _selectedPart = part),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF1E40AF) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(Question q) {
    String ans = 'A';
    for (var c in q.choices) {
      if (c.isCorrect) ans = c.label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '${q.questionNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF), fontSize: 13),
            ),
          ),
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
              child: Text(
                'Part ${q.part}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
              ),
            ),
          ),
          Expanded(
            child: Text(
              q.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
            ),
          ),
          SizedBox(
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                ans,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1E40AF)),
              onPressed: () => _openEditDialog(q),
              tooltip: 'Edit question',
            ),
          ),
        ],
      ),
    );
  }
}
