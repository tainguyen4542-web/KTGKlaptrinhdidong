import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exam.dart';
import '../models/passage.dart';
import '../models/question.dart';
import '../models/choice.dart';
import '../data/toeic_test_05_data.dart';

class ApiService {
  // ASP.NET Core Boilerplate default backend URL
  static const String baseUrl = 'http://localhost:5000/api';

  Future<List<Exam>> getExams() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/services/app/Exam/GetPublishedExams'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['result'] as List;
        return items.map((e) => Exam.fromJson(e)).toList();
      }
    } catch (_) {
      // If backend is not yet started, smoothly return realistic Mock Exams
    }
    return _getMockExams();
  }

  Future<Exam> getExamDetail(int examId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/services/app/Exam/GetExamDetail?id=$examId'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Exam.fromJson(data['result']);
      }
    } catch (_) {
      // Fallback to mock exam detail
    }
    return _getMockExamDetail(examId);
  }

  // Realistic mock data matching the PDF đề thi sample
  List<Exam> _getMockExams() {
    return [
      Exam(
        id: 5,
        title: 'TOEIC Reading Test 05 (ETS Official)',
        description: 'Đề thi chuẩn TOEIC Reading 100 câu: Part 5 (30 câu), Part 6 (16 câu), Part 7 (54 câu) - Bóc tách từ Reading v05.docx',
        durationMinutes: 75,
        totalQuestions: 100,
        isPublished: true,
      ),
      Exam(
        id: 1,
        title: 'TOEIC Reading Test 01 (Official ETS)',
        description: 'Đề thi chuẩn TOEIC Reading 100 câu: Part 5 (30 câu), Part 6 (16 câu), Part 7 (54 câu)',
        durationMinutes: 75,
        totalQuestions: 100,
        isPublished: false,
      ),
      Exam(
        id: 2,
        title: 'TOEIC Reading Test 02 (Economy RC)',
        description: 'Đề thi rèn luyện tốc độ đọc hiểu văn bản thương mại, email, báo cáo kinh doanh',
        durationMinutes: 75,
        totalQuestions: 100,
        isPublished: false,
      ),
    ];
  }

  Exam _getMockExamDetail(int examId) {
    if (examId == 5) {
      return ToeicTest05Data.getExam();
    }
    // Generate sample questions matching PDF page 1 exactly!
    final q101 = Question(
      id: 101,
      questionNumber: 101,
      part: 5,
      content: 'Ms. Durkin asked for volunteers to help -------- with the employee fitness program.',
      choices: [
        Choice(id: 1, label: 'A', content: 'she'),
        Choice(id: 2, label: 'B', content: 'her', isCorrect: true),
        Choice(id: 3, label: 'C', content: 'hers'),
        Choice(id: 4, label: 'D', content: 'herself'),
      ],
      explanation: 'Động từ "help" cần một tân ngữ theo sau. "Her" là tân ngữ phù hợp (help her with something). Đáp án đúng là B.',
    );

    final q102 = Question(
      id: 102,
      questionNumber: 102,
      part: 5,
      content: 'The new regional director will arrive in Tokyo -------- Monday morning to inspect the facility.',
      choices: [
        Choice(id: 5, label: 'A', content: 'at'),
        Choice(id: 6, label: 'B', content: 'on', isCorrect: true),
        Choice(id: 7, label: 'C', content: 'in'),
        Choice(id: 8, label: 'D', content: 'by'),
      ],
      explanation: 'Dùng giới từ "on" trước các buổi cụ thể trong ngày (on Monday morning). Đáp án đúng là B.',
    );

    final q103 = Question(
      id: 103,
      questionNumber: 103,
      part: 5,
      content: 'Customer service representatives are required to respond to email inquiries -------- within 24 hours.',
      choices: [
        Choice(id: 9, label: 'A', content: 'promptly', isCorrect: true),
        Choice(id: 10, label: 'B', content: 'prompt'),
        Choice(id: 11, label: 'C', content: 'promptness'),
        Choice(id: 12, label: 'D', content: 'prompted'),
      ],
      explanation: 'Cần một trạng từ bổ nghĩa cho động từ "respond". "Promptly" (nhanh chóng) là trạng từ. Đáp án đúng là A.',
    );

    // Part 6 Passage matching PDF screenshot Page 1
    final p131 = Passage(
      id: 1,
      title: 'Questions 131-134 refer to the following advertisement.',
      content: '''With Global Strength Gym's 30-day trial period, you get the opportunity to try out our classes, equipment, and facilities. ------- 131. It's completely risk-free! To sign up, we require your contact information and payment details, but you will only be charged if you are a member for ------- 132. 30 days. If you decide within this time that you no longer want to be a member of Global Strength, ------- 133. visit our Web site at www.gsgym.com. On the Membership page, elect to ------- 134. your membership and enter the necessary information. It's that easy!''',
      orderIndex: 1,
      questions: [
        Question(
          id: 131,
          questionNumber: 131,
          part: 6,
          passageId: 1,
          content: 'Questions 131',
          choices: [
            Choice(id: 13, label: 'A', content: 'Throughout the trial, you pay nothing and sign no contract.', isCorrect: true),
            Choice(id: 14, label: 'B', content: 'Weight-lifting classes are not currently available.'),
            Choice(id: 15, label: 'C', content: 'A cash deposit is required when you sign up for membership.'),
            Choice(id: 16, label: 'D', content: 'All questions should be e-mailed to customerservice@gsgym.com.'),
          ],
          explanation: 'Câu trước nói về thời gian dùng thử 30 ngày. Câu A hợp lý nhất vì nhấn mạnh không phải trả tiền trong thời gian dùng thử.',
        ),
        Question(
          id: 132,
          questionNumber: 132,
          part: 6,
          passageId: 1,
          content: 'Questions 132',
          choices: [
            Choice(id: 17, label: 'A', content: 'not even'),
            Choice(id: 18, label: 'B', content: 'almost'),
            Choice(id: 19, label: 'C', content: 'over', isCorrect: true),
            Choice(id: 20, label: 'D', content: 'less than'),
          ],
          explanation: '"over 30 days" có nghĩa là vượt quá 30 ngày (bạn chỉ bị tính phí nếu duy trì thành viên quá 30 ngày). Đáp án C.',
        ),
        Question(
          id: 133,
          questionNumber: 133,
          part: 6,
          passageId: 1,
          content: 'Questions 133',
          choices: [
            Choice(id: 21, label: 'A', content: 'justly'),
            Choice(id: 22, label: 'B', content: 'regularly'),
            Choice(id: 23, label: 'C', content: 'evenly'),
            Choice(id: 24, label: 'D', content: 'simply', isCorrect: true),
          ],
          explanation: '"simply visit our Web site" = chỉ cần truy cập trang web của chúng tôi. Đáp án D.',
        ),
        Question(
          id: 134,
          questionNumber: 134,
          part: 6,
          passageId: 1,
          content: 'Questions 134',
          choices: [
            Choice(id: 25, label: 'A', content: 'extend'),
            Choice(id: 26, label: 'B', content: 'renew'),
            Choice(id: 27, label: 'C', content: 'cancel', isCorrect: true),
            Choice(id: 28, label: 'D', content: 'initiate'),
          ],
          explanation: 'Nếu bạn quyết định không muốn tiếp tục làm thành viên nữa, chọn "cancel" (hủy) gói thành viên. Đáp án C.',
        ),
      ],
    );

    // Part 7 Passage
    final p147 = Passage(
      id: 2,
      title: 'Questions 147-148 refer to the following text message chain.',
      content: '''[10:14 AM] Mark Vance:
Hi Sandra, have you finalized the quarterly financial report for tomorrow's executive board meeting?

[10:17 AM] Sandra Lee:
Almost. I am still waiting for the sales numbers from the North American branch. Mr. Davies promised to email them by 11:00 AM.

[10:20 AM] Mark Vance:
Great. As soon as you integrate those figures, please send a PDF copy to my inbox so I can review it before the presentation.''',
      orderIndex: 2,
      questions: [
        Question(
          id: 147,
          questionNumber: 147,
          part: 7,
          passageId: 2,
          content: 'What is the purpose of the quarterly report?',
          choices: [
            Choice(id: 29, label: 'A', content: 'To request additional funding for marketing'),
            Choice(id: 30, label: 'B', content: 'For an upcoming executive board meeting', isCorrect: true),
            Choice(id: 31, label: 'C', content: 'To evaluate employee job performance'),
            Choice(id: 32, label: 'D', content: 'To open a new branch in North America'),
          ],
          explanation: 'Mark Vance nhắc đến "for tomorrow\'s executive board meeting". Đáp án đúng là B.',
        ),
        Question(
          id: 148,
          questionNumber: 148,
          part: 7,
          passageId: 2,
          content: 'What is Sandra Lee waiting for?',
          choices: [
            Choice(id: 33, label: 'A', content: 'Regional sales data', isCorrect: true),
            Choice(id: 34, label: 'B', content: 'A revised meeting schedule'),
            Choice(id: 35, label: 'C', content: 'Approval from Mr. Vance'),
            Choice(id: 36, label: 'D', content: 'Printed copies of a presentation'),
          ],
          explanation: 'Sandra nói "I am still waiting for the sales numbers from the North American branch". Đáp án đúng là A.',
        ),
      ],
    );

    // Aggregate all questions
    final allQuestions = [
      q101,
      q102,
      q103,
      ...p131.questions,
      ...p147.questions,
    ];

    return Exam(
      id: examId,
      title: 'TOEIC Reading Test 01 (Official ETS)',
      description: 'Đề thi mẫu TOEIC Reading chuẩn theo cấu trúc Part 5, Part 6 và Part 7',
      durationMinutes: 75,
      totalQuestions: allQuestions.length,
      isPublished: true,
      questions: allQuestions,
      passages: [p131, p147],
    );
  }
}
